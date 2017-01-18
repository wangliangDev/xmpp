//
//  TBChatViewController.m
//  XMPP
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TBInPutView.h"
#import "TBContactModel.h"
#import "TBChatContentModel.h"
#import "TBChatCell.h"
#import "fileCacheManager.h"
#import "TranscribeVoiceView.h"

@interface TBChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,XMPPStreamDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,TBChatDelegate,TBInputViewDelegate>{
    
    
}
@property(nonatomic,strong)TBInPutView *inPutView;
@property(nonatomic,strong)UITableView *chatTable;//聊天界面
@property(nonatomic,strong)NSMutableArray *chatDataArray;//聊天记录数组

// 录音机
@property (nonatomic, strong)AVAudioRecorder *audioRecorder;
// 音频播放器
@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@property(nonatomic,strong)TranscribeVoiceView *transcribeVoiceView;

@end

@implementation TBChatViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
   self.navigationItem.title = self.contactModel.vCard.nickname;
    [self.view addSubview:self.chatTable];
    [self.view addSubview:self.inPutView];
    [self setAudioSession];
    [[TBXmppManager defaultManage].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self reloadMessage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** eventRespond ***

-(void)setAudioSession{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    NSError *error = nil;
    
    bool successful = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    
    if (!successful) {
        
         NSLog(@"error doing outputaudioportoverride - %@", [error localizedDescription]);
    }
}

- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    // 设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    // 设置录音采样率,8000是电话采样率,对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    // 设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    // 每个采样点位数,分别为8,16,24,32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    // 是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    // ...其他设置
    return dicM;
}


-(void)setKeyboardHide{
    
    
  //  [self.inPutView tapAction];
}




-(void)reloadMessage{
    
     XMPPMessageArchivingCoreDataStorage *storage = [TBXmppManager defaultManage].messageArchivingCoreDataStoreage;
    

    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:storage.messageEntityName inManagedObjectContext:storage.mainThreadManagedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    
    //对取到的数据进行过滤,传入过滤条件. 传入自己和对方的JID
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@ AND bareJidStr == %@", [TBXmppManager defaultManage].stream.myJID.bare,self.contactModel.jid.bare];
    
    [fetchRequest setPredicate:predicate];
    
    //设置排序的关键字
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [storage.mainThreadManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    [self.chatDataArray removeAllObjects];
    
    self.chatDataArray = [NSMutableArray arrayWithArray:fetchedObjects];
    
    NSLog(@"%ld",self.chatDataArray.count);
    
    [self.chatTable reloadData];
    
    //滚动到tableView最底层
    if (self.chatDataArray.count != 0) {
        [self.chatTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.chatDataArray.count - 1] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
}


-(void)transcribeVoiceAcrion{
    
    TranscribeVoiceView *transcribeVoiceView = [[TranscribeVoiceView alloc]initWithFrame:CGRectMake(0, 0, 120 , 130)];
    self.transcribeVoiceView = transcribeVoiceView;
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width / 2.0;
    CGFloat centerY = [UIScreen mainScreen].bounds.size.height / 2.0;
    self.transcribeVoiceView.center = CGPointMake(centerX, centerY);
    [self.view addSubview:self.transcribeVoiceView];
    
    [self.audioRecorder record];
    
}

-(void)sendVoiceAcrion{

    NSTimeInterval time = self.audioRecorder.currentTime;
    
    if (time < 1.5) {
        
        [self.audioRecorder stop];
        [self.audioRecorder deleteRecording];
        self.transcribeVoiceView.textLable.text = @"说话时间太短";
    }else{
        
        [self.audioRecorder stop];
        NSString *url = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
         url = [url stringByAppendingPathComponent:@"my.wav"];
        NSData *voiceData = [NSData dataWithContentsOfFile:url];
        
        [self sendVoiceMessageWithData:voiceData bodyType:@"voice" withDuringTime:time];
    }

     [self.transcribeVoiceView removeFromSuperview];
}

- (void)sendVoiceMessageWithData:(NSData *)data bodyType:(NSString *)type withDuringTime:(NSTimeInterval)time{

      XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.contactModel.jid];
      NSString *timeStr = [NSString stringWithFormat:@"%f",time];
      [message addAttributeWithName:@"duringTime" stringValue:timeStr];
      [message addBody:type];
      NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
      [message addChild:receipt];
      NSString *base64str = [data base64EncodedStringWithOptions:0];
      XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64str];
      [message addChild:attachment];
    
    
     [[TBXmppManager defaultManage].stream sendElement:message];

}

-(void)sendMessage{

   

  
}

#pragma mark ***XMPPStreamDelegate***

-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    
     [self reloadMessage];
    
     [self.chatTable reloadData];
}

-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    
     NSLog(@"消息发送失败!");
}

//收到消息回执
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
    
    
    
    [self reloadMessage];
    
}

#pragma mark ***chatDelegate***
-(void)tapChatContent:(TBChatContentModel *)ContentModel
{
    
    if ([ContentModel.Message_CoreDataObject.message.body isEqualToString:@"voice"]) {
        
        if (self.audioPlayer.isPlaying) {
            
             [self.audioPlayer stop];
        }
        
        XMPPElement *node = ContentModel.Message_CoreDataObject.message.children.lastObject;
        
         NSString *base64str = node.stringValue;
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64str options:0];
        
        self.audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
        
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
    }
    
}

#pragma mark ---键盘相关---
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if(![textView hasText] && [text isEqualToString:@""]) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.contactModel.jid];
        [message addBody:self.inPutView.inputTextView.text];
        
        NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [message addChild:receipt];
        
        [[TBXmppManager defaultManage].stream sendElement:message];
        
        //输入框内容设置为空,并且关闭发送按钮的用户交互.
        self.inPutView.inputTextView.text = @"";
        
        return NO;
    }
    
    return YES;
    
    
}

//监控输入框的内容是否为空,如果为空,则不能点击按钮
- (void)textViewDidChange:(UITextView *)textView{
    
   
}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [textView reloadInputViews];
    
    return YES;
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
    
}

-(void)keyBoardView:(TBInPutView *)keyBoard ChangeHeight:(CGFloat)height
{
    
    self.chatTable.frame = CGRectMake(0, 64, kScreenWidth, height-10-50);
    
}






-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



#pragma mark *** tableViewDataSoure ***

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.chatDataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

//headerView显示时间
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 35)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, KSCREEN_WIDTH, 25)];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:15];
    
    XMPPMessageArchiving_Message_CoreDataObject *message = self.chatDataArray[section];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *dateTime = [formatter stringFromDate:message.timestamp];
    
    
    label.text = dateTime;
    
    [view addSubview:label];
    
    return view;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *message = [self.chatDataArray objectAtIndex:indexPath.section];
    
    CGFloat height = [[Singletion shareInstance]textHight:message.body font:kFont(17)];
    
    return height +10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TBChatCell" forIndexPath:indexPath];
    
    XMPPMessageArchiving_Message_CoreDataObject *message = [self.chatDataArray objectAtIndex:indexPath.section];
    
    TBChatContentModel *model = [TBChatContentModel new];
    
    model.isSend = message.isOutgoing;
    model.message = message.body;
    if (message.isOutgoing) {
        
        model.headerImage = [UIImage imageNamed:@"头像"];
        
    }else{
        
       
        
        if (self.contactModel.vCard.photo == nil) {
            
            model.headerImage = [UIImage imageNamed:@"头像"];
            
        }else{
            
              model.headerImage = [UIImage imageWithData:self.contactModel.vCard.photo];
        }
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *dateTime = [formatter stringFromDate:message.timestamp];
    
    model.messageTime =dateTime;
    
    model.Message_CoreDataObject =message;
    
    cell.contentModel = model;
    
    return cell;
    
}



#pragma mark ***getter***

-(TBInPutView*)inPutView
{
    if (!_inPutView) {
        
        _inPutView = [[TBInPutView alloc]initWithFrame:CGRectMake(0, KSCREEN_HEIGHT-50, KSCREEN_WIDTH, 50)];
        _inPutView.inputTextView.delegate = self;
        _inPutView.delegate = self;
        
     //   [_inPutView.moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_inPutView.sendSoundButton addTarget:self action:@selector(transcribeVoiceAcrion) forControlEvents:UIControlEventTouchDown];
        
        [_inPutView.sendSoundButton addTarget:self action:@selector(sendVoiceAcrion) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _inPutView;
    
}
-(UITableView*)chatTable
{
    if (!_chatTable) {
        
        _chatTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-114) style:UITableViewStyleGrouped];
        
        _chatTable.backgroundColor = RGB(230, 230, 230);
        
        _chatTable.delegate = self;
        
        _chatTable.dataSource = self;
        
        _chatTable.separatorStyle = NO;
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        [_chatTable registerClass:[TBChatCell class] forCellReuseIdentifier:@"TBChatCell"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setKeyboardHide)];
        
        [_chatTable addGestureRecognizer:tap];

    }
    
    return _chatTable;
    
}


-(AVAudioRecorder*)audioRecorder
{
    if (!_audioRecorder) {
        
        NSURL *url =[fileCacheManager getAudioSavePath];
        NSDictionary *settingDict = [self getAudioSetting];
        NSError *error;
        
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:settingDict error:&error];
        _audioRecorder.delegate = self;
        
        if (error) {
            NSLog(@"创建录音机对象时发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
        
        
    }
    
    return _audioRecorder;
}

-(NSMutableArray*)chatDataArray
{
    if (!_chatDataArray) {
        
        _chatDataArray = [NSMutableArray new];
    }
    
    return _chatDataArray;
}
@end












