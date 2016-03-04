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
    _tableView.tableFooterView = [[UIView alloc]init];
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
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];

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
    
    
    /**
     使用通知注册观察键盘要消失时
     
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    

}

#pragma mark --移除观察者

- (void)removeForKeyboardNotifications
{

    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (void)didKeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    HXLog(@"%f",keyboardSize.height);
    
    //输入框位置动画加载
    [self beginMoveUpAnimation:keyboardSize.height];
    


}

- (void)didKeyboardWillHide:(NSNotification *)notification
{
    [self beginMoveUpAnimation:0];
    
}

/**
 开始执行键盘改变后的对应的视图变化
 
 */

#pragma mark --beginMoveUpAnimation
- (void)beginMoveUpAnimation:(CGFloat)height
{
[UIView animateWithDuration:0.3 animations:^{
    [_dialogBoxView setFrame:CGRectMake(0, self.view.height - (height +40), _dialogBoxView.width, _dialogBoxView.height)];
}];
    
    [_tableView layoutIfNeeded];
    
    if ([_conversation loadAllMessages].count > 1) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_conversation.loadAllMessages.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    }

}

#pragma mark --tableview  datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return _conversation.loadAllMessages.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:ID];
    }
    
    EMMessage *message = _conversation.loadAllMessages[indexPath.row];
    EMTextMessageBody *body = [message.messageBodies lastObject];
    
    
    /**
     判断发消息的人是否是当前聊天的人,左边的是对面发送来的,右边是自己发的
     
     */
    
    if ([message.to isEqualToString:_name]) {
        cell.detailTextLabel.text = body.text;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.textLabel.text = @"";
        cell.textLabel.textColor = [UIColor blueColor];
    } else {
        cell.detailTextLabel.text = @"";
        cell.textLabel.text = body.text;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.textLabel.textColor = [UIColor blueColor];
    }
    
    return cell;
    
}


@end
