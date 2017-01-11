//
//  TBAddContactController.m
//  XMPP
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBAddContactController.h"
#import "TBContactModel.h"
#import "SDAddContactCell.h"


@interface TBAddContactController ()<UIAlertViewDelegate,XMPPRosterDelegate,UITableViewDelegate,UITableViewDataSource,XMPPStreamDelegate,SDAddContactCellDelegate>{
    
    
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation TBAddContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor colorWithPatternImage:[[Singletion shareInstance] reSizeImage:[UIImage imageNamed:@"没有好友请求"] toSize:CGSizeMake(KSCREEN_WIDTH, KSCREEN_WIDTH)]];
    
     [[TBXmppManager defaultManage].roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
     [[TBXmppManager defaultManage].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self loadNavigationView];
    [self.view addSubview:self.tableView];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenAddFirendList) name:AddNewContectMessage object:nil];
    
}

-(void)hiddenAddFirendList{
    
    if ([UserInfoManager shardManager].addFriendArray.count ==0) {
        
        self.tableView.hidden = YES;
        
    }else{
        
        self.tableView.hidden = NO;
        
    }
    
}



-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)loadNavigationView{
    
    self.navigationItem.title = @"新的朋友";
   
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addNewContact)];
    
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17],
                                                                     
                                                                     NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
}


- (void)XMPPAddFriendSubscribe:(NSString *)name
{
    
    XMPPJID *addJid = [XMPPJID jidWithUser:name domain:kDomin resource:kResource];
    
    NSArray *friendArray = [UserInfoManager shardManager].addFriendArray;
    
    for (XMPPJID *obj in friendArray)
    {
        
        if ([obj.user isEqualToString:addJid.user])
        {
            
            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"添加用户已经在你的请求列表中"];
            
            return ;
        }
    }
    
    NSArray *contactArray = [UserInfoManager shardManager].contactsArray;
    
    for (TBContactModel * model in contactArray)
    {
        
        if ([model.jid.user isEqualToString:addJid.user])
        {
            
            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"用户已经是你的好友"];
            
            return;
        }
    }
    
    if ([[UserInfoManager shardManager].jid.user isEqualToString: addJid.user]) {
        
        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"不能加自己为好友"];
        
        return;
    }
    
    [[TBXmppManager defaultManage].roster subscribePresenceToUser:addJid];
}

#pragma mark --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [UserInfoManager shardManager].addFriendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDAddContactCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"SDAddContactCell"];
    
    cell.agreeButton.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor greenColor]);
    cell.agreeButton.layer.borderWidth = 1;
    cell.disagreeButton.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor redColor]);
    cell.disagreeButton.layer.borderWidth = 1;
    cell.delegate = self;
    XMPPJID *requestJID =  [UserInfoManager shardManager].addFriendArray[indexPath.row];
    cell.friendidLabel.text = requestJID.user;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

#pragma mark --SDAddContactCellDelegate

-(void)agreeWithFriendRequest:(NSString *)jidUser{
    
    XMPPJID *jid = [XMPPJID jidWithUser:jidUser domain:kDomin resource:kResource];
    XMPPRoster *roster = [TBXmppManager defaultManage].roster;
    
    [roster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
    XMPPJID *deleteJID;
    for (int i = 0; i<[UserInfoManager shardManager].addFriendArray.count; i++) {
        
        XMPPJID *obj = [UserInfoManager shardManager].addFriendArray[i];
        
        if ([obj.user isEqualToString:jidUser]) {
            
            deleteJID = obj;
        }
        
    }
    
    [[UserInfoManager shardManager].addFriendArray removeObject:deleteJID];
    
    UIAlertController *alerView =[UIAlertController alertControllerWithTitle:@"添加成功!" message:[NSString stringWithFormat:@"成功添加:%@成为了好友",jid.user] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    
    [alerView addAction: alertAction];
    
    [self presentViewController:alerView animated:YES completion:nil];
    
    [self.tableView reloadData];
    
    [self hiddenAddFirendList];
    
    
}

-(void)disagressWithFriendRequest:(NSString *)jidUser{
    
    XMPPJID *jidName = [XMPPJID jidWithUser:jidUser domain:kDomin resource:kResource];
    XMPPRoster *roster = [TBXmppManager defaultManage].roster;
    
    [roster rejectPresenceSubscriptionRequestFrom:jidName];
    [roster removeUser:jidName];
    
    
    XMPPJID *deleteJID;
    

    for (int i = 0; i<[UserInfoManager shardManager].addFriendArray.count; i++) {
        
        XMPPJID *obj = [UserInfoManager shardManager].addFriendArray[i];
        
        if ([obj.user isEqualToString:jidUser]) {
            
            deleteJID = obj;
        }
        
    }
    
    [[UserInfoManager shardManager].addFriendArray removeObject:deleteJID];
    [self.tableView reloadData];
    
    UIAlertController *alerView =[UIAlertController alertControllerWithTitle:@"操作成功!" message:[NSString stringWithFormat:@"你已拒绝了:%@的好友请求",jidName.user] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    
    [alerView addAction: alertAction];
    
    [self presentViewController:alerView animated:YES completion:nil];
    
   
    [self hiddenAddFirendList];
    
}




-(void)addNewContact{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"好友账号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    
    
    
}
#pragma mark -- uialertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        [self XMPPAddFriendSubscribe:textField.text];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --getter

-(UITableView*)tableView
{
    if (!_tableView) {
        
       _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        
        _tableView.backgroundColor = RGB(240, 240, 240);
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = NO;
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        [_tableView registerClass:[SDAddContactCell class] forCellReuseIdentifier:@"SDAddContactCell"];
        
        [self hiddenAddFirendList];

    }
    
    return _tableView;
    
}


@end








