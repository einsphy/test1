//
//  DialogBoxView.m
//  EaseTalk
//
//  Created by einsphy on 16/3/3.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "DialogBoxView.h"
@interface DialogBoxView()

@property (nonatomic, strong)UITextField *draftTextField;

@property (nonatomic, strong)UIButton *sendBtn;

@end
@implementation DialogBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor lightGrayColor];

    
    //输入框
    _draftTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, self.width - 100, self.height - 10)];
    [_draftTextField setBorderStyle:(UITextBorderStyleRoundedRect)];
    [_draftTextField setPlaceholder:@"说点什么吧"];
    [_draftTextField setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:_draftTextField];

    
    
    /**
     发送按钮
     
     */
    _sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_sendBtn setFrame:CGRectMake(CGRectGetMaxX(_draftTextField.frame) + 10, 5, 85, self.height - 10)];
    [_sendBtn setBackgroundColor:HXColor(110, 110, 110)];
    [_sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    [_sendBtn setTintColor:HXColor(255, 255, 255)];
    [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_sendBtn.layer setMasksToBounds:YES];
    [_sendBtn.layer setCornerRadius:4];
    [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_sendBtn];


}


- (void)sendBtnClick:(UIButton *)sender
{

    if (self.buttonClickd) {
        self.buttonClickd(_draftTextField.text);
    }



}

@end
