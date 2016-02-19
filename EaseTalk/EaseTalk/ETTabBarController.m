//
//  ETTabBarController.m
//  EaseTalk
//
//  Created by einsphy on 16/2/19.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "ETTabBarController.h"
#import "EaseTalkViewController.h"
#import "ETNavigationController.h"
#import "ETMapViewController.h"
#import "ETPayViewController.h"
#import "ProfileViewController.h"
@interface ETTabBarController ()

@end

@implementation ETTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //环信
    EaseTalkViewController *easeVC = [[EaseTalkViewController alloc]init];
    [self addChildViewController:easeVC withTitle:@"环信" image:@"familybook@2x" selectedImage:@"familybook_highlight@2x"];
    
    //支付
    ETPayViewController *pay = [[ETPayViewController alloc]init];
    [self addChildViewController:pay withTitle:@"支付" image:@"myfamily@2x" selectedImage:@"myfamily_highlight@2x"];
    
    //地图
    ETMapViewController *map = [[ETMapViewController alloc]init];
    [self addChildViewController:map withTitle:@"地图" image:@"neighbour@2x" selectedImage:@"neighbour_highlight@2x"];
    
    //我
    ProfileViewController *profile = [[ProfileViewController alloc]init];
    [self addChildViewController:profile withTitle:@"我" image:@"setting@2x" selectedImage:@"setting_highlight@2x"];
    

}


- (void)addChildViewController:(UIViewController *)childVC withTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVC.title = title;
    ETNavigationController *nav = [[ETNavigationController alloc]initWithRootViewController:childVC];
    
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    //为被选中的字体颜色
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = HXColor(110, 110, 110);
    [childVC.tabBarItem setTitleTextAttributes:attr forState:(UIControlStateNormal)];
    
    //选中的字体颜色
    NSMutableDictionary *selectedAttr = [NSMutableDictionary dictionary];
    selectedAttr[NSForegroundColorAttributeName] = HXColor(198, 0, 25);
    [childVC.tabBarItem setTitleTextAttributes:selectedAttr forState:(UIControlStateSelected)];
    
    [self addChildViewController:nav];

}


@end
