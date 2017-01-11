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
        
        [self addSubview:self.sendButton];
        [self addSubview:self.sendSoundButton];
        [self addSubview:self.soundButton];
        [self addSubview:self.inputTextView];
    }
    
    
    return self;
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
        _sendSoundButton.frame =CGRectMake(viewWidth*0.15, 8, viewWidth*0.67, viewHeight-16);
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

-(UIButton*)sendButton
{
    
    if (!_sendButton) {
        
        
       _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(viewWidth*0.85, viewHeight*0.2, viewWidth *0.12, viewHeight*0.6);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.backgroundColor = RGB(126, 126, 126);
        _sendButton.layer.cornerRadius = 3;
        _sendButton.layer.masksToBounds = YES;
       
        _sendButton.userInteractionEnabled  = NO;
    }
    
    return _sendButton;
}

-(UITextView*)inputTextView
{
    if (!_inputTextView) {
        
        _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(viewWidth*0.15, 8, viewWidth*0.67, viewHeight-16)];
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.font = [UIFont systemFontOfSize:15];
        _inputTextView.layer.cornerRadius = 5;
        _inputTextView.layer.borderWidth = 0.5f;
        _inputTextView.layer.borderColor = (__bridge CGColorRef _Nullable)(RGB(180, 180, 180));
        _inputTextView.backgroundColor = RGB(255, 255, 255);

    }
    
    return _inputTextView;
}


@end











