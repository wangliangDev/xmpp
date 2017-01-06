//
//  Singletion.m
//  XMPP
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "Singletion.h"

@implementation Singletion



+(instancetype)shareInstance
{
    
    static dispatch_once_t once;
    
    static id instance = nil;
    
    dispatch_once(&once, ^{
        
        instance = [[[self class]alloc]init];
    });
    
    return instance;
}


-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
    
}

//修改图片尺寸
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}


/**
 把汉字变拼音并截取第一个字母变大写

 @param chinese 目标字符串
 @return 截取后的字符串
 */
-(NSString *)transform:(NSString *)chinese{
    
    if (chinese == nil ||[chinese isEqualToString:@""]) {
        
        return @"#";
        
    }
    
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    NSString *subString = [[pinyin uppercaseString] substringWithRange:NSMakeRange(0, 1)];
    
    if ([self isPureInt:subString] || [self isPureFloat:subString]) {
        
        return  @"#";
    }
    
    return subString;
}

//判断是否为整型：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点型：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


-(void)loadHudView:(UIView*)view
{
    
    hudView = [[MBProgressHUD alloc]initWithView:view];
    hudView.label.text = @"正在加载...";
    [hudView showAnimated:YES];
    [view addSubview:hudView];
}
-(void)removeHudView
{
    
    [hudView hideAnimated:YES];
    [hudView removeFromSuperview];
    hudView = nil;
}

@end
