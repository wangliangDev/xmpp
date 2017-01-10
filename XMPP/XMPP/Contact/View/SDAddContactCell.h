//
//  SDAddContactCell.h
//  SDChatDemo
//
//  Created by songjc on 16/12/6.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPJID;
@protocol SDAddContactCellDelegate <NSObject>

@optional

-(void)agreeWithFriendRequest:(NSString *)jidUser;

-(void)disagressWithFriendRequest:(NSString *)jidUser;

@end


@interface SDAddContactCell : UITableViewCell

//SDAddContactCell是用来显示每一条添加好友记录的.

@property(nonatomic,strong)UILabel *agreeButton;

@property(nonatomic,strong)UILabel *disagreeButton;

@property(nonatomic,strong)UILabel *friendidLabel;

@property(nonatomic,strong)UIImageView *headerImageView;

@property(nonatomic,assign)id<SDAddContactCellDelegate>delegate;

@end
