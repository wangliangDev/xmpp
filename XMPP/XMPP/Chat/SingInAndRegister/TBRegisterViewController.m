//
//  TBRegisterViewController.m
//  XMPP
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBRegisterViewController.h"
#import "TBRegisterHeadImageController.h"

@interface TBRegisterViewController ()<UITextFieldDelegate,XMPPStreamDelegate,XMPPvCardTempModuleDelegate>{
    
   
}

@property(nonatomic,strong)UITextField *userName;

@property(nonatomic,strong)UITextField *loginName;

@property(nonatomic,strong)UITextField *passWord;

@property(nonatomic,strong)UITextField *verifyPassWord;

@property(nonatomic,strong)UIButton *registerButton;


@end

@implementation TBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     self.view.backgroundColor = RGB(240, 240, 240);
    
    [[TBXmppManager defaultManage].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[TBXmppManager defaultManage].vCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self.view addSubview:self.loginName];
    [self.view addSubview:self.userName];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.verifyPassWord];
    [self.view addSubview:self.registerButton];
    
     [self loadNavigationView];
    
}
-(void)loadNavigationView{
    
    self.navigationItem.title = @"注册会员";
    self.navigationController.navigationBar.barTintColor = RGB(52, 147, 255);
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popLoginVC)];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17],
                                                                    
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17],
                                                                     
                                                                     NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}

-(void)popLoginVC{
    
    [self.userName resignFirstResponder];
    [self.loginName resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.verifyPassWord resignFirstResponder];
    
    [UserInfoManager shardManager].isLogin = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.userName resignFirstResponder];
    [self.loginName resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.verifyPassWord resignFirstResponder];
    
}


#pragma mark --XMPPStreamDelegate

-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    
    [[TBXmppManager defaultManage] loginWithUserName:self.loginName.text AndPassWord:self.passWord.text];
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
     [[TKAlertCenter defaultCenter]postAlertWithMessage:@"注册失败"];
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    
    [[TKAlertCenter defaultCenter]postAlertWithMessage:@"登录失败,请检查账号密码"];
}


-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [[Singletion shareInstance]removeHudView];
    
    DefineWeakSelf;
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"设置头像" message:@"设置属于自己的头像" preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的,没问题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TBRegisterHeadImageController *registerHeadImage = [TBRegisterHeadImageController new];
        [registerHeadImage setHidesBottomBarWhenPushed:YES];
        
        [weakSelf.navigationController pushViewController:registerHeadImage animated:YES];
        
    }];
    
    [alertView addAction:action];
    
    
    XMPPvCardTemp *myCard = [XMPPvCardTemp vCardTemp];
    myCard.nickname = self.userName.text;
    [[TBXmppManager defaultManage].vCardTempModule updateMyvCardTemp:myCard];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
   

}


-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid
{
    XMPPvCardTemp *myCard = [[TBXmppManager defaultManage].vCardCoreDataStorage vCardTempForJID:jid xmppStream:[TBXmppManager defaultManage].stream];
    
    NSLog(@"myCard--%@",myCard);
}


-(void)finishRegisterAction{
    
    [[Singletion shareInstance]loadHudView:self.view];
    
    
    if ([self.loginName.text isEqualToString:@""]||self.loginName.text ==nil||[self.userName.text isEqualToString:@""]||self.userName.text ==nil||[self.passWord.text isEqualToString:@""]||self.passWord.text ==nil||[self.verifyPassWord.text isEqualToString:@""]||self.verifyPassWord.text ==nil) {
        
      
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"用户信息填写不完整"];
        
        return;
        
    }
    
    
    if (![self.passWord.text isEqualToString:self.verifyPassWord.text]) {
        
      
        
          [[TKAlertCenter defaultCenter]postAlertWithMessage:@"密码和确认密码不一致"];
        
        return;
        
    }
    
    [[TBXmppManager defaultManage] regiserWithUserName:self.loginName.text AndPassWord:self.passWord.text];
    
    
}


#pragma mark --getter

-(UITextField *)loginName{
    
    if (nil ==_loginName) {
        
        _loginName = [[UITextField alloc]initWithFrame:CGRectMake(25, 100, KSCREEN_WIDTH-50, 50)];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,50,50)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30 ,30)];
        imageView.image = [UIImage imageNamed:@"用户.png"];
        
        [leftView addSubview:imageView];
        
        imageView.center = leftView.center;
        
        [_loginName setLeftView:leftView];
        
        [_loginName setLeftViewMode:UITextFieldViewModeAlways];
        
        _loginName.backgroundColor = RGB(250, 250, 250);
        
        _loginName.layer.borderWidth = 0.8f;
        
        _loginName.layer.borderColor = (__bridge CGColorRef _Nullable)(RGB(80, 80, 80));
        
        _loginName.placeholder =@"登录账号";
        
        _loginName.delegate = self;
    }
    
    return _loginName;
}

-(UITextField *)userName{
    
    if (nil ==_userName) {
        
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(25, 151, KSCREEN_WIDTH-50, 50)];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,50,50)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30 ,30)];
        imageView.image = [UIImage imageNamed:@"名片.png"];
        
        [leftView addSubview:imageView];
        
        imageView.center = leftView.center;
        
        [_userName setLeftView:leftView];
        
        [_userName setLeftViewMode:UITextFieldViewModeAlways];
        
        _userName.backgroundColor = RGB(250, 250, 250);
        
        _userName.layer.borderWidth = 0.8f;
        
        _userName.layer.borderColor = (__bridge CGColorRef _Nullable)(RGB(80, 80, 80));;
        
        _userName.placeholder =@"用户名";
        
        _userName.delegate = self;
    }
    
    return _userName;
}

-(UITextField *)passWord{
    
    if (nil ==_passWord) {
        
        _passWord = [[UITextField alloc]initWithFrame:CGRectMake(25, 202, KSCREEN_WIDTH-50, 50)];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,50,50)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30 ,30)];
        imageView.image = [UIImage imageNamed:@"注册密码.png"];
        
        [leftView addSubview:imageView];
        
        imageView.center = leftView.center;
        
        [_passWord setLeftView:leftView];
        
        [_passWord setLeftViewMode:UITextFieldViewModeAlways];
        
        _passWord.backgroundColor = RGB(250, 250, 250);
        
        _passWord.layer.borderWidth = 0.8f;
        
        _passWord.layer.borderColor = (__bridge CGColorRef _Nullable)(RGB(80, 80, 80));;
        
        _passWord.placeholder =@"密码";
        
        _passWord.delegate = self;
        
        _passWord.secureTextEntry = YES;
        
    }
    
    return _passWord;
}

-(UITextField *)verifyPassWord{
    
    if (nil ==_verifyPassWord) {
        
        _verifyPassWord = [[UITextField alloc]initWithFrame:CGRectMake(25, 253, KSCREEN_WIDTH-50, 50)];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,50,50)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30 ,30)];
        imageView.image = [UIImage imageNamed:@"确认密码.png"];
        
        [leftView addSubview:imageView];
        
        imageView.center = leftView.center;
        
        [_verifyPassWord setLeftView:leftView];
        
        [_verifyPassWord setLeftViewMode:UITextFieldViewModeAlways];
        
        _verifyPassWord.backgroundColor = RGB(250, 250, 250);
        
        _verifyPassWord.layer.borderWidth = 0.8f;
        
        _verifyPassWord.layer.borderColor = (__bridge CGColorRef _Nullable)(RGB(80, 80, 80));;
        
        _verifyPassWord.placeholder =@"确认密码";
        
        _verifyPassWord.delegate = self;
        
        _verifyPassWord.secureTextEntry = YES;
        
    }
    
    return _verifyPassWord;
}

-(UIButton *)registerButton{
    
    if (nil == _registerButton) {
        
        _registerButton = [[UIButton alloc]initWithFrame:CGRectMake(25, 330, KSCREEN_WIDTH-50, 50)];
        
        _registerButton.backgroundColor = RGB(232, 175, 96);
        
        [_registerButton setTitle:@"下一步" forState:UIControlStateNormal];
        
        [_registerButton setTintColor:[UIColor whiteColor]];
        
        _registerButton.layer.cornerRadius = 4;
        
        _registerButton.layer.masksToBounds = YES;
        
        [_registerButton addTarget:self action:@selector(finishRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _registerButton;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
