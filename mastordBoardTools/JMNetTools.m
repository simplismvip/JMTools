//
//  JMNetTools.m
//  AFNetworking
//
//  Created by 赵俊明 on 2019/3/11.
//

#import "JMNetTools.h"

@interface JMNetTools ()
{
    measureBlock   infoBlock;
    finishMeasureBlock   fmeasureBlock;
    int                           _second;
    NSMutableData*                _connectData;
    NSMutableData*                _oneMinData;
    NSURLConnection *             _connect;
    NSTimer*                      _timer;
}

@property (copy, nonatomic) void (^faildBlock) (NSError *error);

@end

@implementation JMNetTools

/**
 *  初始化测速方法
 *
 *  @param measureBlock       实时返回测速信息
 *  @param finishMeasureBlock 最后完成时候返回平均测速信息
 *
 *  @return MeasurNetTools对象
 */
- (instancetype)initWithblock:(measureBlock)measureBlock finishMeasureBlock:(finishMeasureBlock)finishMeasureBlock failedBlock:(void (^) (NSError *error))failedBlock
{
    self = [super init];
    if (self) {
        infoBlock = measureBlock;
        fmeasureBlock = finishMeasureBlock;
        _faildBlock = failedBlock;
        _connectData = [[NSMutableData alloc] init];
        _oneMinData = [[NSMutableData alloc] init];
    }
    return self;
}

/**
 *  开始测速
 */
-(void)startMeasur
{
    [self meausurNet];
}

/**
 *  停止测速，会通过block立即返回测试信息
 */
-(void)stopMeasur
{
    [self finishMeasure];
}

-(void)meausurNet
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeCount target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    NSURL    *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _connect = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [_timer fire];
    _second = 0;
    
}

-(void)countTime{
    ++_second;
    if (_second == 15/timeCount) {
        [self finishMeasure];
        return;
    }
    float speed = _oneMinData.length;
    
    infoBlock(speed);
    
    //清空数据
    [_oneMinData resetBytesInRange:NSMakeRange(0, _oneMinData.length)];
    [_oneMinData setLength:0];
}

/**
 * 测速完成
 */
-(void)finishMeasure{
    
    [_timer invalidate];
    _timer = nil;
    if(_second!=0){
        float finishSpeed = _connectData.length / _second;
        fmeasureBlock(finishSpeed);
    }
    
    [_connect cancel];
    _connectData = nil;
    _connect = nil;
}

#pragma mark - urlconnect delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.faildBlock) {
        self.faildBlock(error);
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_connectData appendData:data];
    [_oneMinData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    [self finishMeasure];
}

- (void)dealloc
{
    if ([_timer isValid]) {
        [self finishMeasure];
    }
}

#pragma mark - **************** 下载速度
+ (NSString *)to_formattedBandWidth:(unsigned long long)size
{
    NSString *formattedStr = nil;
    size = size;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0 KB",@"");
        
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qubytes", size];
        
    }else if (size >= 1024 && size < pow(1024, 2)){
        formattedStr = [NSString stringWithFormat:@"%quKB", (size / 1024)];
        
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        int intsize = size / pow(1024, 2);
        formattedStr = [NSString stringWithFormat:@"%dMB", intsize];
        
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dGB", intsize];
    }
    
    return formattedStr;
}
+ (int)to_formatBandWidthInt:(unsigned long long) size
{
    
    size *= 8;
    int intsize = 0;
    if (size >= pow(1024, 2) && size < pow(1024, 3)){
        intsize = size / pow(1024, 2);
        unsigned long long l = pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
    }
    return intsize;
}

+ (NSString *)to_formatBandWidth:(unsigned long long)size
{
    size *=8;
    
    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0",@"");
        
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qu", size];
        
    }else if (size >= 1024 && size < pow(1024, 2)){
        int intsize = (int)(size / 1024);
        int model = size % 1024;
        if (model > 512) {
            intsize += 1;
        }
        
        formattedStr = [NSString stringWithFormat:@"%dK",intsize ];
        
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        unsigned long long l = pow(1024, 2);
        int intsize = size / pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
        formattedStr = [NSString stringWithFormat:@"%dM", intsize];
        
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dG", intsize];
    }
    
    return formattedStr;
}

+ (NSString *)to_formattedFileSize:(unsigned long long)size
{
    return [self to_formattedFileSize:size suffixLenth:NULL];
}

+ (NSString *)to_formattedFileSize:(unsigned long long)size suffixLenth:(NSInteger *)length
{
    NSInteger len = 0;
    NSString *formattedStr = nil;
    size = size;
    if (size == 0)
        formattedStr = NSLocalizedString(@"0 KB",@""), len = 2;
    else
        if (size > 0 && size < 1024)
            formattedStr = [NSString stringWithFormat:@"%qubytes", size], *length = 2, len = 7;
        else
            if (size >= 1024 && size < pow(1024, 2))
                formattedStr = [NSString stringWithFormat:@"%.2fKB", (size / 1024.)], len = 2;
            else
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    formattedStr = [NSString stringWithFormat:@"%.2fMB", (size / pow(1024, 2))], len = 2;
                else
                    if (size >= pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.2fGB", (size / pow(1024, 3))], len = 2;
    if (length) {
        *length = len;
    }
    return formattedStr;
}

+ (unsigned long long)to_antiFormatBandWith:(NSString *)sizeStr
{
    unsigned long long fileSize = 0;
    if(![sizeStr isEqualToString:NSLocalizedString(@"0 KB",@"")]){
        if([sizeStr hasSuffix:@"bytes"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"bytes"] objectAtIndex:0] longLongValue];
        else if([sizeStr hasSuffix:@"KB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"KB"] objectAtIndex:0] floatValue] * 1024;
        else if([sizeStr hasSuffix:@"MB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"MB"] objectAtIndex:0] floatValue] * pow(1024, 2);
        else if([sizeStr hasSuffix:@"GB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"GB"] objectAtIndex:0] floatValue] * pow(1024, 3);
    }
    
    return fileSize;
}

@end
