//
//  AppDelegate.m
//  XMPP
//
//  Created by apple on 2017/1/3.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "AppDelegate.h"
#import "TBSingInViewController.h"
#import "TBContactModel.h"

@interface AppDelegate ()<XMPPStreamDelegate,XMPPRosterDelegate,XMPPReconnectDelegate>{
    
    TBSingInViewController *singInVC;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
   

    singInVC = [[TBSingInViewController alloc]initWithMainVC:[[UIViewController alloc]init] viewControllerType:RollImageLaunchViewController];
    singInVC.rollImageName = @"滚动背景.png";
    singInVC.hideEndButton = YES;
    
    self.window.rootViewController = singInVC;
    
    
    TBXmppManager *manager = [TBXmppManager defaultManage];
    [manager.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [manager.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [manager.reconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    
    return YES;
}


#pragma mark -- XMPPRosterDelegate监听好友请求,收到好友请求时调用该代理方法
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    
    BOOL isExist = NO;
    UserInfoManager *user = [UserInfoManager shardManager];
    //判断是否重复请求
    for (XMPPJID *objJID in user.addFriendArray) {
        
        if ([presence.from.user isEqualToString:objJID.user] &&[presence.from.domain isEqualToString:objJID.domain]) {
            isExist = YES;
        }
        
    }
    
    if (!isExist) {
        [user.addFriendArray addObject:presence.from];
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:AddNewContectMessage object:nil];
    }
    
}


//好友请求收到的回复.
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
    NSLog(@"ID: %@ 状态: %@",presence.from,presence.type);
    UserInfoManager *user = [UserInfoManager shardManager];
    
    if ([presence.type isEqualToString:@"available"] && ![presence.from isEqual:user.jid]) {
        
        for (TBContactModel *obj in user.contactsArray) {
            
            if ([presence.from.user isEqualToString:obj.jid.user]) {
                
                if (!obj.isAvailable) {
                    
                    obj.isAvailable = YES;
                    
                    //发送上线通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:ContactIsAvailable object:obj];
                    
                }
                
            }
            
            
        }
        
    }
    
    
    if ([presence.type isEqualToString:@"unavailable"] && ![presence.from isEqual:user.jid]) {
        
        for (TBContactModel *obj in user.contactsArray) {
            
            if ([presence.from.user isEqualToString:obj.jid.user]) {
                
                if (obj.isAvailable) {
                    
                    obj.isAvailable = NO;
                    
                    //发送上线通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:ContactIsAvailable object:obj];
                    
                }
                
            }
            
            
        }
        
    }
    
    
    //收到对方取消定阅我得消息
    if ([presence.type isEqualToString:@"unsubscribe"]) {
        //从我的本地通讯录中将他移除
        [[TBXmppManager defaultManage].roster removeUser:presence.from];
        
    }
    
}



-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSXMLElement *request = [message elementForName:@"request"];
    if (request)
    {
        if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
        {
            //组装消息回执
            XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[message attributeStringValueForName:@"id"]];
            NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [msg addChild:recieved];
            
            //发送回执
            [[TBXmppManager defaultManage].stream  sendElement:msg];
        }
    }else
    {
        NSXMLElement *received = [message elementForName:@"received"];
        if (received)
        {
            if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
            {
                //发送成功
                NSLog(@"message send success!");
            }
        }
    }
    
    
}

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags{
    
    [UserInfoManager clearAllData];
    
    [[TBXmppManager defaultManage].stream authenticateWithPassword:[UserInfoManager shardManager].password error:nil];
    
}




//登录成功的方法.
//- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    
  //  XMPPPresence *presence =  [XMPPPresence presenceWithType:@"available"];
    
   // [[TBXmppManager defaultManage].stream sendElement:presence];
    
   // [[TBXmppManager defaultManage].roster fetchRoster];
    
//}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
