//
//  SDAddContactCell.m
//  SDChatDemo
//
//  Created by songjc on 16/12/6.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import "SDAddContactCell.h"
#import "XMPPJID.h"
#import "XMPPConfig.h"
@implementation SDAddContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headerImageView.image = [UIImage imageNamed:@"头像"];
        [self.contentView addSubview:self.headerImageView];
        
        //30px是头像的空间宽度,120px是同意按钮和拒绝按钮的空间宽度
        self.friendidLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, KSCREEN_WIDTH-60-120, 30)];
        [self.contentView addSubview:self.friendidLabel];
        
        self.agreeButton = [[UILabel alloc]init];
        self.agreeButton.text = @"同意";
        self.agreeButton.textAlignment = NSTextAlignmentCenter;
        self.agreeButton.textColor = [UIColor greenColor];
        self.agreeButton.frame = CGRectMake(KSCREEN_WIDTH -120, 10, 40, 20);
//        self.agreeButton.backgroundColor = [UIColor whiteColor];
        [self.agreeButton setTintColor:[UIColor greenColor]];
        self.agreeButton.layer.borderWidth = 2.0f;
        self.agreeButton.layer.cornerRadius =3;
        self.agreeButton.layer.masksToBounds = YES;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef greenColorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 1, 0, 1 });
        self.agreeButton.layer.borderColor = greenColorref;
        UITapGestureRecognizer *agreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeAction)];
        self.agreeButton.userInteractionEnabled = YES;
        [self.agreeButton addGestureRecognizer:agreeTap];
        [self.contentView addSubview:self.agreeButton];
        
        
        self.disagreeButton = [[UILabel alloc]init];
        self.disagreeButton.text = @"拒绝";
        self.disagreeButton.textAlignment = NSTextAlignmentCenter;
        self.disagreeButton.textColor = [UIColor redColor];
//        self.disagreeButton.backgroundColor = [UIColor whiteColor];
        self.disagreeButton.frame = CGRectMake(KSCREEN_WIDTH -60, 10, 40, 20);
        [self.disagreeButton setTintColor:[UIColor redColor]];
        self.disagreeButton.layer.borderWidth = 2.0f;
        CGColorRef redColorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
        self.disagreeButton.layer.borderColor =redColorref;
        UITapGestureRecognizer *disagreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disagreeAction)];
        self.disagreeButton.userInteractionEnabled = YES;
        [self.disagreeButton addGestureRecognizer:disagreeTap];
        
        [self.contentView addSubview:self.disagreeButton];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(60, 30,  KSCREEN_WIDTH-60-120, 30)];
        lable.text = @"请求添加好友";
        lable.textColor = [UIColor lightGrayColor];
        lable.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:lable];
        
    }
    
    return self;

}

-(void)disagreeAction{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(disagressWithFriendRequest:)]) {
        
        [self.delegate disagressWithFriendRequest:self.friendidLabel.text];
        
    }
    
}

-(void)agreeAction{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(agreeWithFriendRequest:)]) {

        [self.delegate agreeWithFriendRequest:self.friendidLabel.text];
        
    }

}

@end
