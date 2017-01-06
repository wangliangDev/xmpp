//
//  TBRegisterHeadImageController.m
//  XMPP
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 TTBB. All rights reserved.
//

#import "TBRegisterHeadImageController.h"

@interface TBRegisterHeadImageController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    
}
@property(nonatomic,strong)UIImageView *headerView;//头像视图

@property(nonatomic,strong)UIImage *headerImg;//头像

@property(nonatomic,strong)UIButton *registerButton;
@end

@implementation TBRegisterHeadImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNavigationView];
    
    [self loadHeaderView];
    
    [self.view addSubview:self.registerButton];

    
   UIImage *image = [[Singletion shareInstance]reSizeImage:[UIImage imageNamed:@"墙纸图片.png"] toSize:CGSizeMake(KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    
     self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

#pragma mark --UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        self.headerImg  = image;
        
        self.headerView.image = self.headerImg;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}


-(void)clickHeaderView{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    DefineWeakSelf;
    
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showPhotoLibraryVC];
        
    }];
    
    [alertVC addAction: alertAction1];
    
    
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf showCameraPickerVC];
    }];
    
    [alertVC addAction: alertAction2];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction: cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)popLoginVC
{
    
    [UserInfoManager shardManager].isLogin = YES;
    XMPPvCardTemp *vCard = [TBXmppManager defaultManage].vCardTempModule.myvCardTemp;
    
    
    NSData *data;
    if (UIImagePNGRepresentation(self.headerImg) == nil)
    {
        UIImage *headerimage =[[Singletion shareInstance]reSizeImage:self.headerImg toSize:CGSizeMake(100, 100)];
        
        data = UIImageJPEGRepresentation(headerimage, 1.0);
        vCard.photo = data;
        
    }
    else
    {
        UIImage *headerimage = [[Singletion shareInstance]reSizeImage:self.headerImg toSize:CGSizeMake(100, 100)];
        data = UIImagePNGRepresentation(headerimage);
        vCard.photo = data;
        
    }
    
    [[TBXmppManager defaultManage].vCardTempModule updateMyvCardTemp:vCard];
    
     [self dismissViewControllerAnimated:YES completion:nil];
   

}

#pragma mark ---调取相机---
-(void)showCameraPickerVC{
    
    
    //设置调用类型为相机
    UIImagePickerControllerSourceType  sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        NSLog(@"本设备未发现摄像头!");
        
        return;
        
    }
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    pickerController.sourceType = sourceType;
    
    pickerController.delegate = self;
    
    pickerController.allowsEditing = YES;//设置是否可以进行编辑
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self showDetailViewController:pickerController sender:nil];
    
}


-(void)showPhotoLibraryVC{
    
    UIImagePickerControllerSourceType  sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    pickerController.sourceType = sourceType;
    
    pickerController.delegate = self;
    
    pickerController.allowsEditing = YES;
    
    [self showDetailViewController:pickerController sender:nil];
    
}


-(void)loadNavigationView{
    
    self.navigationItem.title = @"选择头像";
    self.navigationController.navigationBar.barTintColor = RGB(52, 147, 255);
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.hidesBackButton = YES;
    
    
}


-(UIButton *)registerButton{
    
    if (nil == _registerButton) {
        _registerButton = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/4+20, 170+KSCREEN_WIDTH/2, KSCREEN_WIDTH/2-40, 45)];
        
        _registerButton.backgroundColor = RGB(232, 175, 96);
        
        [_registerButton setTitle:@"完成注册" forState:UIControlStateNormal];
        
        [_registerButton setTintColor:[UIColor whiteColor]];
        
        _registerButton.layer.cornerRadius = 4;
        
        _registerButton.layer.masksToBounds = YES;
        
        [_registerButton addTarget:self action:@selector(popLoginVC) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _registerButton;
}
-(void)loadHeaderView{
    
    self.headerImg = [UIImage imageNamed:@"头像2"];
    
    self.headerView = [[UIImageView alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/4, 150, KSCREEN_WIDTH/2, KSCREEN_WIDTH/2)];
    self.headerView.image =[UIImage imageNamed:@"头像2"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeaderView)];
    [self.headerView addGestureRecognizer:tap];
    self.headerView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.headerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
