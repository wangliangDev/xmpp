//
//  TBXmppManager.m
//  XMPP
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBXmppManager.h"
#import "UserInfoManager.h"



@interface TBXmppManager ()<XMPPStreamDelegate,XMPPMessageArchivingStorage,XMPPRosterDelegate,XMPPvCardAvatarStorage,XMPPvCardTempModuleDelegate>{
    
    
    
}

@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *userName;

@property(nonatomic,strong)NSString *regiserPassword;

@end


@implementation TBXmppManager


+(instancetype)defaultManage
{
    
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[[self class]alloc]init];
    });
    
    return instance;
}

-(instancetype)init
{
    self = [super init];
    
    if (self ) {
        
        
        self.stream = [XMPPStream new];
        self.stream.hostName = kHostName;
        self.stream.hostPort = kHostPort;
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        self.xmppAutoPing = [XMPPAutoPing new];  //1.autoPing 发送的时一个stream:ping 对方如果想表示自己是活跃的，应该返回一个pong
        [self.xmppAutoPing activate:self.stream];
        [self.xmppAutoPing setPingInterval:1000];
        [self.xmppAutoPing setRespondsToQueries:YES];
        
        
        self.rosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.roster = [[XMPPRoster alloc]initWithRosterStorage:self.rosterCoreDataStorage dispatchQueue:dispatch_get_global_queue(0, 0)];
        [self.roster activate:self.stream];
        [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.roster setAutoFetchRoster:YES]; // //设置好友同步策略,XMPP一旦连接成功，同步好友到本地
        [self.roster setAutoAcceptKnownPresenceSubscriptionRequests:NO]; //关掉自动接收好友请求，默认开启自动同意
        
        
        self.reconnect = [XMPPReconnect new];
        [self.reconnect activate:self.stream];
        [self.reconnect setAutoReconnect:YES];    //2.autoReconnect 自动重连，当我们被断开了，自动重新连接上去，并且将上一次的信息自动加上去
        
        
        self.vCardCoreDataStorage = [XMPPvCardCoreDataStorage sharedInstance];
        self.vCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:self.vCardCoreDataStorage];
        [self.vCardTempModule activate:self.stream];
        [self.vCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        self.vCardAvatarModule = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.vCardTempModule];
        [self.vCardAvatarModule activate:self.stream];
        [self.vCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        
        self.messageArchivingCoreDataStoreage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.messageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:self.messageArchivingCoreDataStoreage dispatchQueue:dispatch_get_main_queue()];
        [self.messageArchiving activate:self.stream];
        [self.messageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.messageContext = self.messageArchivingCoreDataStoreage.mainThreadManagedObjectContext;
        
        [self.stream setEnableBackgroundingOnSocket:YES];
        
    }
    
    return self;
}


-(void)connectToServerWithUser:(NSString*)name
{
    
    if ([self.stream isConnected]) {
        
        [self.stream disconnect];
    }
    
    self.stream.myJID = [XMPPJID jidWithUser:name domain:kDomin resource:kResource];
    
     NSLog(@"self.stream.myJID*****%@",self.stream.myJID);
    
    NSError *error = nil;
    
    [self.stream connectWithTimeout:60 error:&error];
    
    if (error) {
        
         NSLog(@"连接失败!");
    }
}
-(void)disconnectWithServer
{
    [self.stream disconnect];
}

-(void)loginWithUserName:(NSString *)name AndPassWord:(NSString *)password
{
    self.password = password;
    self.userName = name;
    self.ConnetType = Dologin;
    
    [self connectToServerWithUser:name];
    
}

-(void)regiserWithUserName:(NSString *)name AndPassWord:(NSString *)password
{
    self.regiserPassword = password;
    self.ConnetType = DoRegister;
    [self connectToServerWithUser:name];
    
}


#pragma mark --XMPPStreamDelegate

-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    
     NSLog(@"与服务器已经连接");
    NSError *error = nil;
    
    
    if (self.ConnetType == Dologin) {
        
        [self.stream authenticateWithPassword:self.password error:&error];
        
        if (error) {
            
             NSLog(@"认证过程出错!");
        }
    }else if (self.ConnetType == DoRegister){
        
        [self.stream registerWithPassword:self.regiserPassword error:&error];
        
        if (error) {
            
            NSLog(@"认证过程出错!");
        }
    }
}



-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addChild:[DDXMLNode elementWithName:@"status" stringValue:@"我现在很忙"]];
    [presence addChild:[DDXMLNode elementWithName:@"show" stringValue:@"xa"]];
    
    [self.stream sendElement:presence];
    
    NSLog(@"认证成功")
  
    UserInfoManager * userInfoManager = [UserInfoManager shardManager];
    
    userInfoManager.jid = [XMPPJID jidWithUser:self.userName domain:kDomin resource:kResource];
    userInfoManager.password = self.password;
    [self.roster fetchRoster];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kloginSuccessful object:nil];
    
  
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    
    [[TKAlertCenter defaultCenter]postAlertWithMessage:@"登录失败,请检查账号密码"];
}


-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    
    NSLog(@"%@",sender);
    
     @throw [NSException exceptionWithName:@"CQ_Error" reason:@"与服务器建立连接超时" userInfo:nil];
}


/**
 * 开始同步服务器发送过来的自己的好友列表
 **/
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    
}

/**
 * 同步结束
 **/
//收到好友列表IQ会进入的方法，并且已经存入我的存储器
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KXMPPRosterChange object:nil];
}

//收到每一个好友
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    
}

// 如果不是初始化同步来的roster,那么会自动存入我的好友存储器
- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KXMPPRosterChange object:nil];
}


@end


























