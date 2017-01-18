//
//  TBChatKeyBoardAnimationView.m
//  XMPP
//
//  Created by apple on 2017/1/17.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBChatKeyBoardAnimationView.h"

#define  DURTAION  0.25f

@implementation TBChatKeyBoardAnimationView



-(void)addSubview:(UIView *)view
{
    CGRect newFrame = self.frame;
    newFrame.size.height = CGRectGetHeight(view.frame);
    self.frame = newFrame;
    
    for (UIView * v in self.subviews) {
        [v removeFromSuperview];
    }
    
    [super addSubview:view];
    
    CGRect frame = view.frame;
    frame.origin.y = CGRectGetHeight(self.frame);
    view.frame = frame;
    
    frame.origin.y = 0;
    
    [UIView animateWithDuration:DURTAION animations:^{
        
        view.frame = frame;
    }];
}


@end
