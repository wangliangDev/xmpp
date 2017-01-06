//
//  UserInfoManager.h
//  daZhongDianPing
//
//  Created by ttbb on 16/9/23.
//  Copyright © 2016年 ttbb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface UserInfoManager : NSObject{
    
    
}

@property(nonatomic,assign)BOOL isLogin;

@property(nonatomic,strong)NSString *password;
@property(nonatomic,copy) XMPPJID *jid;
@property(nonatomic,strong)UIImage *headerImage;
//用户名片
@property(nonatomic,strong)XMPPvCardTemp *vCard;

//从服务器获取到的好友数组.(杂乱无章,需要排序)
@property(nonatomic,strong)NSMutableArray *contactsArray;
//请求好友数组.存储的是请求者的JID
@property(nonatomic,strong)NSMutableArray  <XMPPJID*>*addFriendArray;

//清除所有数据
+(void)clearAllData;
/**
 *  单例类
 *
 *  @return 返回单例
 */
+(instancetype)shardManager;


-(void)loginedSaveUserInfo:(id)userInfo;

-(void)logOut;

-(UserInfoModel*)getUserInfo;

-(void)updateUserInfo:(UserInfoModel *)userModel;


@end
