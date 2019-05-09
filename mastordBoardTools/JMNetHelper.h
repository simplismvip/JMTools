//
//  JMNetHelper.h
//  KeepSleep
//
//  Created by JM Zhao on 16/10/19.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^uploadBlock)(CGFloat progress);
typedef void(^uploadStatus)(BOOL success, id  _Nullable responseObject, NSString * _Nullable url);
typedef void(^dataBlock)(id _Nullable data);
typedef void(^downloadSuccess)(NSMutableArray *success);
typedef void(^downloadFail)(NSError *fail);
typedef void(^progressBlock)(CGFloat progress, CGFloat sumSize);
@interface JMNetHelper : NSObject
/**
 *  设置URL根据输入key值
 *
 *  @param urlStr  url地址
 *  @param rdata   回调block
 *
 *  返回值为空
 */
+ (void)readData:(NSString *_Nullable)urlStr data:(dataBlock _Nullable )rdata;
/**
 *  设置URL根据输入key值
 *
 *  @param data             上传的数据
 *  @param progress   上传进度
 *  @param status           上传状态
 *
 *  返回值为空
 */
+ (void)uploadImageData:(NSData *_Nullable)data imageName:(NSString *_Nullable)name savePath:(NSString *_Nullable)savePath progress:(uploadBlock _Nullable )progress status:(uploadStatus _Nullable )status;

/**
 *  设置URL根据输入key值
 *_Nullable
 *  @param data             上传的数据
 *  @param progress   上传进度
 *  @param status           上传状态
 *
 *  返回值为空
 */
+ (void)uploadMp3File:(NSData *_Nullable)data savePath:(NSString *_Nullable)savePath uploadProgress:(uploadBlock _Nullable )progress status:(uploadStatus _Nullable )status;
/**
 *  设置URL根据输入key值
 *
 *  @param data             上传的数据
 *  @param progress   上传进度
 *  @param status           上传状态
 *
 *  返回值为空
 */
+ (void)uploadPdfFile:(NSData *_Nullable)data savePath:(NSString *_Nullable)savePath uploadProgress:(uploadBlock _Nullable)progress status:(uploadStatus _Nullable)status;
/**
 *  设置URL根据输入key值
 *
 *  @param urlString             上传的数据
 *  @param progress   上传进度
 *  @param success           上传状态
 *
 *  返回值为空
 */
+ (void)loadFileWithUrl:(NSString *_Nullable)urlString progress:(progressBlock _Nullable)progress success:(downloadSuccess _Nullable)success fail:(downloadFail _Nullable)fail;

/**
 *  设置URL根据输入key值
 *
 *  @param data             上传的数据
 *  @param params           上传参数，包括上传文件名字，保存路径，POST参数
 *  @param progress         上传进度回掉
 *  @param status           上传状态
 *
 *  返回值为空
 */
+ (void)wallUpload:(NSData *)data url:(NSString *)url params:(NSDictionary *)params progress:(uploadBlock)progress status:(uploadStatus)status;
/**
 *  设置URL根据输入key值
 *
 *  @param url             上传的数据
 *  @param params   上传进度
 *  @param rdata           上传状态
 *  @param fail           上传状态
 *
 *  返回值为空
 */
+(void)POST:(NSString *)url params:(NSDictionary *)params data:(dataBlock)rdata fail:(downloadFail)fail;
/**
 *  设置URL根据输入key值
 *
 *  @param url             上传的数据
 *  @param params   上传进度
 *  @param rdata           上传状态
 *  @param fail           上传状态
 *
 *  返回值为空
 */
+(void)GET:(NSString *)url params:(NSDictionary *)params data:(dataBlock)rdata fail:(downloadFail)fail;
@end
