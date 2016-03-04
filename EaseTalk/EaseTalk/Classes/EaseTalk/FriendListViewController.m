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
#import "AddFriendViewController.h"
@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate>

@property (nonatomic, strong)UITableView *friendsTableView;
@property (nonatomic, strong)NSMutableArray *listArray;


@end

@implementation FriendListViewController
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

}

-(void)loadView
{
    [super loadView];
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"注销" style:(UIBarButtonItemStylePlain) target:self action:@selector(didClickedCancelButton)];
    
    //注销
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            [_listArray removeAllObjects];
            [_listArray addObjectsFromArray:buddyList];
            [_friendsTableView reloadData];
        } else {
            HXLog(@"错误信息%@",error);
        }
    } onQueue:dispatch_get_main_queue()];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    _listArray  = [NSMutableArray array];
    
    
    
    
    [self subviews];

}

- (void)subviews
{

    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addFriendClick)];
    self.navigationItem.rightBarButtonItem = right;

    self.friendsTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.friendsTableView.dataSource = self;
    self.friendsTableView.delegate = self;
    self.friendsTableView.backgroundColor = [UIColor lightGrayColor];
    self.friendsTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.friendsTableView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}
/**
 注销
 
 */

- (void)didClickedCancelButton
{
    

    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    LoginViewController *loginVC =[[LoginViewController alloc]init];
    [self.navigationController presentViewController:loginVC animated:YES completion:nil];
    


}

- (void)addFriendClick
{

    //跳转到添加好友页面
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc]init];
    [self.navigationController pushViewController:addFriendVC animated:YES];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _listArray.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:ID];
    }
    
    EMBuddy *bubby = _listArray[indexPath.row];
    cell.textLabel.text = bubby.username;
    
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ChatViewViewController *chatVC = [[ChatViewViewController alloc]init];
    
    EMBuddy *bubby = _listArray[indexPath.row];
    
    
    chatVC.name = bubby.username;
    
    
    [self presentViewController:chatVC animated:YES completion:nil];
    

}

-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    
    

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"来自%@",username] message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * action) {
        
        EMError *error;
        
        if ([[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error] && !error) {
            
            //发送同意成功
            
               [ [EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
                    if (!error)
                    {
                        HXLog(@"获取成功");
                        [_listArray removeAllObjects];
                        [_listArray addObjectsFromArray:buddyList];
                        [_friendsTableView reloadData];
                    }
                   
                   /**
                    回到主队列
                    
                    */
               } onQueue:dispatch_get_main_queue()];
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






@end
