//
//  ProfileViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/2/19.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileItem.h"
#import "Profile1TableViewCell.h"
@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *scollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)UIScrollView *lunboScrollView;
@property (nonatomic, strong)UITableView *profileTableview1;
@property (nonatomic, strong)UITableView *profileTableview2;
@property (nonatomic, strong)UITableView *profileTableview3;

@property (nonatomic, strong)NSMutableArray *dataArray1;
@property (nonatomic, strong)NSMutableArray *dataArray2;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initImageUrl];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    /**
     大背景
     
     */
    self.scollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.scollView.backgroundColor = [UIColor yellowColor];
    
    self.scollView.contentSize = CGSizeMake(self.view.width, NSIntegerMax);
    self.scollView.bounces = NO;
    self.scollView.delegate = self;
    [self.view addSubview:self.scollView];
    
    
    
    
    
    
    /**
     轮播图
     
     */
    __weak typeof(self)weakSelf = self;
    
    self.lunboScrollView = [[UIScrollView alloc]init];
    self.lunboScrollView.contentSize = CGSizeMake(self.view.width * 3, self.view.height / 3);
    self.lunboScrollView.showsHorizontalScrollIndicator = YES;
    self.lunboScrollView.showsVerticalScrollIndicator = YES;
    self.lunboScrollView.pagingEnabled = YES;
    self.lunboScrollView.delegate = self;
    [self.scollView addSubview:_lunboScrollView];
    [_lunboScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(weakSelf.view.width);
        make.height.mas_equalTo(weakSelf.view.height / 3);
    }];
    
    _lunboScrollView.bounces = NO;
    
    
    
    
    
    /**
     轮播图的图片
     
     */
    CGFloat imageW = self.lunboScrollView.width;
    CGFloat imageH = self.lunboScrollView.height;
    CGFloat imageY = 0;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        CGFloat imageX = i * imageW;
        
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self.lunboScrollView addSubview:imageView];
    }
    
    
    
    /**
     轮播图的pagecontrol
     
     */
    
    self.pageControl = [[UIPageControl alloc]init];
    HXLog(@"----------%f",CGRectGetMaxY(self.lunboScrollView.frame));
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.backgroundColor = [UIColor grayColor];
    self.pageControl.alpha = 0.5;
    [self.scollView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(weakSelf.lunboScrollView.mas_bottom).with.offset(-40);
        make.width.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(20);
        
    }];
    
    
    //第一个tabview
    _profileTableview1 = [[UITableView alloc]init];
    _profileTableview1.bounces = NO;
    _profileTableview1.backgroundColor = [UIColor greenColor];
    [self.scollView addSubview:_profileTableview1];
    [_profileTableview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lunboScrollView.mas_bottom);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.width.mas_equalTo(weakSelf.view.width / 3);
        make.height.mas_equalTo(weakSelf.view.height / 2);
        
    }];
    _profileTableview1.delegate = self;
    _profileTableview1.dataSource = self;
    _profileTableview1.showsVerticalScrollIndicator = NO;
    _profileTableview1.showsHorizontalScrollIndicator = NO;
    [self.profileTableview1 registerClass:[Profile1TableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    
    
    
    //第二个tabview
    _profileTableview2 = [[UITableView alloc]init];
    _profileTableview2.backgroundColor = [UIColor greenColor];
    [self.scollView addSubview:_profileTableview2];
    self.profileTableview1.userInteractionEnabled = NO;
    [_profileTableview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_profileTableview1.mas_top);
        make.left.mas_equalTo(weakSelf.view.width / 3);
        make.width.mas_equalTo(weakSelf.view.width / 3);
        make.height.mas_equalTo(weakSelf.view.height / 2);
        
    }];
    _profileTableview2.delegate = self;
    _profileTableview2.dataSource = self;
    _profileTableview2.showsVerticalScrollIndicator = NO;
    _profileTableview2.showsHorizontalScrollIndicator = NO;
    
    
    
    
    
    //第三个tabview
    _profileTableview3 = [[UITableView alloc]init];
    _profileTableview3.backgroundColor = [UIColor greenColor];
    [self.scollView addSubview:_profileTableview3];
    [_profileTableview3 mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(weakSelf.profileTableview1.mas_top);
        make.left.mas_equalTo(weakSelf.view.width / 3 * 2);
        make.width.mas_equalTo(weakSelf.view.width / 3);
        make.height.mas_equalTo(weakSelf.view.height / 2);
        
    }];
    _profileTableview3.delegate = self;
    _profileTableview3.dataSource = self;
    _profileTableview3.showsVerticalScrollIndicator = NO;
    _profileTableview3.showsHorizontalScrollIndicator = NO;
    

}

- (void)initImageUrl
{

    NSArray *imageArray = @[
                            @"http://g.hiphotos.baidu.com/image/w%3D310/sign=6f9ce22079ec54e741ec1c1f89399bfd/9d82d158ccbf6c81cea943f6be3eb13533fa4015.jpg",
                            @"http://b.hiphotos.baidu.com/image/pic/item/4bed2e738bd4b31cc6476eb985d6277f9e2ff8bd.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/94cad1c8a786c9174d18e030cb3d70cf3bc7579b.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=79bc1b1a950a304e5222a6fbe1c9a7c3/d1160924ab18972b50a46fd4e4cd7b899e510a15.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=05e2c867272dd42a5f0907aa333a5b2f/7dd98d1001e93901f3f7103079ec54e737d196c3.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=3914596cf1deb48ffb69a7dfc01e3aef/d0c8a786c9177f3ea3e73f0072cf3bc79e3d56e8.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=8cc67b8cc91349547e1eee65664e92dd/4610b912c8fcc3ce11e40a3e9045d688d43f2093.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=93e1c429952bd40742c7d5fc4b889e9c/3812b31bb051f8191cdd594bd8b44aed2e73e733.jpg",
                            @"http://b.hiphotos.baidu.com/image/pic/item/4bed2e738bd4b31cc6476eb985d6277f9e2ff8bd.jpg",
                            @"http://c.hiphotos.baidu.com/image/pic/item/94cad1c8a786c9174d18e030cb3d70cf3bc7579b.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=3914596cf1deb48ffb69a7dfc01e3aef/d0c8a786c9177f3ea3e73f0072cf3bc79e3d56e8.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=93e1c429952bd40742c7d5fc4b889e9c/3812b31bb051f8191cdd594bd8b44aed2e73e733.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=d4507def9d3df8dca63d8990fd1072bf/d833c895d143ad4b758c35d880025aafa40f0603.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=702acce2552c11dfded1b92253266255/d62a6059252dd42a3ac70aaa013b5bb5c8eab8e0.jpg",
                            @"http://h.hiphotos.baidu.com/image/w%3D310/sign=75ff59cd19d5ad6eaaf962ebb1ca39a3/b64543a98226cffcb9f3ddbbbb014a90f703eada.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=11386163f1deb48ffb69a7dfc01e3aef/d0c8a786c9177f3e8bcb070f72cf3bc79f3d5631.jpg",
                            @"http://f.hiphotos.baidu.com/image/w%3D310/sign=8ed508bbd358ccbf1bbcb33b29d8bcd4/8694a4c27d1ed21b33ff8fecaf6eddc451da3f80.jpg",
                            @"http://b.hiphotos.baidu.com/image/w%3D310/sign=ad40ca82c9ef76093c0b9f9e1edca301/5d6034a85edf8db16aa7b27b0b23dd54564e7420.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=79bc1b1a950a304e5222a6fbe1c9a7c3/d1160924ab18972b50a46fd4e4cd7b899e510a15.jpg",
                            @"http://c.hiphotos.baidu.com/image/w%3D310/sign=05e2c867272dd42a5f0907aa333a5b2f/7dd98d1001e93901f3f7103079ec54e737d196c3.jpg",
                            @"http://g.hiphotos.baidu.com/image/w%3D310/sign=6f9ce22079ec54e741ec1c1f89399bfd/9d82d158ccbf6c81cea943f6be3eb13533fa4015.jpg",
                            @"http://e.hiphotos.baidu.com/image/w%3D310/sign=79bc1b1a950a304e5222a6fbe1c9a7c3/d1160924ab18972b50a46fd4e4cd7b899e510a15.jpg"
                            ];
    
    self.dataArray1 = [NSMutableArray array];
    
    for (NSString *items in imageArray) {
        ProfileItem *item = [[ProfileItem alloc]init];
        item.imageUrl = items;
        
        
        [self.dataArray1 addObject:item];
        
    }
    

}

- (void)nextImage
{

    int page = (int)self.pageControl.currentPage;
    
    if (page == 2) {
        page = 0;
    } else {
        page++;
    }
    
    CGFloat x = page * self.lunboScrollView.width;
    self.lunboScrollView.contentOffset = CGPointMake(x, 0);

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _profileTableview1) {
        
        return self.dataArray1.count;
        
        
    } else if(tableView == _profileTableview2 ) {
        
        
        return 50;
        
        
    }else
    {
    
        return 70;
    
    }

    return 30;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (tableView == _profileTableview1) {
        static NSString *ID1 = @"cell";
        ProfileItem *item = self.dataArray1[indexPath.row];
        Profile1TableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell1 == nil) {
            cell1 = [[Profile1TableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
        }
        
        cell1.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        [cell1.dogImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:nil];
        
        return cell1;
    }else if (tableView == _profileTableview2)
    {
    
        static NSString *ID2 = @"cell";
        
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (cell2 == nil) {
            cell2= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID2];
        }
        
        cell2.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        return cell2;
    
    }else
    {
    
        static NSString *ID1 = @"cell";
        
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell3 == nil) {
            cell3 = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID1];
        }
        
        cell3.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        
        
        return cell3;
    
    }
    
    return nil;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView == _profileTableview1) {
        [_profileTableview2 setContentOffset:_profileTableview2.contentOffset];
        [_profileTableview3 setContentOffset:_profileTableview1.contentOffset];
    } else if(scrollView == _profileTableview2) {
        [_profileTableview1 setContentOffset:_profileTableview2.contentOffset];
        [_profileTableview3 setContentOffset:_profileTableview2.contentOffset];
    }else if(scrollView == _profileTableview3)
    {
    
        [_profileTableview2 setContentOffset:_profileTableview3.contentOffset];
        [_profileTableview1 setContentOffset:_profileTableview3.contentOffset];
    
    }else if (scrollView == _lunboScrollView)
    {
    
    
        CGFloat scrollViewW = self.lunboScrollView.width;
        CGFloat x = self.lunboScrollView.contentOffset.x;
        
        int page = (x + scrollViewW / 2) / scrollViewW;
        
        self.pageControl.currentPage = page;
    
    
    }
    

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    [self removeTimer];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    [self addTimer];

}


- (void)addTimer
{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];

}

- (void)removeTimer
{


    [self.timer invalidate];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (tableView == _profileTableview1) {
        
        
        
        return 100;
    } else if(tableView == _profileTableview2) {
    
        return 40;
    }else if(tableView == _profileTableview3){
    
        return 70;
    
    
    }
    
    
    return 50;


}
@end
