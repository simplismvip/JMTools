//
//  JMSQLHelper.m
//  MasterBoard
//
//  Created by 赵俊明 on 2019/1/4.
//  Copyright © 2019 赵俊明. All rights reserved.
//

#import "JMSQLHelper.h"
#import "AFNetworking.h"
#import "FMDB.h"
#import "JMHelper.h"

static JMSQLHelper *_sqliteHelper = nil;
static NSString * const url_group = @"http://www.restcy.com/source/api/group_name.php";
static NSString * const urlStr = @"http://www.restcy.com/source/api/regist.php";
static NSString * const feedback = @"http://www.restcy.com/source/api/feedback.php";
@interface JMSQLHelper()<NSCopying,NSMutableCopying>
{
    FMDatabase *_db;
}
@end

@implementation JMSQLHelper
#pragma mark - ****************  单例生成  ****************
+ (instancetype)sharedDataBase
{
    if (_sqliteHelper == nil) {
        _sqliteHelper = [[JMSQLHelper alloc] init];
        [_sqliteHelper initDataBase];
    }
    return _sqliteHelper;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_sqliteHelper == nil) {_sqliteHelper = [super allocWithZone:zone];}
    return _sqliteHelper;
}
- (id)copy{return self;}
- (id)mutableCopy{return self;}
- (id)copyWithZone:(NSZone *)zone{return self;}
- (id)mutableCopyWithZone:(NSZone *)zone{return self;}
- (void)initDataBase{
    // 文件路径
    NSString *docuPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docuPath stringByAppendingPathComponent:@"group_name.sqlite"];
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    
    if ([_db open]){ // 创表
        // 1、创建查询昵称数据库
        NSString *create_sql =@"create table if not exists groupNickName(group_id integer primary key autoincrement not null, room_Name text not null, room_id text not null, owner_id text not null);";
        [_db executeUpdate:create_sql];
        
        // 2、创建账户信息数据库
        NSString *create_acc =@"create table if not exists per_info(acc_id integer primary key autoincrement not null, per_acc text not null,per_nickname text not null,per_avatar text not null);";
        [_db executeUpdate:create_acc];
        
        // 3、创建成员信息数据池，每次获取群组成员信息的时候现从本地数据池查找，找不到去服务器。
        NSString *create_member =@"create table if not exists per_info(memb_id integer primary key autoincrement not null, per_acc text not null, per_nickname text not null, per_avatar text not null);";
        [_db executeUpdate:create_member];
        
        // 4、创建聊天数据库
        NSString *chat_msg =@"create table if not exists chat_msg(msg_id integer primary key autoincrement not null, name text not null, avatar text not null, content text not null, time text not null);";
        [_db executeUpdate:chat_msg];
        [_db close];
    }
}
#pragma mark - ****************  网络请求  ****************
- (void)getstatusparams:(NSDictionary *)params url:(NSString *)url status:(loginStatus)status
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *code = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([code isKindOfClass:[NSDictionary class]]) {
            if (status) {status(code);}
        }else if ([code isKindOfClass:[NSArray class]]){
            if (status) {status(code);}
        }else{
            if (status) {status(@{@"info":@"None Objects"});}
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (status) {status(@{@"error":denyNil(error)});}
    }];
}
#pragma mark - **************** 数据库代码  ****************
- (void)regist:(NSDictionary *)infoDic status:(loginStatus)sta
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *insert = [NSString stringWithFormat:@"insert into per_info(per_acc,per_nickname,per_avatar)values('%@','%@','%@')",infoDic[@"per_acc"],infoDic[@"per_nickname"],infoDic[@"per_avatar"]];
    params[@"regist"] = insert;
    params[@"target"] = @"0";
    
    // @"http://www.restcy.com/source/regist.php?acc=tonyzhao&pwd=123456789&nickname=tiger&sex=mail&avatar=header.png&sign=123&email=163.com&phonenum=1234"
    [self getstatusparams:params url:urlStr status:^(NSDictionary *status) {
        // 注册成功后写入本地
        [_db open];
        [_db executeUpdate:insert];
        [_db close];
        if (sta) {sta(status);}
    }];
}

#pragma mark -- 插入远程和本地数据库
- (void)regist:(NSString *)room_id rname:(NSString *)r_name ownerID:(NSString *)o_id datas:(void(^)(NSDictionary *dic))datas
{
    NSDictionary *dic = @{
                          @"target":@"0",@"r_id":denyNil(room_id),
                          @"r_name":denyNil(r_name),
                          @"o_id":denyNil(o_id)};
    // 1、插入远程
    [self getstatusparams:dic url:url_group status:^(NSDictionary *status) {
        // 2、插入本地
        NSString *insert = [NSString stringWithFormat:@"insert into groupNickName(room_Name,room_id,owner_id) values ('%@','%@','%@');",r_name,room_id,o_id];
        [_db open];
        [_db executeUpdate:insert];
        [_db close];
        if (datas) {datas(status);}
    }];
}

- (void)updateOrDelete:(NSDictionary *)infoDic status:(loginStatus)sta
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"target"] = @"2";
    params[@"update"] = infoDic[@"update"];
    // 1、更新远程
    [self getstatusparams:params url:urlStr status:^(NSDictionary *status) {
        // 2、更新本地数据库
        [_db open];
        [_db executeUpdate:params[@"update"]];
        [_db close];
        if (sta) {sta(status);}
    }];
}

#pragma mark - **************** 群组昵称和账户映射
- (void)check:(NSString *)room_name cur_uuid:(NSString *)cur_uuid isJoin:(BOOL)join succsss:(void(^)(BOOL succsss, NSString *reasion))succsss
{
    [_db open];
    FMResultSet *reset = [_db executeQuery:[NSString stringWithFormat:@"select * from groupNickName where room_Name = '%@';",room_name]];
    NSMutableArray *itemsArr = [NSMutableArray array];
    while ([reset next]) {
        NSString *room_id = [reset stringForColumn:@"room_id"];
        [itemsArr addObject:denyNil(room_id)];
        NSString *owner_id = [reset stringForColumn:@"owner_id"];
        [itemsArr addObject:denyNil(owner_id)];
    }
    [_db close];
    
    if (itemsArr.count>0) {
        // 本地查询到结果,可以直接加入、创建
        if (succsss) {succsss(YES,@"创建群组成功");}
    }else{
        // 本地没有查询到结果，去网络请求
        [self getstatusparams:@{@"target":@"1",@"r_name":denyNil(room_name)} url:url_group status:^(NSDictionary *status) {
            if ([status isKindOfClass:[NSDictionary class]]) { // 说明服务器存在
                if (join) {
                    // 加入模式：网络查询到结果，可以加入
                    if (succsss) {succsss(YES,@"加入群组成功");}
                }else{
                    // 创建模式：网络查询到结果，两种情况
                    // 1、创建该昵称账户是当前账户，可以创建。
                    // 2、创建该昵称账户不是当前账户，不可以创建。
                    if ([status[@"room_id"] isEqualToString:cur_uuid]) {
                        if (succsss) {succsss(YES,@"创建群组成功");}
                    }else{
                        if (succsss) {succsss(NO,@"群组已存在，请加入或输入其他群组号");}
                    }
                }
            }else{ // 说明服务器不存在。此时返回：NSNull
                if (join) {
                    // 加入模式：网络没有查询到结果，弹出不存在房间错误警告
                    if (succsss) {succsss(NO,@"群组不存在，请检查群组号是否正确");}
                }else{
                    // 服务器不存在，需要插入服务器
                    [self regist:room_name rname:room_name ownerID:cur_uuid datas:^(NSDictionary * _Nonnull dic) {
                        // 创建模式：网络没有查询到结果，可以创建房间
                        if (succsss) {succsss(YES,@"创建群组成功");}
                        NSLog(@"%@-----------",dic);
                    }];
                }
            }
        }];
    }
}

#pragma mark - **************** 查询用户信息
- (void)userInfo:(NSDictionary *)infoDic status:(loginStatus)sta
{
    // 1、先检查本地用户信息池
    [_db open];
    NSString *sqlStr = [NSString stringWithFormat:@"select per_nickname,per_avatar from per_info where per_acc = '%@';",infoDic[@"acc"]];
    FMResultSet *reset = [_db executeQuery:sqlStr];
    NSDictionary *dic;
    while ([reset next]) {
        dic = @{
                @"per_nickname":denyNil([reset stringForColumn:@"per_nickname"]),
                @"per_avatar":denyNil([reset stringForColumn:@"per_avatar"])};
        break;
    }
    [_db close];
    if (dic) {
        if (sta) {sta(dic);}
    }else{
        // 2、再查询远程
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"target"] = @"4";
        params[@"info"] = infoDic[@"acc"];
        [self getstatusparams:params url:urlStr status:^(NSDictionary *status) {
            if (sta) {sta(status);}
        }];
    }
}

- (NSArray *)queryRoomDate
{
    // 1、先检查本地用户信息池
    [_db open];
    FMResultSet *reset = [_db executeQuery:[NSString stringWithFormat:@"select * from groupNickName"]];
    NSMutableArray *list = [NSMutableArray array];
    while ([reset next]) {
        NSDictionary *dic = @{
                              @"room_Name":denyNil([reset stringForColumn:@"room_Name"]),
                              @"room_id":denyNil([reset stringForColumn:@"room_id"]),
                              @"owner_id":denyNil([reset stringForColumn:@"owner_id"])};
        [list addObject:dic];
    }
    [_db close];
    return list.copy;
}

#pragma mark - **************** 历史消息
- (void)insert_chatMsg:(NSDictionary *)info
{
    [_db open];
    NSString *insert = [NSString stringWithFormat:@"insert into chat_msg(name,avatar,content,time) values ('%@','%@','%@','%@');",info[@"fname"],info[@"avatar"],info[@"content"],[JMHelper timerString]];
    [_db executeUpdate:insert];
    [_db close];
}

- (NSMutableArray *)query_chatMsg
{
    [_db open];
    FMResultSet *reset = [_db executeQuery:[NSString stringWithFormat:@"select * from chat_msg"]];
    NSMutableArray *list = [NSMutableArray array];
    while ([reset next]) {
        NSDictionary *dic = @{
                              @"fname":denyNil([reset stringForColumn:@"name"]),
                              @"avatar":denyNil([reset stringForColumn:@"avatar"]),
                              @"time":denyNil([reset stringForColumn:@"time"]),
                              @"content":denyNil([reset stringForColumn:@"content"])
                              };
        [list addObject:dic];
    }
    [_db close];
    return list;
}

- (void)clear_all_chatMsg
{
    [_db open];
    [_db executeUpdate:@"delete from chat_msg;"];
    [_db close];
}

#pragma mark - **************** 添加反馈到数据库
- (void)feedback:(NSString *)data uuid:(NSString *)u_uuid sra:(void(^)(NSDictionary *info))sta
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"target"] = @"0";
    params[@"feed_info"] = data;
    params[@"user"] = u_uuid;
    [self getstatusparams:params url:feedback status:^(NSDictionary *status) {
        if (sta) {sta(status);}
    }];
}

- (id)values:(id)value
{
    return value?value:@"null";
}

@end
