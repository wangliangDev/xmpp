//
//  TBInPutView.h
//  XMPP
//
//  Created by apple on 2017/1/10.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBInPutView : UIView{
    
     CGFloat viewWidth;
    CGFloat viewHeight;
}
/**
 输入框
 */
@property(nonatomic,strong)UITextView *inputTextView;


/**
 发送按钮
 */
@property(nonatomic,strong)UIButton *sendButton;


/**
 语音按钮
 */
@property(nonatomic,strong)UIButton *soundButton;


/**
 发送语音按钮
 */
@property(nonatomic,strong)UIButton *sendSoundButton;

@end
