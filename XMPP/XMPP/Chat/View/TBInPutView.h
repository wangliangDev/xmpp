//
//  TBInPutView.h
//  XMPP
//
//  Created by apple on 2017/1/10.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBChatKeyBoardAnimationView.h"
#import "ChatInputTextView.h"
#import "ChatEmojiView.h"
#import "ChatOtherView.h"


@class TBInPutView;

@protocol TBInputViewDelegate <NSObject>

-(void)keyBoardView:(TBInPutView *)keyBoard ChangeHeight:(CGFloat)height;

@end

@interface TBInPutView : UIView<ChatEmojiViewDelegate,ChatOtherViewDelegate>{
    
    CGFloat viewWidth;
    CGFloat viewHeight;
    
    ChatEmojiView *emojiView;
    ChatOtherView *otherView;
    
    BOOL isHide;
}

/**
 输入框
 */
@property(nonatomic,strong)ChatInputTextView *inputTextView;
@property (nonatomic,strong) UIView *chatBgView;//聊天框

@property(nonatomic,strong)TBChatKeyBoardAnimationView *keyBoardAnimationView;
@property(nonatomic,assign)id<TBInputViewDelegate>delegate;

/**
 更多+号
 */
@property(nonatomic,strong)UIButton *moreButton;


/**
 表情
 */
@property(nonatomic,strong)UIButton *faceButton;

/**
 语音按钮
 */
@property(nonatomic,strong)UIButton *soundButton;


/**
 发送语音按钮
 */
@property(nonatomic,strong)UIButton *sendSoundButton;

-(void)tapAction;

@end













