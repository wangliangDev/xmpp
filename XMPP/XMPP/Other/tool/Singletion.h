//
//  Singletion.h
//  XMPP
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singletion : NSObject{
    
     MBProgressHUD *hudView;
    
   
}

+(instancetype)shareInstance;
-(void)loadHudView:(UIView*)view;
-(void)removeHudView;
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
-(NSString *)transform:(NSString *)chinese;
-(CGFloat)textHight:(NSString *)string font:(UIFont*)font;

@end
