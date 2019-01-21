//
//  JMFileManger.m
//  YaoYao
//
//  Created by JM Zhao on 2017/1/3.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMFileManger.h"

@implementation JMFileManger

+ (BOOL)creatDir:(NSString *)dirName
{
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL dir        = NO;
    BOOL exist       = [manger fileExistsAtPath:dirName isDirectory:&dir];
    
    // 文件不存在
    if (!exist&&!dir) {
        return [manger createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        return NO;
    }
}

+ (NSMutableArray *)getFileFromDir:(NSString *)dir bySuffix:(NSString *)suffix
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSError *error;
    NSArray *array = [manger contentsOfDirectoryAtPath:dir error:&error];
    NSMutableArray *pngs = [NSMutableArray array];
    if (!error) {
        
        for (NSString *name in array) {
            
            if ([name hasSuffix:suffix]) {
                
                [pngs addObject:[dir stringByAppendingPathComponent:name]];
            }
        }
    }
    
    return pngs;
}

// 根据路径删除文件
+ (BOOL)removeFileByPath:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 文件夹路径
    NSString *pathDir = fileName;
    
    BOOL isDir               = NO;
    BOOL existed               = [fileManager fileExistsAtPath:pathDir isDirectory:&isDir];
    
    // 文件夹不存在直接返回
    if (!existed){
        
        return NO;
        
    }else{ // 文件夹存在
        
        return [fileManager removeItemAtPath:fileName error:nil];
    }
}

+ (void)clearCache:(NSString *)folderPath
{
    NSError *error;
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    
    for (NSString *dir in array) {
        
        NSArray *jsons = [JMFileManger getFileFromDir:[folderPath stringByAppendingPathComponent:dir] bySuffix:@"gif"];
        
        if (jsons.count == 0) {
            
            [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:dir] error:nil];
        }
    }
}

// 照片组文件夹模型，第一层照片组文件名，第二层文件夹内照片文件
+ (NSString *)totalCache
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSArray *folders = [manger contentsOfDirectoryAtPath:[self cache] error:nil];
    NSInteger sizeValue = 0;
    for (NSString *name in folders) {
        if ([name isEqualToString:@".DS_Store"]) {continue;}
        NSString *subPath = [[self cache] stringByAppendingPathComponent:name];
        if ([subPath hasSuffix:@"jpg"]) {
            NSDictionary *dic1 = [manger attributesOfItemAtPath:subPath error:nil];
            sizeValue += [dic1[@"NSFileSize"] integerValue];
        }
    }
    return [self transforByteToValue:sizeValue];
}

+ (void)cleanTotalCache
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSArray *folders = [manger contentsOfDirectoryAtPath:[self cache] error:nil];
    for (NSString *name in folders) {
        NSString *subPath = [[self cache] stringByAppendingPathComponent:name];
        if ([subPath hasSuffix:@"jpg"]) {
            NSError *error = nil;
            [manger removeItemAtPath:subPath error:&error];
            if (error) {
                NSLog(@"清空缓存删除文件错误！%@",error.description);
            }
        }
    }
}

+ (NSString *)transforByteToValue:(double)value
{
    double convertedValue = value;
    int multiplyFactor = 0;
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB", @"PB", @"EB", @"ZB",nil];
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

+ (NSString *)cache
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
@end
