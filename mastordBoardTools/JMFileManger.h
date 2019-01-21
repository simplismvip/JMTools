 //
//  JMFileManger.h
//  YaoYao
//
//  Created by JM Zhao on 2017/1/3.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JMFileManger : NSObject
// -- 单位转换
+ (void)clearCache:(NSString *)folderPath;
// -- 单位转换
+ (BOOL)removeFileByPath:(NSString *)fileName;
// -- 创建文件夹
+ (BOOL)creatDir:(NSString *)dirName;
// -- 单位转换
+ (NSMutableArray *)getFileFromDir:(NSString *)dir bySuffix:(NSString *)suffix;
// -- 单位转换
+ (NSString *)transforByteToValue:(double)value;
// -- 获取文件夹中的文件总大小
+ (NSString *)totalCache;
// -- 晴空缓存
+ (void)cleanTotalCache;
@end
