//
//  JMBuyHelper.h
//  Creativity
//
//  Created by JM Zhao on 2017/7/6.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMBuyHelper : NSObject
/**
 *  获取当前账户是否是VIP
 *
 *  @return 是否是VIP用户
 */
+ (BOOL)isVip;
/**
 *  设置当前账户是为VIP
 *
 *  @return 是否是设置VIP成功
 */
+ (BOOL)setVIP;
@end
