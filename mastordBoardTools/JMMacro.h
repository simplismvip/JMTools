//
//  JMMacro.h
//  MasterBoard
//
//  Created by 赵俊明 on 2019/1/17.
//  Copyright © 2019 赵俊明. All rights reserved.
//

#ifndef JMMacro_h
#define JMMacro_h

#define Google_Bander @"ca-app-pub-5649482177498836/5532551956"
#define banner_one @"ca-app-pub-5649482177498836/3376198842"
#define banner_two @"ca-app-pub-5649482177498836/5806921066"
#define banner_thr @"ca-app-pub-5649482177498836/8281875316"

#define kRAND(from,to) (int)((from) + (arc4random() % ((to)-(from) + 1)))
#define denyNil(value) (value)?(value):@"null objects"
#define kRand (CGFloat)(arc4random() % 6)
#define kImage(name) [UIImage imageNamed:(name)]
#define kUrl(url) [NSURL URLWithString:(url)]

#define JMSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define JMTabViewBaseColor JMColor(245.0, 245.0, 245.0)
#define JMBaseColor JMColor(41, 41, 41)

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define JMColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define JMRandomColor JMColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 颜色
#define JMCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define JMDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]

#define kFiles [JMDocumentsPath stringByAppendingPathComponent:@"files"]
#define kFolders [JMDocumentsPath stringByAppendingPathComponent:@"folders"]
#define kThumb [JMDocumentsPath stringByAppendingPathComponent:@"thumb"]
#define upload_path @"/var/www/html/source/upload/"
#define upload_temp @"/var/www/html/source/temps/"

//Frame
#define kW [[UIScreen mainScreen] bounds].size.width
#define kH [[UIScreen mainScreen] bounds].size.height

// 字体
#define SentyZHAO @"SentyZHAO Âµ"
#define FZLBJW @"FZLBJW--GB1-0"
#define Font_ruifs @"font_ruifs"
#define Font_ruinb @"font_ruinb"
#define Font_ruikt @"font_ruikt"

#define Font_Size 20
#define DefaultFontSize 15

#define Sqlpath [SqliteFolder stringByAppendingPathComponent:@"PoemData.sqlite"]
// [[NSBundle mainBundle] pathForResource:@"PoemData" ofType:@"sqlite"]

#define JMDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
#define AudioFolder [JMDocumentsPath stringByAppendingPathComponent:@"Audio"]
#define FontFolder [JMDocumentsPath stringByAppendingPathComponent:@"Fonts"]
#define SqliteFolder [JMDocumentsPath stringByAppendingPathComponent:@"SQLite"]
#define isFontExist(bookName) [[NSFileManager defaultManager] fileExistsAtPath:[FontFolder stringByAppendingPathComponent:(bookName)]]
#define absUrl(urlString) [(urlString) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

// 颜色
#define JMCellBackground JMColor(239, 239, 239)
#define JMCellContent JMColor(254, 254, 254)
#define JMCellText JMColor(241, 241, 241)
#define JMTabViewBaseColor JMColor(205.0, 205.0, 205.0)
#define JMBaseColor JMColor(41, 41, 41)

#endif /* JMMacro_h */
