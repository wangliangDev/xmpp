//
//  UserInfoManager.m
//  daZhongDianPing
//
//  Created by ttbb on 16/9/23.
//  Copyright © 2016年 ttbb. All rights reserved.
//

#import "UserInfoManager.h"
#import "fileCacheManager.h"

static UserInfoManager *_userInfoManager = nil;

@implementation UserInfoManager




+(instancetype)shardManager
{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _userInfoManager = [[UserInfoManager alloc]init];
    
    });
    
    return _userInfoManager;
}


-(instancetype)init
{
    
    self = [super init];
    
    if (self) {
        
        self.headerImage = [UIImage new];
        self.addFriendArray = [NSMutableArray new];
        self.contactsArray = [NSMutableArray new];
    }
    
    return self;
    
}

+(void)clearAllData
{
    [_userInfoManager.addFriendArray removeAllObjects];
    [_userInfoManager.contactsArray removeAllObjects];
}

-(UserInfoModel*)getUserInfo
{
    
    id model = [fileCacheManager getObjectWithFileName:NSStringFromClass([UserInfoModel class])];
    
    if (model != nil) {
        
        return model;
    }
    return nil;
}

-(void)updateUserInfo:(UserInfoModel *)userModel
{
    
    [fileCacheManager saveObject:userModel fileName:NSStringFromClass([UserInfoModel class])];
}

-(void)loginedSaveUserInfo:(id)userInfo
{
    
    UserInfoModel *userModel = [[UserInfoModel alloc]initWithDictionary:userInfo error:nil];
    
    [fileCacheManager saveObject:userModel fileName:NSStringFromClass([UserInfoModel class])];
    
    [fileCacheManager saveUserDefaults:@YES forKey:loginFlag];
    
    
}


-(void)logOut
{
    
    [fileCacheManager removeObjectWithFileName:NSStringFromClass([UserInfoModel class])];
    
     [fileCacheManager saveUserDefaults:@NO forKey:loginFlag];
}


-(BOOL)isLogin
{
    
   return  [[NSUserDefaults standardUserDefaults] boolForKey:loginFlag];
}
@end














































