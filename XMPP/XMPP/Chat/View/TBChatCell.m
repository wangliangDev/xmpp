//
//  TBChatCell.m
//  XMPP
//
//  Created by apple on 2017/1/10.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBChatCell.h"
#import "TBChatContentModel.h"

@implementation TBChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
       self.selectionStyle  = UITableViewCellSeparatorStyleNone;
        
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.layer.cornerRadius = 20.0f;
        self.headImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.headImageView];
        
        self.backView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.backView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.backView addSubview:self.contentLabel];
        
        self.contentView.backgroundColor = RGB(230, 230, 230);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delegateAction)];
        [self.backView addGestureRecognizer:tap];
        self.backView.userInteractionEnabled = YES;
    }
    
    return self;
}


-(void)setContentModel:(TBChatContentModel *)contentModel
{
    _contentModel = contentModel;
    
    CGRect rect = [contentModel.message boundingRectWithSize:CGSizeMake(KSCREEN_WIDTH / 14 * 9, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.contentLabel.font} context:nil];
    
    UIImage *image = nil;
    // 头像
    UIImage *headImage = nil;
    if (contentModel.isSend) {//本人
        
        self.headImageView.frame = CGRectMake(KSCREEN_WIDTH - 50, 20, 40, 40);
        self.backView.frame = CGRectMake(KSCREEN_WIDTH - 50 - rect.size.width - 20, 15, rect.size.width + 20, rect.size.height+25);
        image = [UIImage imageNamed:@"发送气泡"];
        headImage = contentModel.headerImage;
        

    }else{
        self.headImageView.frame = CGRectMake(10, 20, 40, 40);
        self.backView.frame = CGRectMake(60, 15, rect.size.width + 20, rect.size.height + 20);
         image = [UIImage imageNamed:@"收到气泡"];
         headImage = contentModel.headerImage;
    }
    image = [image stretchableImageWithLeftCapWidth:image.size.width/10*9 topCapHeight:image.size.height/10*9];
    self.backView.image = image;
    self.headImageView.image = headImage;
    self.contentLabel.frame = CGRectMake(contentModel.isSend ? 5 : 13, 5, rect.size.width, rect.size.height);
    
    if ([contentModel.message isEqualToString:@"voice"]) {
        
        self.contentLabel.text = @"🎵";
    }else{
        
        self.contentLabel.text = contentModel.message;
        
    }

}

-(void)delegateAction{
    
    if ([self.delegate respondsToSelector:@selector(tapChatContent:)]) {
        
        
        [self.delegate tapChatContent:self.contentModel];
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
