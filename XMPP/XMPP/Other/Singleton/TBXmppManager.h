//
//  TBXmppManager.h
//  XMPP
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPvCardTemp.h"


typedef NS_ENUM(NSInteger,ConnetType) {
    
    Dologin,
    DoRegister
};

@interface TBXmppManager : NSObject{
    
    
    
}
@property(nonatomic,assign)ConnetType  ConnetType;

+(instancetype)defaultManage;

/**
 C与S之间的通信管道
 */

@property(nonatomic,strong)XMPPStream *stream;


/**
 通讯对象,用来管理好友列表的类
 */
@property(nonatomic,strong)XMPPRoster *roster;
@property(nonatomic,strong)XMPPRosterCoreDataStorage *rosterCoreDataStorage;

/**
 电子名片相关
 */
@property(nonatomic,strong)XMPPvCardTempModule *vCardTempModule;
@property(nonatomic,strong)XMPPvCardCoreDataStorage *vCardCoreDataStorage;
@property(nonatomic,strong)XMPPvCardAvatarModule *vCardAvatarModule;

/**
 自动连接
 */
@property(nonatomic,strong)XMPPReconnect *reconnect;


/**
 XMPP聊天消息本地化处理对象
 */
@property(nonatomic,strong)XMPPMessageArchivingCoreDataStorage *messageArchivingCoreDataStoreage;
@property(nonatomic,strong)XMPPMessageArchiving *messageArchiving;
@property(nonatomic,strong)NSManagedObjectContext *messageContext;


/**
 登录服务器
 
 @param name 登录账号
 @param password 密码
 */
-(void)loginWithUserName:(NSString *)name AndPassWord:(NSString *)password;


/**
 注册新用户
 
 @param name 登录账号
 @param password 密码
 */
-(void)regiserWithUserName:(NSString *)name AndPassWord:(NSString *)password;


/**
 断开与服务器的连接
 */
-(void)disconnectWithServer;

@end






