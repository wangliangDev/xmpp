//
//  TBChatContentModel.h
//  XMPP
//
//  Created by apple on 2017/1/10.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TBChatContentModel : JSONModel{
    
    
}

@property(nonatomic,strong)NSString *message;

@property(nonatomic,strong)NSString *messageTime;

@property(nonatomic,strong)UIImage *headerImage;

@property(nonatomic,assign)BOOL isSend;

@property(nonatomic,strong)XMPPMessageArchiving_Message_CoreDataObject *Message_CoreDataObject;//消息的所有内容

@end
