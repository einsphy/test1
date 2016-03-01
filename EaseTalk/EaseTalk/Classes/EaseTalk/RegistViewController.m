//
//  RegistViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/3/1.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "RegistViewController.h"
#import "EaseTalkViewController.h"
@interface RegistViewController ()<UITextFieldDelegate,EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *label;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /**
     成为管理者，开始进行注册、登录等操作
     
     */
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    
    
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_userName.text password:_password.text];
    _userName.delegate = self;
    
    
}

- (IBAction)registBtnClick:(UIButton *)sender {
    /**
     注册
     
     */
    HXLog(@"sssssss");
    
    if (_userName.text.length == 0 || [_userName.text isEqual:@""] || _password.text.length == 0 || [_password.text isEqual:@""] || _passwordAgain.text.length == 0 || [_passwordAgain.text isEqual:@""] ) {
        
        [HXAlert showAlertViewAtViewController:self withTitle:@"提示" message:@"账户名或密码不能为空!" confirmMessage:@"确定" confirmStyle:(UIAlertActionStyleDefault) confirmHandler:nil cancelMessage:@"取消" cancelStyle:(UIAlertActionStyleCancel) cancleHandler:nil];
        
    } else if(![_password.text isEqualToString:_passwordAgain.text]){
        [HXAlert showAlertViewAtViewController:self withTitle:@"提示" message:@"两次输入的密码不同,请重新输入!" confirmMessage:@"确定" confirmStyle:(UIAlertActionStyleDefault) confirmHandler:nil cancelMessage:@"取消" cancelStyle:(UIAlertActionStyleCancel) cancleHandler:nil];
    }else
    {
        
    
        //EaseTalkViewController *easeTVC = [[EaseTalkViewController alloc]init];
//        [HXAlert showAlertViewAtViewController:self withTitle:@"提示" message:@"恭喜您,注册成功" confirmMessage:@"确定" confirmStyle:(UIAlertActionStyleDefault) confirmHandler:^(UIPreviewAction *action, UIViewController *previewViewController) {
//            [self popoverPresentationController];
//        } cancelMessage:@"取消" cancelStyle:(UIAlertActionStyleCancel) cancleHandler:nil];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.view resignFirstResponder];

    return YES;

}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//[self.view resignFirstResponder];
//
//}

@end
