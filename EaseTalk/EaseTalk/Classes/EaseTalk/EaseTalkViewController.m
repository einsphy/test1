//
//  EaseTalkViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/2/19.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "EaseTalkViewController.h"
#import "LoginViewController.h"
@interface EaseTalkViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *settingTableView;

@property (nonatomic,strong)UIButton *btn;

@end

@implementation EaseTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    
    [self subviews];

}

- (void)subviews
{
    self.btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.btn.width = 40;
    self.btn.height = 40;
    [self.btn setTitle:@"设置" forState:(UIControlStateNormal)];
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(- self.view.width / 2, 0, self.view.width / 2, self.view.height) style:(UITableViewStylePlain)];
    self.settingTableView.dataSource = self;
    self.settingTableView.delegate = self;
    
    [[UIApplication sharedApplication].windows.lastObject addSubview:self.settingTableView];
    
    [self.view addSubview:self.settingTableView];
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"聊天" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = right;

}

- (void)rightClick
{

    


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID = @"cell";

    UITableViewCell *cell = [self.settingTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 5;

}
- (void)btnClick
{
    
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    
    [self.navigationController pushViewController:loginVC animated:YES];
    
//    self.btn.enabled = NO;
//    
//    [UIView animateWithDuration:2.0 animations:^{
//        self.settingTableView.x += self.view.width / 2;
//        HXLog(@"-------");
//    }];

    


}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    self.btn.enabled = YES;
    [UIView animateWithDuration:2.0 animations:^{
        self.settingTableView.x -= self.view.width / 2;
    }];

}

@end
