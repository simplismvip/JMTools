//
//  JMNetHelper.m
//  KeepSleep
//
//  Created by JM Zhao on 16/10/19.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "JMNetHelper.h"
#import "AFNetworking.h"
#import "JMHelper.h"

@implementation JMNetHelper
static NSString * const upload_url = @"http://www.restcy.com/source/api/wallNew_upload.php";

+ (void)readData:(NSString *)urlStr data:(dataBlock)rdata
{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newString = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newString]];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            id getData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (rdata) {rdata(getData);}
        }else{
            rdata(nil);
        }
    }];
    
    [task resume];
}

#pragma mark - **************** POST请求
+(void)POST:(NSString *)url params:(NSDictionary *)params data:(dataBlock)rdata fail:(downloadFail)fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id getData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if (rdata) {rdata(getData);}
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {fail(error);}
    }];
}

#pragma mark - **************** GET请求
+(void)GET:(NSString *)url params:(NSDictionary *)params data:(dataBlock)rdata fail:(downloadFail)fail
{
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id getData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (rdata) {rdata(getData);}
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {fail(error);}
    }];
}

// 上传头像
+ (void)uploadImageData:(NSData *)data imageName:(NSString *)name savePath:(NSString *_Nullable)savePath progress:(uploadBlock)progress status:(uploadStatus)status
{
    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithArray:@[@"text/html",@"application/octet-stream"]];
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:savePath forKey:@"path"];
    
    [params setValue:savePath forKey:@"uname"];
    [manager POST:upload_url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 设置上传图片的名字
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [JMHelper timerString]];
        [formData appendPartWithFileData:data name:@"file" fileName:name?name:fileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {progress(uploadProgress.fractionCompleted);}

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (status) {
            status(1,responseObject,[NSString stringWithFormat:@"http://www.restcy.com/source/%@/%@", savePath.lastPathComponent,responseObject[@"fileName"]]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (status) {status(0,error,@"error");}
    }];
}

// 上传音频文件
+ (void)uploadMp3File:(NSData *)data savePath:(NSString *_Nullable)savePath uploadProgress:(uploadBlock)progress status:(uploadStatus)status
{
    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithArray:@[@"text/html",@"application/octet-stream"]];
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:savePath forKey:@"path"];
    [manager POST:upload_url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 设置上传文件的名字
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3", [JMHelper timerString]];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"audio/mpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (status) {
            status(1,responseObject,[NSString stringWithFormat:@"http://www.restcy.com/source/temps/%@",responseObject[@"fileName"]]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (status) {
            status(0,error,@"error");
        }
    }];
}

// 上传pdf,ppt,world文件
+ (void)uploadPdfFile:(NSData *)data savePath:(NSString *_Nullable)savePath uploadProgress:(uploadBlock)progress status:(uploadStatus)status
{
    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithArray:@[@"text/html",@"application/octet-stream"]];
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:savePath forKey:@"path"];
    [manager POST:upload_url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 设置上传文件的名字
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3", [JMHelper timerString]];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"audio/mpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (status) {
            status(1,responseObject,[NSString stringWithFormat:@"http://www.restcy.com/source/upload/%@", responseObject[@"fileName"]]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (status) {status(0,error,@"error");}
    }];
}

#pragma mark - **************** 下载请求
+ (void)loadFileWithUrl:(NSString *)urlString progress:(progressBlock)progress success:(downloadSuccess)success fail:(downloadFail)fail
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat size = (CGFloat)downloadProgress.totalUnitCount/1048576.f;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {progress(downloadProgress.fractionCompleted, size);}
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {success([NSMutableArray arrayWithObjects:responseObject, nil]);}
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {fail(error);}
    }];
}

#pragma mark - **************** 上传请求
+ (void)wallUpload:(NSData *)data url:(NSString *)url params:(NSDictionary *)params progress:(uploadBlock)progress status:(uploadStatus)status
{
    NSLog(@"获得网络管理者");
    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithArray:@[@"text/html",@"application/octet-stream"]];
    NSDictionary *post_params = params[@"post"];
    [manager POST:url parameters:post_params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 设置上传图片的名字
        NSString *name = params[@"name"];
        [formData appendPartWithFileData:data name:@"file" fileName:name mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {progress(uploadProgress.fractionCompleted);}
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (status) {
            NSString *savePath = params[@"savePath"];
            status(1,responseObject,[NSString stringWithFormat:@"http://www.restcy.com/source/%@/%@", savePath.lastPathComponent,responseObject[@"fileName"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (status) {status(0,error,@"error");}
    }];
}


@end
