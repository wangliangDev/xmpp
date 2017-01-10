//
//  TBContactCell.m
//  XMPP
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBContactCell.h"
#import "TBContactModel.h"


@interface TBContactCell (){
    
    
    
}

/**
 头像的ImageView
 */
@property (strong, nonatomic)  UIImageView *iconsImageView;


/**
 联系人名称Label
 */
@property (strong, nonatomic)  UILabel *contactNameLabel;


/**
 上下线状态Lable
 */
@property (strong, nonatomic)  UILabel *stateLabel;


/**
 上下线状态图标
 */
@property (strong, nonatomic)  UIImageView *stateImage;


@end

@implementation TBContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        [self createIconImageView];
        [self createNameLabel];
        [self createStatusUI];
    }
    
    return self;
}
-(void)createIconImageView
{
    
    self.iconsImageView = [UIImageView new];
    self.iconsImageView.frame = CGRectMake(15, 15, 30, 30);
    [self.contentView addSubview:self.iconsImageView];

    
}

-(void)createNameLabel
{
    self.contactNameLabel = [UILabel new];
    self.contactNameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconsImageView.frame)+20, 15, 100, 15);
    self.contactNameLabel.font = kFont(15);
    [self.contentView addSubview:self.contactNameLabel];
}

-(void)createStatusUI
{
    self.stateImage = [UIImageView new];
    self.stateImage.frame = CGRectMake(CGRectGetMaxX(self.iconsImageView.frame)+20,CGRectGetMaxY(self.contactNameLabel.frame)+5, 15, 15);
    [self.contentView addSubview:self.stateImage];
    
    self.stateLabel = [UILabel new];
    self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.stateImage.frame)+20, CGRectGetMaxY(self.contactNameLabel.frame)+5, 100, 15);
    self.stateLabel.font = kFont(15);
    [self.contentView addSubview:self.stateLabel];
}

-(void)setContactModel:(TBContactModel *)contactModel
{
    _contactModel = contactModel;
    
    if (contactModel.vCard.photo == nil) {
        
        self.iconsImageView.image = [UIImage imageNamed:@"头像"];
    }else{
        
        self.iconsImageView.image = [UIImage imageWithData:contactModel.vCard.photo];
    }
    
    
    self.contactNameLabel.text = contactModel.vCard.nickname;
    
    if (contactModel.isAvailable) {
        
        self.stateImage.image = [UIImage imageNamed:@"在线"];
        self.stateLabel.text = @"在线";
        
    }else{
        
        self.stateImage.image = [UIImage imageNamed:@"离线"];
        self.stateLabel.text = @"离线";

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


















