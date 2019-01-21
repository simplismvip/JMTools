//
//  StaticClass.h
//  Player
//
//  Created by lanouhn on 16/1/26.
//  Copyright © 2016年 ZhaoJM. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface StaticClass : NSObject

// 设置当前网络是否可用
+ (void)setNetwork:(BOOL)network;
+ (BOOL)getNetwork;

// 设置当前是勿扰模式
+ (void)setQuiet:(BOOL)quiet;
+ (BOOL)getQuiet;

// 设置照片是否是全屏显示还是剧中显示
+ (void)setFillimage:(BOOL)fillimage;
+ (BOOL)getFillimage;

// 设置是否清除照片
+ (void)setClear:(BOOL)clear;
+ (BOOL)getClear;

// 设置远程是否可用
+ (void)setRemote:(BOOL)remote;
+ (BOOL)getRemote;

+ (void)setNumber:(NSInteger)number;
+ (NSInteger)getNumber;

// 设置线宽
+ (void)setLineWidth:(CGFloat)linewidth;
+ (CGFloat)getLineWidth;

// 设置颜色
+ (void)setColor:(UIColor *)color;
+ (UIColor *)getColor;

// 设置透明度
+ (void)setAlpha:(CGFloat)alpha;
+ (CGFloat)getAlpha;

// 设置字体
+ (void)setFontSize:(CGFloat)fontSize;
+ (CGFloat)getFontSize;

+ (void)setFontName:(NSString *)fontName;
+ (NSString *)getFontName;

+ (void)setFontType:(NSInteger)fontType;
+ (NSInteger)getFontType;

// 设置笔画种类
+ (void)setPaintType:(NSInteger)paintType;
+ (NSInteger)getPaintType;

// 设置填充，
+ (void)setFillType:(BOOL)fillType;
+ (BOOL)getFillType;

// 虚线
+ (void)setDashType:(BOOL)dashType;
+ (BOOL)getDashType;

// 设置填充，
+ (void)setPaintImage:(NSString *)paintImage;
+ (NSString *)getPaintImage;

// 虚线
+ (void)setPaintText:(NSString *)paintText;
+ (NSString *)getPaintText;

@end
