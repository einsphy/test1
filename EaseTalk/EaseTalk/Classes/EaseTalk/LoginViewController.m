//
//  LoginViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/3/2.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "FriendListViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pasword;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
}
- (IBAction)loginBtnClick:(UIButton *)sender {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_username.text password:_pasword.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            FriendListViewController *easeVC = [[FriendListViewController alloc]init];
        } else {
            [HXAlert showAlertViewAtViewController:self withTitle:@"提示" message:@"用户名或密码不正确,请重新输入!" confirmMessage:@"确定" confirmStyle:(UIAlertActionStyleDefault) confirmHandler:nil cancelMessage:@"" cancelStyle:(UIAlertActionStyleCancel) cancleHandler:nil];
        }
    } onQueue:nil];
    
}

- (IBAction)registBtnClick:(UIButton *)sender {
    RegistViewController *registVC = [[RegistViewController alloc]init];
    [self presentViewController:registVC animated:YES completion:nil];
    
}


@end
