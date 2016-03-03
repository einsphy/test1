//
//  EaseTalkViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/2/19.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "FriendListViewController.h"
#import "LoginViewController.h"
#import "ChatViewViewController.h"
@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate>

@property (nonatomic, strong)UITableView *friendsTableView;
@property (nonatomic, strong)NSMutableArray *listArray;


@end

@implementation FriendListViewController
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];

}

-(void)loadView
{
    [super loadView];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonClick)];
    
    //注销
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            [_listArray removeAllObjects];
            [_listArray addObjectsFromArray:buddyList];
            [_friendsTableView reloadData];
        } else {
            HXLog(@"错误信息%@",error);
        }
    } onQueue:nil];

}

- (void)leftBarButtonClick
{


}
- (void)viewDidLoad {
    [super viewDidLoad];

    _listArray  = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"注销" style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickedCancelButton)];
    
    
    
    [self subviews];

}

- (void)subviews
{
//    self.btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    self.btn.width = 40;
//    self.btn.height = 40;
//    [self.btn setTitle:@"设置" forState:(UIControlStateNormal)];
//    
//    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.btn];
//    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addFriendClick)];
    self.navigationItem.rightBarButtonItem = right;

    self.friendsTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.friendsTableView.dataSource = self;
    self.friendsTableView.delegate = self;
    
    
    [self.view addSubview:self.friendsTableView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}
/**
 注销
 
 */

- (void)didClickedCancelButton
{
    

    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    


}

- (void)addFriendClick
{

    //跳转到添加好友页面
   // [self.navigationController pushViewController:[] animated:<#(BOOL)#>]


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID = @"cell";

    UITableViewCell *cell = [self.friendsTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    
    EMBuddy *bubby = _listArray[indexPath.row];
    cell.textLabel.text = bubby.username;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _listArray.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ChatViewViewController *chatVC = [[ChatViewViewController alloc]init];
    
    EMBuddy *bubby = _listArray[indexPath.row];
    
#warning title要改回name及在聊天时的用户名
    
    chatVC.title = bubby.username;
    
    
    [self.navigationController pushViewController:chatVC animated:YES];
    

}

-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    
    

    UIAlertController *alertVC = [[UIAlertController alloc]init];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error;
        
        if ([[EaseMob sharedInstance].chatManager acceptBuddyRequest:@"好" error:&error] && !error) {
            
            //发送同意成功
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [ [EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
                    if (!error) {
                        HXLog(@"获取成功");
                        [_listArray removeAllObjects];
                        [_listArray addObjectsFromArray:buddyList];
                        [_friendsTableView reloadData];
                    }
                   
                   /**
                    回到主队列
                    
                    */
               } onQueue:dispatch_get_main_queue()];
            });
            
        }
        
        
    }];
    
    
    
    //
    
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"滚" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
        //SDK错误
        EMError *error;
        
        //拒绝好友的请求方法
        if ([[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"快滚" error:&error] && !error) {
            HXLog(@"拒绝成功");
        }
        
    }];
    
    [alertVC addAction:acceptAction];
    [alertVC addAction:rejectAction];
    
    [self showDetailViewController:alertVC sender:nil];
    
    

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




@end
