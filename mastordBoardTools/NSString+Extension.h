//
//  NSString+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
// 获取系统时间戳
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
// 获取系统时间戳
- (CGSize)sizeWithFont:(UIFont *)font;
// 是否是QQ号
- (BOOL)isQQ;
// 是否是IP地址
- (BOOL)isIpAddress;
// 是否是手机号
- (BOOL)isPhoneNumber;
// 是否是邮箱
- (BOOL)isEmail;
// 是否是URL
- (BOOL)isUrl;
// 是否是账户
- (BOOL)isAccount;
// 是否是密码
- (BOOL)isPasswd;
// 获取系统时间戳
- (BOOL)isSpecialAlpha;
// 格式化字符串
- (NSString *)formatTspString:(NSString *)format;
// 获取系统时间戳
+ (NSString *)createTspString;
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(int)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;
@end
