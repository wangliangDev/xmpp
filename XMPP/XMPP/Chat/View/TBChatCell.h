//
//  TBChatCell.h
//  XMPP
//
//  Created by apple on 2017/1/10.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBChatContentModel;

@protocol TBChatDelegate <NSObject>

-(void)tapChatContent:(TBChatContentModel*)ContentModel;

@end

@interface TBChatCell : UITableViewCell{
    
    
    
}
@property (nonatomic,strong) UIImageView *headImageView; // 用户头像
@property (nonatomic,strong) UIImageView *backView; // 气泡
@property (nonatomic,strong) UILabel *contentLabel; // 气泡内文本
@property(nonatomic,assign)id <TBChatDelegate>delegate;

@property(nonatomic,strong)TBChatContentModel *contentModel;

@end
