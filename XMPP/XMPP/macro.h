//
//  macro.h
//  daZhongDianPing
//
//  Created by ttbb on 16/9/26.
//  Copyright © 2016年 ttbb. All rights reserved.
//

#ifndef macro_h
#define macro_h


#define DefineWeakSelf __weak __typeof(self) weakSelf = self
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define loginFlag @"loginFlag"
// 获得RGB颜色
#define RGBA(r, g, b, a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)       RGBA(r, g, b, 1.0f)

// 屏幕大小尺寸
#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kWhiteColor [UIColor whiteColor]
#define kBlackColor [UIColor blackColor]
#define kDarkGrayColor [UIColor darkGrayColor]
#define kLightGrayColor [UIColor lightGrayColor]
#define kGrayColor [UIColor grayColor]
#define kRedColor [UIColor redColor]
#define kGreenColor [UIColor greenColor]
#define kBlueColor [UIColor blueColor]
#define kCyanColor [UIColor cyanColor]
#define kYellowColor [UIColor yellowColor]
#define kMagentaColor [UIColor magentaColor]
#define kOrangeColor [UIColor orangeColor]
#define kPurpleColor [UIColor purpleColor]
#define kBrownColor [UIColor brownColor]
#define kClearColor [UIColor clearColor]
#define kCommonGrayTextColor [UIColor colorWithRed:0.63f green:0.63f blue:0.63f alpha:1.00f]
#define kCommonRedColor [UIColor colorWithRed:0.91f green:0.33f blue:0.33f alpha:1.00f]
#define kBgColor kRGBColor(243,245,247)
#define kLineBgColor [UIColor colorWithRed:0.86f green:0.88f blue:0.89f alpha:1.00f]
#define kTextColor [UIColor colorWithRed:0.32f green:0.36f blue:0.40f alpha:1.00f]
#define kCommonBlackColor [UIColor colorWithRed:0.17f green:0.23f blue:0.28f alpha:1.00f]
#define kSeperatorColor kRGBColor(234,237,240)
#define kDetailTextColor [UIColor colorWithRed:0.56f green:0.60f blue:0.62f alpha:1.00f]

#define iOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/***  粗体 */
#define kBoldFont(size) [UIFont boldSystemFontOfSize:size]
/***  普通字体 */
#define kFont(size) [UIFont systemFontOfSize:size]
#define kLineHeight (1 / [UIScreen mainScreen].scale)

#pragma mark - 字符串转化
#define kEmptyStr @""
#define kIntToStr(i) [NSString stringWithFormat: @"%d", i]
#define kIntegerToStr(i) [NSString stringWithFormat: @"%ld", i]
#define kValidStr(str) [NHUtils validString:str]

//好友上下线状态的更改通知
#define ContactIsAvailable @"ContactIsAvailable"




//收到新的好友请求的消息
#define AddNewContectMessage @"AddNewContectMessage"
//收到被拒绝好友信息
#define DisagreeAddNewContect @"DisagreeAddNewContect"
//收到同意接受好友请求
#define AgreeAddNewContect  @"AgreeAddNewContect"

#endif /* macro_h */
