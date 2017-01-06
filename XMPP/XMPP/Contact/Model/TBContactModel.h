//
//  TBContactModel.h
//  XMPP
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import <JSONModel/JSONModel.h>
//本MODEL是一个关于联系人的Model,包含着联系人的JID以及联系人的电子名片

@interface TBContactModel : JSONModel{
    
    
}
@property(nonatomic,strong)XMPPJID *jid;

@property(nonatomic,strong)XMPPvCardTemp *vCard;

@property(nonatomic,assign)BOOL isAvailable;//是否在在线
@end
