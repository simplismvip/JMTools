//
//  JMHelper.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/21.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMHelper.h"
#import "StaticClass.h"

@implementation JMHelper

// 字符串转字典
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

// 字典转字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// 画线数据包装成json字典
+ (NSMutableDictionary *)pointArray:(NSMutableArray *)data type:(NSInteger)type fill:(BOOL)isFill isDash:(BOOL)dash imageName:(NSString *)imageName text:(NSString *)textString
{
    if (imageName == nil) {imageName = @"0";}
    if (textString == nil) {textString = @"0";}
    
    NSString *tp = [NSString stringWithFormat:@"%ld", type];
    NSString *fl = [NSString stringWithFormat:@"%d", isFill];
    NSString *da = [NSString stringWithFormat:@"%d", dash];
    NSString *lc = [self getRGB:[StaticClass getColor]];
    NSString *ap = [NSString stringWithFormat:@"%.2f", [StaticClass getAlpha]];
    NSString *lw = [NSString stringWithFormat:@"%.2f", [StaticClass getLineWidth]];
    
    NSString *fontType = [NSString stringWithFormat:@"%ld", [StaticClass getFontType]];
//    NSString *fontSize = [NSString stringWithFormat:@"%.2f", [StaticClass getFontSize]];
    NSString *fontname = [StaticClass getFontName];
    CGFloat s_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat s_height = [UIScreen mainScreen].bounds.size.height;
    NSString *screenSize = NSStringFromCGSize(CGSizeMake(s_width, s_height));
    
    return [NSMutableDictionary dictionaryWithDictionary:@{@"tp":tp, @"ap":ap, @"lw":lw, @"lc":lc, @"fl":fl, @"dash":da, @"image":imageName, @"text":textString, @"fontType":fontType, @"fontName":fontname, @"screen":screenSize, @"dt":[data mutableCopy]}];
}

// 1> rgb转换为颜色
+ (UIColor *)getColor:(NSString *)rgbS
{
    NSArray *array = [rgbS componentsSeparatedByString:@","];
    CGFloat r = [array[0] floatValue];
    CGFloat g = [array[1] floatValue];
    CGFloat b = [array[2] floatValue];
    CGFloat f = [array[3] floatValue];
//    JMLog(@"%f, %f, %f", r, g, b);
    return [UIColor colorWithRed:r green:g blue:b alpha:f];;
}

// 2> 颜色转换为rgb
+ (NSString *)getRGB:(UIColor *)color
{
    NSMutableArray *mRGB = [NSMutableArray arrayWithArray:[[NSString stringWithFormat:@"%@", color] componentsSeparatedByString:@" "]];
    [mRGB removeObjectAtIndex:0];
    if (mRGB.count<4) {
        
        for (int i =0; i <4-mRGB.count+1; i ++) {
            
            [mRGB insertObject:@"0" atIndex:0];
        }
    }
    return [mRGB componentsJoinedByString:@","];
}

// 反序列化
+ (id)readJsonByPath:(NSString *)path
{
    // json反序列化
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    if (data) {
        
        id JsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        return JsonObject;
    }
    return nil;
}

// 序列化
+ (NSString *)writeJson:(id)dic dir:(NSString *)dir
{
    NSString *path;
    if (dir == nil) {
        
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", [JMHelper timerString]]];
    }else{
    
        path = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", [JMHelper timerString]]];;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        
        // 写入本地文件
        if ([jsonData writeToFile:path atomically:YES]) {
        
            return path;
        }else{
        
            return path;
        }
    }else{
        return nil;
    }
}

// 序列化
+ (NSString *)writeJsonToDocmentFile:(NSMutableDictionary *)dic
{
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSTimeInterval tmp =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
    NSString *fileName = [NSString stringWithFormat:@"%f.json", tmp];
    NSString *path = [cachesDir stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        
        // 写入本地文件
        if ([jsonData writeToFile:path atomically:YES]) {
            
            return path;
        }else{
            
            return path;
        }
    }else{
        return nil;
    }
}


/******************************************************************************/
+ (NSMutableDictionary *)transformData:(NSMutableArray *)data
{
    return [NSMutableDictionary dictionaryWithDictionary:@{@"dt":[data mutableCopy]}];
}

+ (NSString *)jsonString:(CGPoint)start en:(CGPoint)end type:(NSInteger)type back:(BOOL)isBack clearAll:(BOOL)isClear fill:(BOOL)isFill
{
    NSString *tp = [NSString stringWithFormat:@"%ld", type];
    NSString *st = NSStringFromCGPoint(start);
    NSString *en = NSStringFromCGPoint(end);
    NSArray *dt = @[st, en];
    NSString *lw = [NSString stringWithFormat:@"%.2f", [StaticClass getLineWidth]];
    NSString *lc = [self getRGB:[StaticClass getColor]];
    NSString *bk = [NSString stringWithFormat:@"%d", isBack];
    NSString *cl = [NSString stringWithFormat:@"%d", isClear];
    NSString *fl = [NSString stringWithFormat:@"%d", isFill];
    
    return [self dictionaryToJson:@{@"tp":tp, @"st":st, @"en":en, @"lw":lw, @"lc":lc, @"bk":bk, @"cl":cl, @"fl":fl, @"dt":dt}];
}

+ (NSMutableDictionary *)jsonData:(CGPoint)start en:(CGPoint)end type:(NSInteger)type back:(BOOL)isBack clearAll:(BOOL)isClear fill:(BOOL)isFill
{
    NSString *tp = [NSString stringWithFormat:@"%ld", type];
    NSString *st = NSStringFromCGPoint(start);
    NSString *en = NSStringFromCGPoint(end);
    NSArray *dt = @[st, en];
    NSString *lw = [NSString stringWithFormat:@"%.2f", [StaticClass getLineWidth]];
    NSString *lc = [self getRGB:[StaticClass getColor]];
    NSString *bk = [NSString stringWithFormat:@"%d", isBack];
    NSString *cl = [NSString stringWithFormat:@"%d", isClear];
    NSString *fl = [NSString stringWithFormat:@"%d", isFill];
    return [NSMutableDictionary dictionaryWithDictionary:@{@"tp":tp, @"lw":lw, @"lc":lc, @"bk":bk, @"cl":cl, @"fl":fl, @"dt":dt}];
}

+ (long long)getFilesByExtension:(NSString *)extension path:(NSString *)filePath
{
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL dir = NO;
    BOOL exist = [manger fileExistsAtPath:filePath isDirectory:&dir];
    long long sumSize = 0;
    
    // 文件不存在
    if (!exist) return 0;
    
    if (dir) {
        
        NSArray *array = [manger contentsOfDirectoryAtPath:filePath error:nil];
        
        for (NSString *fileName in array) {
            
            if ([[[fileName pathExtension] lowercaseString] isEqualToString:extension]) {
                
                sumSize += [[manger attributesOfItemAtPath:[filePath stringByAppendingPathComponent:fileName] error:nil] fileSize];
            }
        }
    }
    
    return sumSize/1048576.f;
}

+ (NSString *)timerString
{
    NSTimeInterval tmp =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
    return [[NSString stringWithFormat:@"%f", tmp] componentsSeparatedByString:@"."].firstObject;
}

+ (NSString *)timestamp:(NSString *)timestring
{
    // @"1970-01-01T00:00:00Z"
    NSTimeInterval _interval=[timestring doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [objDateformat stringFromDate: date];
}

// 坐标点转化
+ (CGPoint)tranPoint:(CGPoint)oldPoint oldSize:(CGSize)oldSize
{
    CGFloat s_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat s_height = [UIScreen mainScreen].bounds.size.height;
    CGFloat scare = [UIScreen mainScreen].scale;
    CGFloat scalex = s_width * scare / oldSize.width;
    CGFloat scaley = s_height * scare / oldSize.height;
    
    CGFloat x = oldPoint.x * scalex / scare;
    CGFloat y = oldPoint.y * scaley / scare;
    
    return CGPointMake(x,y);
}

+ (CGPoint)getMidPoint:(CGPoint)p1 p2:(CGPoint)p2
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

// 压缩照片质量和大小
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return data;
}

+ (int)getRandom:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}
@end
