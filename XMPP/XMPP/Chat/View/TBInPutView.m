//
//  TBInPutView.m
//  XMPP
//
//  Created by apple on 2017/1/10.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBInPutView.h"




@implementation TBInPutView



-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
         viewWidth = frame.size.width;
        
         viewHeight = frame.size.height;
        
         self.backgroundColor = RGB(240, 240, 240);
        
        [self addSubview:self.moreButton];
        [self addSubview:self.faceButton];
        [self addSubview:self.sendSoundButton];
        [self addSubview:self.soundButton];
        [self addSubview:self.inputTextView];
        [self addSubview:self.keyBoardAnimationView];
        
        emojiView = [[ChatEmojiView alloc]init];
        emojiView.delegate = self;
        
        [self addNotifations];
    }
    
    
    return self;
}

#pragma mark 添加通知
- (void)addNotifations{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - 系统键盘通知事件


-(void)duration:(CGFloat)duration EndF:(CGRect)endF{
    
    [UIView animateWithDuration:duration animations:^{
        
        self.frame = endF;
    }];
    
    CGFloat y = endF.origin.y;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:ChangeHeight:)]) {
        
        [self.delegate keyBoardView:self ChangeHeight:y];
        
    }
}
-(void)keyBoardHiden:(NSNotification*)noti{
    //隐藏键盘
    
    CGRect endF = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat duration = [[noti.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect fram = self.frame;
    fram.origin.y = (endF.origin.y - 50);
    [self duration:duration EndF:fram];
    
}





-(void)keyBoardShow:(NSNotification*)noti{
    //显示键盘
    CGRect endF = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    NSTimeInterval duration = [[noti.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect fram = self.frame;
    
    NSLog(@"%f",endF.origin.y);
    
    fram.origin.y = (endF.origin.y -50);
    
    [self.moreButton setSelected:NO];
    
   
    
    [self duration:duration EndF:fram];
    
}



#pragma mark --eventRespond CGFloat viewHeight
-(void)cutSoundAndWord{
    
    self.soundButton.selected = !self.soundButton.selected;
    
    if (self.soundButton.isSelected) {
        
        [self insertSubview:self.inputTextView belowSubview:self.sendSoundButton];
        
        [self.inputTextView resignFirstResponder];
        
        
    }else{
        
        [self insertSubview:self.sendSoundButton belowSubview:self.inputTextView];
        
        
    }
    
}

-(void)tapAction
{
    [self.inputTextView resignFirstResponder];
    
    [self.moreButton setSelected:NO];
   
    [self.moreButton setImage:[UIImage imageNamed:@"ic_add_blue"] forState:UIControlStateNormal];
    [self moreButtonAction:nil];
    
}

-(void)moreButtonAction:(UIButton*)sender
{
    
    if (self.moreButton.isSelected) {
        
         [self.inputTextView becomeFirstResponder];
        
         return;
        
    }else{
        
        
         [self.inputTextView resignFirstResponder];
       
    }
    if ([sender isEqual:self.moreButton]) {
        
         self.moreButton.selected = !self.moreButton.selected;
        
    }
    
     [self.keyBoardAnimationView addSubview:emojiView];
     CGRect fram = self.frame;
    
    if (!sender) {
        
         fram.origin.y =KSCREEN_HEIGHT-  50;
        
    }else{
        
         fram.origin.y =KSCREEN_HEIGHT- (210 + 50);
    }
    
    
    [self duration:0.25 EndF:fram];
}


#pragma mark --getter

-(UIButton*)soundButton
{
    if (!_soundButton) {
        
        _soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _soundButton.frame = CGRectMake(viewWidth*0.015, (viewHeight-viewWidth*0.12)/2, viewWidth*0.12, viewWidth*0.12);
        [_soundButton setImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal];
        [_soundButton setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateSelected];
        [_soundButton addTarget:self action:@selector(cutSoundAndWord) forControlEvents:UIControlEventTouchUpInside];
        [_soundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return _soundButton;
}

-(UIButton*)sendSoundButton
{
    
    if (!_sendSoundButton) {
        
        
        _sendSoundButton =[UIButton buttonWithType:UIButtonTypeCustom];;
        _sendSoundButton.frame =CGRectMake(viewWidth*0.15, 8, viewWidth*0.62, viewHeight-16);
        [_sendSoundButton setTitle:@"发送语音" forState:UIControlStateNormal];
        [_sendSoundButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _sendSoundButton.layer.masksToBounds = YES;
        _sendSoundButton.layer.cornerRadius = 5;
        _sendSoundButton.layer.borderWidth = 2.0f;
        _sendSoundButton.layer.borderColor = (__bridge CGColorRef _Nullable)(RGB(80, 80, 80));
        _sendSoundButton.backgroundColor = RGB(255, 255, 255);
    }
    
    return _sendSoundButton;
}

-(UIButton*)moreButton
{
    
    if (!_moreButton) {
        
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
         _moreButton.frame = CGRectMake(viewWidth*0.88, viewHeight*0.2, viewWidth *0.12, viewHeight*0.6);
        [_moreButton setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
        [_moreButton setImage:[UIImage imageNamed:@"ic_add_blue"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      
    }
    
    return _moreButton;
}

-(UIButton*)faceButton
{
    
    if (!_faceButton) {
        
        
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.frame = CGRectMake(viewWidth*0.78, viewHeight*0.2, viewWidth *0.12, viewHeight*0.6);
        [_faceButton setImage:[UIImage imageNamed:@"ic_emoji_blue"] forState:UIControlStateNormal];
        
    }
    
    return _faceButton;
}

-(TBChatKeyBoardAnimationView*)keyBoardAnimationView
{
    if (!_keyBoardAnimationView) {
        
        _keyBoardAnimationView = [TBChatKeyBoardAnimationView new];
        _keyBoardAnimationView.frame = CGRectMake(0, 55, KSCREEN_WIDTH, 210);
    }
    
    return _keyBoardAnimationView;
    
}


-(ChatInputTextView*)inputTextView
{
    if (!_inputTextView) {
        
        _inputTextView = [[ChatInputTextView alloc]initWithFrame:CGRectMake(viewWidth*0.15, 8, viewWidth*0.62, viewHeight-16)];
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.font = [UIFont systemFontOfSize:15];
        _inputTextView.layer.cornerRadius = 5;
        _inputTextView.layer.borderWidth = 0.5f;
        _inputTextView.layer.borderColor = (__bridge CGColorRef _Nullable)(RGB(180, 180, 180));
        _inputTextView.backgroundColor = RGB(255, 255, 255);
        _inputTextView.returnKeyType = UIReturnKeySend;
         [_inputTextView setTextContainerInset:UIEdgeInsetsMake(10, 0, 5, 0)];

    }
    
    return _inputTextView;
}


@end











