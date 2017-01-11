//
//  BaseViewController.m
//  NewSmartLight
//
//  Created by apple on 2016/11/17.
//  Copyright © 2016年 LianShanYi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (){
    
    
}
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIBarButtonItem *leftBarButtonItem;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    self.view.backgroundColor = kWhiteColor;
    
    self.navigationController.navigationBar.barTintColor = RGB(21, 21, 21);
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:18],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17],
                                                                    NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17],
                                                                     
                                                                     NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --getView

-(UIButton*)backButton
{
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 40, 40);
        [_backButton setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    return _backButton;
    
}

-(UIBarButtonItem*)leftBarButtonItem
{
    if (!_leftBarButtonItem) {
        
        _leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
    }
    
    return _leftBarButtonItem;
}

-(void)back:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end














