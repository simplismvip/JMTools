//
//  JMSQLHelper.h
//  MasterBoard
//
//  Created by 赵俊明 on 2019/1/4.
//  Copyright © 2019 赵俊明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^loginStatus)(NSDictionary *status);
@interface JMSQLHelper : NSObject
+ (instancetype)sharedDataBase;
/**
 *  注册用户信息到数据库
 *
 *  @param infoDic  参数dic
 *  @param sta  回调block
 *
 *  返回值为空
 */
- (void)regist:(NSDictionary *)infoDic status:(loginStatus)sta;
/**
 *  注册f群组号到数据库
 *
 *  @param room_id  参数dic
 *  @param r_name  回调block
 *  @param o_id  回调block
 *  @param datas  回调block
 *
 *  返回值为空
 */
- (void)regist:(NSString *)room_id rname:(NSString *)r_name ownerID:(NSString *)o_id datas:(void(^)(NSDictionary *dic))datas;
/**
 *  检车输入的群组昵称是否可用
 *  @param cur_uuid 当前账户的 u_uuid
 *  @param room_name  参数dic
 *  @param join  回调block
 *  @param succsss  回调block
 *
 *  返回值为空
 */
- (void)check:(NSString *)room_name cur_uuid:(NSString *)cur_uuid isJoin:(BOOL)join succsss:(void(^)(BOOL succsss, NSString *reasion))succsss;
/**
 *  获取账户信息
 *
 *  @param infoDic  参数dic
 *  @param sta   回调block
 *
 *  返回值为空
 */
- (void)userInfo:(NSDictionary *)infoDic status:(loginStatus)sta;
/**
 *  更新或者删除账户信息
 *
 *  @param infoDic  参数dic
 *  @param sta   回调block
 *
 *  返回值为空
 */
- (void)updateOrDelete:(NSDictionary *)infoDic status:(loginStatus)sta;
/**
 *  查询房间数据
 *
 *  返回值为空
 */
- (NSArray *)queryRoomDate;

#pragma mark - **************** 历史消息
/**
 *  插入聊天数据
 *
 *  @param info  参数dic
 *
 *  返回值为空
 */
- (void)insert_chatMsg:(NSDictionary *)info;
/**
 *  查询表中所有数据
 *
 *  返回值为空
 */
- (NSMutableArray *)query_chatMsg;
/**
 *  清空表中的所有数据
 *
 *  返回值为空
 */
- (void)clear_all_chatMsg;
/**
 *  返回反馈数据
 */
- (void)feedback:(NSString *)data uuid:(NSString *)u_uuid sra:(void(^)(NSDictionary *info))sta;
@end

NS_ASSUME_NONNULL_END
