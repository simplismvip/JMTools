//
//  NSString+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NSString+Extension.h"

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

- (NSString *)formatTspString:(NSString *)format
{
    NSTimeInterval _interval=[self doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format?format:@"yyyy-MM-dd HH:mm"];
    return [objDateformat stringFromDate: date];
}

+ (NSString *)createTspString
{
    NSTimeInterval tmp =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
    return [[NSString stringWithFormat:@"%f", tmp] componentsSeparatedByString:@"."].firstObject;
}

#pragma mark - **************** 正则判断
- (BOOL)isAccount
{
    // 制定的规则
    NSString *patten = @"^[a-z0-9_-]{3,16}$";
    return  [self match:patten];
}

- (BOOL)isPasswd
{
    // 制定的规则
    NSString *patten = @"^[a-zA-Z0-9_-]{3,18}$";
    return  [self match:patten];
}

//一个正则表达式，只含有汉字、数字、字母、下划线不能以下划线开头和结尾。
- (BOOL)isSpecialAlpha
{
    // 制定的规则
    NSString *patten = @"^(?!_)(?!.*?_$)[a-zA-Z0-9_-\u4e00-\u9fa5]+$";
    return  [self match:patten];
}

- (BOOL)isQQ
{
    // 制定的规则
    NSString *patten = @"^[1-9]\\d{4,10}$";
    
    return  [self match:patten];
}

- (BOOL)isPhoneNumber
{
    // 制定的规则
    NSString *patten = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    
    return  [self match:patten];
}

- (BOOL)isEmail
{
    // 制定的规则
    NSString *patten = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    return  [self match:patten];
}

- (BOOL)isIpAddress
{
    // 制定的规则
    NSString *patten = @"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$";
    
    return  [self match:patten];
}

- (BOOL)isUrl
{
    // 制定的规则
    NSString *patten = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    
    // NSString *patten1 = @"^(http://|https://)?((?:[A-Za-z0-9]+-[A-Za-z0-9]+|[A-Za-z0-9]+)\.)+([A-Za-z]+)[/\?\:]?.*$";
    
    return  [self match:patten];
}


- (BOOL)match:(NSString *)patten
{
    // 匹配规则
    NSRegularExpression *regul = [NSRegularExpression regularExpressionWithPattern:patten options:0 error:nil];
    
    // 返回匹配结果
    NSArray *result = [regul matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return  result.count > 0;
}

#pragma mark - **************** EMOJI方法
+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

- (NSString *)emoji
{
    return [NSString emojiWithStringCode:self];
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode
{
    char *charCode = (char *)stringCode.UTF8String;
    int intCode = (int)strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:intCode];
}

// 判断是否是 emoji表情
- (BOOL)isEmoji
{
    BOOL returnValue = NO;
    
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }
    
    return returnValue;
}

+ (NSString *)transformChinese:(NSString *)chinese
{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    
    //返回最近结果
    return pinyin;
}
@end
