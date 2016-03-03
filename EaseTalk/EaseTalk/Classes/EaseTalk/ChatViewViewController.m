//
//  ChatViewViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/3/3.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "ChatViewViewController.h"
#import "DialogBoxView.h"
@interface ChatViewViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)DialogBoxView *dialogBoxView;

@property (nonatomic, strong)EMConversation *conversation;

@end

@implementation ChatViewViewController
-(void)loadView
{

    [super loadView];
    self.title = _name;
    self.navigationController.navigationBar.translucent = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];


}
- (void)viewDidLoad {
    [super viewDidLoad];

    [_tableView setAllowsSelection:NO];
    
    [self registerForKeyBoardNotifications];
    
    _dialogBoxView = [[DialogBoxView alloc]initWithFrame:CGRectMake(0, self.view.height - 114, self.view.width, 50)];
    
    __weak typeof(self) weakSelf = self;
    _dialogBoxView.buttonClickd = ^(NSString *draftText)
    {
    
        [weakSelf sendMessageWithDraftText:draftText];
    
    };
    
    

    [self.view addSubview:_dialogBoxView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    [self reloadChatRecords];
    
}


-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    [self removeForKeyboardNotifications];

}

/**
 使用草稿发送一条消息
 
 */
#pragma  mark -SendMessage

- (void)sendMessageWithDraftText:draftText
{

    EMChatText *chatText = [[EMChatText alloc]initWithText:draftText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithChatObject:chatText];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc]initWithReceiver:_name bodies:@[body]];
    
    
    /**
     设为单聊模式
     
     */
    message.messageType = eMessageTypeChat;
    
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        
    } onQueue:dispatch_get_main_queue() completion:^(EMMessage *message, EMError *error) {
        //准备发送
        [self reloadChatRecords];
    } onQueue:dispatch_get_main_queue()];

}

#pragma  mark --ReciveMessage
/**
 当收到了一条消息时
 
 */
-(void)didReceiveMessage:(EMMessage *)message
{

    [self reloadChatRecords];


}

/**
 重新加载tableview上显示的信息,并移动到最后一行
 
 */
#pragma mark --reloadChatRecords
- (void)reloadChatRecords
{
    
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_name conversationType:eConversationTypeChat];
    
    
    [_tableView reloadData];
    
    if ([_conversation loadAllMessages].count > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_conversation loadAllMessages].count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }

}

/**
 注册通知中心
 
 */
#pragma mark --keyboardNotification
- (void)registerForKeyBoardNotifications
{
    
    /**
     使用通知注册观察当键盘要出现时
     
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    

}


- (void)removeForKeyboardNotifications
{


}
@end
