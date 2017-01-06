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
        
    }
    
    return self;
}
-(void)createImageView
{
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
