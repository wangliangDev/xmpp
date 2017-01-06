//
//  TBXmppManager.m
//  XMPP
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBXmppManager.h"


@interface TBXmppManager ()<XMPPStreamDelegate,XMPPMessageArchivingStorage,XMPPRosterDelegate,XMPPvCardAvatarStorage,XMPPvCardTempModuleDelegate>{
    
    
    
}

@property(nonatomic,strong)NSString *password;

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
        
        
        self.stream = [[XMPPStream alloc]init];
        self.stream.hostName = kHostName;
        self.stream.hostPort = kHostPort;
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        self.rosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.roster = [[XMPPRoster alloc]initWithRosterStorage:self.rosterCoreDataStorage dispatchQueue:dispatch_get_global_queue(0, 0)];
        [self.roster activate:self.stream];
        [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.roster setAutoFetchRoster:NO];
        
        
        self.reconnect = [XMPPReconnect new];
        [self.reconnect activate:self.stream];
        
        
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
    
    [self.stream connectWithTimeout:30.0f error:&error];
    
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


-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    
    NSLog(@"%@",sender);
    
     @throw [NSException exceptionWithName:@"CQ_Error" reason:@"与服务器建立连接超时" userInfo:nil];
}



@end


























