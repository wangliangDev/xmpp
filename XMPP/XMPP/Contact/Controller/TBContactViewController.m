//
//  TBContactViewController.m
//  XMPP
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBContactViewController.h"
#import "TBContactModel.h"
#import "TBNewFriendCell.h"
#import "TBContactCell.h"
#import "TBAddContactController.h"
#import "TBChatViewController.h"

@interface TBContactViewController ()<UITableViewDelegate,UITableViewDataSource,XMPPRosterDelegate,XMPPvCardAvatarDelegate,XMPPvCardTempModuleDelegate>{
    
    
    
}

@property(nonatomic,strong)UITableView *contactsList;//好友列表

@property(nonatomic,strong)NSMutableDictionary *contactsPinyinDic;//联系人分级字典(用于显示的数据)

@property(nonatomic,strong)NSMutableArray *indexArray;//索引数组

@property(nonatomic,assign)BOOL isDeleteFriend;//是否是删除好友操作,设置布尔值的原因是防止服务器无故刷新数据

@property(nonatomic,strong)UIImage *menuImage;//菜单图片
@property(nonatomic,strong)UserInfoManager *user;

@end

@implementation TBContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initObject];
    [self addNotification];
    [self loadNavigationView];
    [self.view addSubview:self.contactsList];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //修改状态栏显示状态
  
    
    [self reloaList];
}


-(void)initObject{
    
    [[TBXmppManager defaultManage].roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[TBXmppManager defaultManage].vCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[TBXmppManager defaultManage].vCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.view.backgroundColor = kWhiteColor;
    self.isDeleteFriend = NO;
    
}

-(void)addNotification
{
    
    //添加新的好友的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewContactAction) name:AddNewContectMessage object:nil];
    
    //好友上下线
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactIsAvailable) name:ContactIsAvailable object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaList) name:@"addContactReload" object:nil];
    
}


-(void)loadNavigationView{
    
    self.navigationItem.title = @"好友列表";
//    self.navigationController.navigationBar.barTintColor = RGB(21, 21, 21);
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:18],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(reloaList)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17],
                                                                     
                                                                     NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    
}

-(void)reloaList{
    
    self.isDeleteFriend = NO;
    
    [[TBXmppManager defaultManage].roster fetchRoster];
    
    [self networkingWithContactsArray];
    
}

-(void)networkingWithContactsArray{
    
    self.contactsPinyinDic = [NSMutableDictionary new];
    
    NSArray *contatArr = self.user.contactsArray;
    
    
    for (TBContactModel *model in contatArr) {
        
        NSString * firstWord = [[Singletion shareInstance]transform:model.vCard.nickname];
        
        if (self.contactsPinyinDic[firstWord] == nil)
        {
            //如果联系人字典数组中没有该分组,那么就初始化一个分组数组,然后存储.
            NSMutableArray *sectionArray = [NSMutableArray new];
            
            [sectionArray addObject:model];
            
            [self.contactsPinyinDic setObject:sectionArray forKey:firstWord];
            
        }else{
            
            NSMutableArray *sectionArray =self.contactsPinyinDic[firstWord];
            
            [sectionArray addObject:model];
        }
    }
    
     self.indexArray = [NSMutableArray arrayWithArray:self.contactsPinyinDic.allKeys];
     [self.indexArray addObject:@""];//添加一个空的字符串,用于菜单分组
    
    for (int i = 0; i < self.indexArray.count; i++)
    {
        
        for (int j = 0; j < i; j++)
        {
            if (self.indexArray[j] > self.indexArray[i]) {
                
                NSString *objString = self.indexArray[j];
                self.indexArray[j] =  self.indexArray[i];
                self.indexArray[i] = objString;
            }
            
        }
        
    }
    
    if ([self.indexArray containsObject:@"#"]) {
        
        [self.indexArray removeObject:@"#"];
        
        [self.indexArray addObject:@"#"];
    }
    
    [self.contactsList reloadData];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark --好友请求
//添加新的联系人的通知
-(void)addNewContactAction{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    //判断当前是否是在列表的最上端
    NSArray *indexPathArray = [self.contactsList indexPathsForVisibleRows];
    for (NSIndexPath *obj in indexPathArray) {
        if ([obj isEqual:indexPath]) {
            [self.contactsList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
}
#pragma mark --好友上下线通知方法

-(void)contactIsAvailable{
    
    [self reloaList];
    
}


#pragma mark --XMPPRosterDelegate

-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    
    [self networkingWithContactsArray];
    
}

//对方好友列表
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    
    //互为好友
    if ([[[item attributeForName:@"subscription"] stringValue] isEqualToString:@"both"]||[[[item attributeForName:@"subscription"] stringValue] isEqualToString:@"from"]||[[[item attributeForName:@"subscription"] stringValue] isEqualToString:@"to"]) {
        
        NSString *SJid = [[item attributeForName:@"jid"] stringValue];
        
        //把字符串类型的JID转换成XMPPJID
        XMPPJID *jid = [XMPPJID jidWithString:SJid];
        
        if (!self.isDeleteFriend) {
            
            BOOL isExist = NO;
            //是否存在，如果存在这个用户就不用加
            for (TBContactModel *contact in self.user.contactsArray) {
                
                if ([contact.jid.user isEqualToString:jid.user]) {
                    
                    isExist = YES;
                    
                }
                
            }
            
            if (!isExist) {
                //添加数据
                XMPPvCardTemp *vCard =  [[TBXmppManager defaultManage].vCardTempModule vCardTempForJID:jid shouldFetch:YES];
                
                [[TBXmppManager defaultManage].vCardTempModule fetchvCardTempForJID:jid ignoreStorage:YES];
                
                TBContactModel *contact = [TBContactModel new];
                contact.jid = jid;
                contact.vCard =vCard;
                contact.isAvailable = NO;
                
                [self.user.contactsArray addObject:contact];
                

            }
            
        }
        
    }
    
    //删除好友操作
    if ([[[item attributeForName:@"subscription"] stringValue] isEqualToString:@"remove"]) {
        
        NSString *SJid = [[item attributeForName:@"jid"] stringValue];
        
        //把字符串类型的JID转换成XMPPJID
        XMPPJID *jid = [XMPPJID jidWithString:SJid];
        TBContactModel *contact;
        for (TBContactModel *obj in self.user.contactsArray) {
            
            if ([obj.jid.user isEqualToString:jid.user]) {
                
                contact = obj;
                
            }
            
        }
        
        [self.user.contactsArray removeObject:contact];
        
        [self networkingWithContactsArray];
        
    }
    

}


#pragma mark --UITableViewDelegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.indexArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
        
    }else{
        
        NSMutableArray *sectionArray =self.contactsPinyinDic[self.indexArray[section]];
        
        return sectionArray.count;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section== 0) {
        
        return 5.0f;
        
    }else{
        return 20.0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1.0;
    
}

//快速索引
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.indexArray;
    
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    return index;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 20)];
    
    titleLable.text = [NSString stringWithFormat:@"  %@",self.indexArray[section]];
    
    titleLable.font = [UIFont systemFontOfSize:15];
    
    titleLable.tintColor = [UIColor lightGrayColor];
    
    return titleLable;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        TBNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewFriendCell" forIndexPath:indexPath];
        
        return cell;
        
    }else{
        
        
        TBContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
        
        NSMutableArray *sectionArray =self.contactsPinyinDic[self.indexArray[indexPath.section]];
        TBContactModel *model = [sectionArray objectAtIndex:indexPath.row];
        
        cell.contactModel = model;
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
       
        TBAddContactController *addContactVC = [[TBAddContactController alloc]init];
        [addContactVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:addContactVC animated:YES];

        
    }else{
        
        TBChatViewController *chatViewController = [TBChatViewController new];
        [chatViewController setHidesBottomBarWhenPushed:YES];
         NSMutableArray *sectionArray =self.contactsPinyinDic[self.indexArray[indexPath.section]];
        
        TBContactModel *model = [sectionArray objectAtIndex:indexPath.row];
        chatViewController.contactModel = model;
        [self.navigationController pushViewController:chatViewController animated:YES];

    }
    
    
    
}


//左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section>0) {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DefineWeakSelf;
    // 从数据源中删除
    NSMutableArray *sectionArray =self.contactsPinyinDic[self.indexArray[indexPath.section]];
    TBContactModel *contact =sectionArray[indexPath.row];
    
    UIAlertController *alertView =[UIAlertController alertControllerWithTitle:@"确认删除" message:[NSString stringWithFormat:@"确认要删除好友 %@ ?",contact.vCard.nickname] preferredStyle:UIAlertControllerStyleAlert];
    
  
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf.user.contactsArray removeObject:(NSString *)sectionArray[indexPath.row]];
        
        [sectionArray removeObjectAtIndex:indexPath.row];
        
        if (sectionArray.count == 0) {
            
            [weakSelf.contactsPinyinDic removeObjectForKey:weakSelf.indexArray[indexPath.section]];
            
            [weakSelf.indexArray removeObjectAtIndex:indexPath.section];
            
            [tableView reloadData];
            
            
        }else{
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        weakSelf.isDeleteFriend = YES;
        
        
        [[TBXmppManager defaultManage].roster removeUser:contact.jid];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertView addAction:deleteAction];
    [alertView addAction:cancelAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
}




#pragma mark --getter

-(UITableView*)contactsList
{
    if (!_contactsList) {
        
        _contactsList = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        
        _contactsList.delegate = self;
        
        _contactsList.dataSource = self;
        
        _contactsList.separatorStyle = NO;
        
        _contactsList.sectionIndexBackgroundColor = [UIColor clearColor];
        [_contactsList registerClass:[TBContactCell class] forCellReuseIdentifier:@"ContactCell"];
        [_contactsList registerClass:[TBNewFriendCell class] forCellReuseIdentifier:@"NewFriendCell"];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    return _contactsList;
}

-(UserInfoManager*)user
{
    if (!_user) {
        
        _user = [UserInfoManager shardManager];
    }
    
    return _user;
}

-(NSMutableArray*)indexArray
{
    if (!_indexArray) {
        
        _indexArray = [NSMutableArray new];
       
    }
    
    return _indexArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end




