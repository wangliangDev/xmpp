//
//  TBContactCell.m
//  XMPP
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBContactCell.h"
#import "TBContactModel.h"

@implementation TBContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        
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
