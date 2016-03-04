//
//  RegistViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/3/1.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "RegistViewController.h"
#import "FriendListViewController.h"
@interface RegistViewController ()<UITextFieldDelegate,EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _userName.delegate = self;
    _password.delegate = self;
    _passwordAgain.delegate = self;
    
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
        
    
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_userName.text password:_password.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [HXAlert showAlertViewAtViewController:self withTitle:@"提示" message: [NSString stringWithFormat:@"%@",error] confirmMessage:@"确定" confirmStyle:(UIAlertActionStyleDefault) confirmHandler:nil cancelMessage:@"取消" cancelStyle:(UIAlertActionStyleCancel) cancleHandler:nil];
                HXLog(@"%@",error);
                
            }
        } onQueue:dispatch_get_main_queue()];
        
        
    
    }
}

- (IBAction)backBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [_userName resignFirstResponder];
    
    
    [_password resignFirstResponder];
    
    
    [_passwordAgain resignFirstResponder];
    

}



@end
