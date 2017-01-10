//
//  TBNewFriendCell.m
//  XMPP
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBNewFriendCell.h"

@interface TBNewFriendCell (){
    
    
}
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *friendNumberLabel;

@end



@implementation TBNewFriendCell




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self createImageView];
        [self createLabel];
        [self createFriendNumberLabel];
        
    }
    
    return self;
}
-(void)createImageView
{
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.frame = CGRectMake(15, 15, 30, 30);
    self.iconImageView.image = [UIImage imageNamed:@"新的朋友"];
    
    [self.contentView addSubview:self.iconImageView];
   
}

-(void)createLabel{
    
    
    self.label = [UILabel new];
    self.label.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+20, 15, 100, 30);
    self.label.font = kFont(15);
    self.label.text = @"新的朋友";
    [self.contentView addSubview:self.label];
}


-(void)createFriendNumberLabel{
    
    
    self.friendNumberLabel = [UILabel new];
    self.friendNumberLabel.frame = CGRectMake(KSCREEN_WIDTH -50, 15, 20, 20);
    self.friendNumberLabel.font = kFont(15);
    self.friendNumberLabel.backgroundColor = kRedColor;
    self.friendNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.friendNumberLabel];
    
    if ([UserInfoManager shardManager].addFriendArray.count > 0 ) {
        
        [self.friendNumberLabel setHidden:NO];
        self.friendNumberLabel.layer.cornerRadius = 10;
        self.friendNumberLabel.layer.masksToBounds = YES;
        self.friendNumberLabel.text = [NSString stringWithFormat:@"%ld",[UserInfoManager shardManager].addFriendArray.count];
        
    }else{
        
        [self.friendNumberLabel setHidden:YES];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
