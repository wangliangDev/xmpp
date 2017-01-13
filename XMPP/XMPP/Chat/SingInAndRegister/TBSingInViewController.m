//
//  TBSingInViewController.m
//  XMPP
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBSingInViewController.h"
#import "TBMyViewController.h"
#import "TBChatListController.h"
#import "TBContactViewController.h"
#import "TBDisconverViewController.h"
#import "TTBBTabbarController.h"
#import "AppDelegate.h"
#import "TBRegisterViewController.h"


@interface TBSingInViewController ()<UITextFieldDelegate,XMPPStreamDelegate>{
    
    TBMyViewController *myVC;
    TBContactViewController *contactVC;
    TBDisconverViewController *disconverVC;
    TBChatListController *chatListVC;
    TTBBTabbarController *tabbar;
    TBXmppManager *xmppManager;
    XMPPStream *stream;
    UserInfoManager *userInfoManager;

}

@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIButton *registerButton;
@property(nonatomic,strong)UITextField *userName;
@property(nonatomic,strong)UITextField *passWord;
@property(nonatomic,strong)UIImageView *logoImageView;

@end

@implementation TBSingInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    xmppManager = [TBXmppManager defaultManage];
    stream = xmppManager.stream;
    userInfoManager = [UserInfoManager shardManager];
    [xmppManager.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self.frontRollView addSubview:self.logoImageView];
    [self.frontRollView addSubview:self.userName];
    [self.frontRollView addSubview:self.passWord];
    [self.frontRollView addSubview:self.loginButton];
    [self.frontRollView addSubview:self.registerButton];
}

-(void)changeRootViewControl
{
    chatListVC = [[TBChatListController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:chatListVC];
    
    contactVC = [[TBContactViewController alloc]init];
    UINavigationController *discountNav = [[UINavigationController alloc]initWithRootViewController:contactVC];
    
    disconverVC = [[TBDisconverViewController alloc]init];
    UINavigationController *discoverNav = [[UINavigationController alloc]initWithRootViewController:disconverVC];
    
    myVC = [[TBMyViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:myVC];
    
    tabbar = [[TTBBTabbarController alloc]init];
    
    NSArray *array = @[homeNav,discountNav,discoverNav,mineNav];
    
    tabbar.buttonCount = (int)array.count;
    tabbar.tabbarBgColor = RGB(248, 248, 248);
    tabbar.titleNormalColor = [UIColor grayColor];
    tabbar.titleSelectedColor = RGB(252, 91, 45);
    
    [tabbar creatButtonWithNormalName:@"tabbar_mainframe" andSelectName:@"tabbar_mainframeHL" andTitle:@"聊天" andIndex:0 ];
    
    [tabbar creatButtonWithNormalName:@"tabbar_contacts" andSelectName:@"tabbar_contactsHL" andTitle:@"联系人" andIndex:1 ];
    
    [tabbar creatButtonWithNormalName:@"tabbar_discover" andSelectName:@"tabbar_discoverHL" andTitle:@"发现" andIndex:2 ];
    
    [tabbar creatButtonWithNormalName:@"tabbar_me" andSelectName:@"tabbar_meHL" andTitle:@"我的" andIndex:3  ];
    tabbar.itemArray = array;
    
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    delegate.window.rootViewController=tabbar;
    
   

    
}

#pragma mark --eventRespond

-(void)skipAppRootMainViewController{
    
   
    [xmppManager loginWithUserName:self.userName.text AndPassWord:self.passWord.text];
    
    [[Singletion shareInstance]loadHudView:self.view];
    
    [_passWord resignFirstResponder];
    [_userName resignFirstResponder];
    
    
    
}

-(void)pushRegisterVC
{
    
    UINavigationController *registerNC = [[UINavigationController alloc]initWithRootViewController:[[TBRegisterViewController alloc]init]];
    
    [self presentViewController:registerNC animated:YES completion:nil];
}

#pragma mark --XMPPStreamDelegate

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    
    [stream sendElement:presence];
    userInfoManager.jid = [XMPPJID jidWithUser:self.userName.text domain:kDomin resource:kResource];
    userInfoManager.password = self.passWord.text;
    [xmppManager.roster fetchRoster];
   
    
    
    if (self.timer !=nil) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.rollTimer != nil) {
        [self.rollTimer invalidate];
        self.rollTimer = nil;
    }
  
    [[Singletion shareInstance]removeHudView];
    
    [self changeRootViewControl];
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    
    [[TKAlertCenter defaultCenter]postAlertWithMessage:@"登录失败,请检查账号密码"];
}


#pragma mark --getter

-(UIImageView *)logoImageView{
    
    if (nil == _logoImageView) {
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH/2-50, 100, 90, 80)];
        
        _logoImageView.image = [UIImage imageNamed:@"SDChatLogo.png"];
        
        
    }
    
    
    return _logoImageView;
}

-(UITextField *)userName{
    
    if (nil == _userName) {
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/2-150, 200, 300, 40)];
        
        _userName.backgroundColor = [UIColor whiteColor];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,40,40)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30 ,30)];
        
        imageView.image = [UIImage imageNamed:@"用户.png"];
        
        [leftView addSubview:imageView];
        
        imageView.center = leftView.center;
        
        [_userName setLeftView:leftView];
        
        [_userName setLeftViewMode:UITextFieldViewModeAlways];
        
        _userName.placeholder = @"请输入账号";
        
        _userName.delegate = self;
        
        _userName.layer.cornerRadius = 4;
        
        _userName.layer.masksToBounds = YES;
    }
    
    return _userName;
    
}

-(UITextField *)passWord{
    
    if (nil == _passWord) {
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/2-150, 260, 300, 40)];
        
        _passWord.backgroundColor = [UIColor whiteColor];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,40,40)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30 ,30)];
        imageView.image = [UIImage imageNamed:@"密码.png"];
        
        [leftView addSubview:imageView];
        
        imageView.center = leftView.center;
        
        [_passWord setLeftView:leftView];
        
        [_passWord setLeftViewMode:UITextFieldViewModeAlways];
        
        _passWord.placeholder = @"请输入密码";
        
        _passWord.delegate = self;
        
        _passWord.layer.cornerRadius = 4;
        
        _passWord.layer.masksToBounds = YES;
        
        _passWord.secureTextEntry = YES;
    }
    return _passWord;
    
}

-(UIButton *)loginButton{
    
    if (nil == _loginButton) {
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(KSCREEN_WIDTH/2 +30, 340, 120,40 );
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTintColor:[UIColor whiteColor]];
        _loginButton.backgroundColor = [UIColor orangeColor];
        _loginButton.layer.cornerRadius = 4;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(skipAppRootMainViewController) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _loginButton;
    
}


-(UIButton *)registerButton{
    
    if (nil == _registerButton) {
        
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(KSCREEN_WIDTH/2 -150 , 340, 120,40 );
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTintColor:[UIColor whiteColor]];
        _registerButton.backgroundColor = [UIColor orangeColor];
        _registerButton.layer.cornerRadius = 4;
        _registerButton.layer.masksToBounds = YES;
        [_registerButton addTarget:self action:@selector(pushRegisterVC) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _registerButton;
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
