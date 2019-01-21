//
//  JMHelper.h
//  YaoYao
//
//  Created by JM Zhao on 2016/11/21.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JMHelper : NSObject
// 1> 字符串转字典
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

// 2> 字典转字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

// 1> 反序列化
+ (id)readJsonByPath:(NSString *)path;

// 2> 序列化
+ (NSString *)writeJson:(id)dic dir:(NSString *)dir;

// 画图数据
+ (NSString *)writeJsonToDocmentFile:(NSMutableDictionary *)dic;

// 获取文件大小
+ (long long)getFilesByExtension:(NSString *)extension path:(NSString *)filePath;

// 获取系统时间戳
+ (NSString *)timerString;

// 转换时间戳格式化
+ (NSString *)timestamp:(NSString *)timestring;

// rgb转换为颜色
+ (UIColor *)getColor:(NSString *)rgbS;

// 包装json数据
+ (NSMutableDictionary *)transformData:(NSMutableArray *)data;

// 坐标点转化
+ (CGPoint)tranPoint:(CGPoint)oldPoint oldSize:(CGSize)oldSize;

// 画线数据包装成json字典
+ (NSMutableDictionary *)pointArray:(NSMutableArray *)data type:(NSInteger)type fill:(BOOL)isFill isDash:(BOOL)dash imageName:(NSString *)imageName text:(NSString *)textString;

// 计算中点坐标
+ (CGPoint)getMidPoint:(CGPoint)p1 p2:(CGPoint)p2;

// 压缩照片质量和大小
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

// 产生随机数
+ (int)getRandom:(int)from to:(int)to;
@end
