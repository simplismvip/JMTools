//
//  JMNetTools.h
//  AFNetworking
//
//  Created by 赵俊明 on 2019/3/11.
//

#import <Foundation/Foundation.h>
#define timeCount .2
#define start1 -0.33
#define urlString @"http://storage.360buyimg.com/jdmobile/JDMALL-PC2.apk"//100M

NS_ASSUME_NONNULL_BEGIN
typedef void (^measureBlock) (float speed);
typedef void (^finishMeasureBlock) (float speed);
@interface JMNetTools : NSObject
- (instancetype)initWithblock:(measureBlock)measureBlock finishMeasureBlock:(finishMeasureBlock)finishMeasureBlock failedBlock:(void (^) (NSError *error))failedBlock;
-(void)startMeasur;
-(void)stopMeasur;
#pragma mark - **************** 速度下载
+ (NSString *)to_formattedBandWidth:(unsigned long long)size;
+ (int)to_formatBandWidthInt:(unsigned long long) size;
+ (NSString *)to_formatBandWidth:(unsigned long long)size;
+ (NSString *)to_formattedFileSize:(unsigned long long)size;
+ (NSString *)to_formattedFileSize:(unsigned long long)size suffixLenth:(NSInteger *)length;
+ (unsigned long long)to_antiFormatBandWith:(NSString *)sizeStr;
@end
NS_ASSUME_NONNULL_END
