//
//  ETMapViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/2/19.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "ETMapViewController.h"
#import "BMKMapManager.h"
#import "BMKMapView.h"
#import "BMKLocationService.h"
#import "Masonry.h"
@interface ETMapViewController ()<BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
{

    BMKMapManager *_manager;
    BMKMapView *_mapView;
    //定位服务对象属性（定位）
    BMKLocationService *_locationService;
    
    /**
     起始城市
     
     */
    UITextField *_startCity;

    /**
     终点城市
     
     */
    UITextField *_endCity;
    
    
    /**
     起始地址
     
     */
    UITextField *_startAdress;
    
    /**
     终点地址
     
     */
    UITextField *_endAddress;
    /**
     搜索按钮
     
     */
    UIButton *_serachBtn;
    
}

@end

@implementation ETMapViewController


-(void)dealloc
{

    _mapView.delegate = nil;
    
    _locationService.delegate = nil;


}

- (void)viewDidLoad {
    [super viewDidLoad];
/**增加地图*/
    
    _manager = [[BMKMapManager alloc]init];
    [_manager start:@"sz2zQujVUlpGiEhavzmeG1up" generalDelegate:self];
    _mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.delegate = self;
    //self.view = _mapView ;
    

    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    [self addSubviews];
}

-(void)addSubviews
{
    /**
     起始城市
     
     */
    _startCity = [[UITextField alloc]init];
    
    _startCity.textAlignment  = NSTextAlignmentCenter;
    
    _startCity.backgroundColor = HXColor(255, 255, 255);
    
    _startCity.placeholder = @"开始城市";
    
    [self.view addSubview:_startCity];
    
    [_startCity rectMakeX:30 y:80 width:100 height:30];
    
    
    /**
     终点城市
     
     */
    
    _endCity = [[UITextField alloc]init];
    
    _endCity.textAlignment  = NSTextAlignmentCenter;
    
    _endCity.backgroundColor = HXColor(255, 255, 255);
    
    _endCity.placeholder = @"终点城市";
    
    [self.view addSubview:_endCity];
    
    [_endCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.mas_equalTo(_startCity);
        make.left.mas_equalTo(_startCity.mas_right).offset(20);
    }];
    
    /**
     起始地址
     
     */
    _startAdress = [[UITextField alloc]init];
    
    _startAdress.textAlignment  = NSTextAlignmentCenter;
    
    _startAdress.backgroundColor = HXColor(255, 255, 255);
    
    [self.view addSubview:_startAdress];
    
    _startAdress.placeholder = @"起始地址";
    
    [_startAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.and.left.mas_equalTo(_startCity);
        
        make.top.mas_equalTo(_startCity.mas_bottom).offset(30);
    
    }];
    
    /**
     终点地址
     
     */
    _endAddress = [[UITextField alloc]init];
    
    _endAddress.backgroundColor = HXColor(255, 255, 255);
    
    _endAddress.textAlignment  = NSTextAlignmentCenter;
    
    _endAddress.placeholder = @"终点地址";
    
    [self.view addSubview:_endAddress];
    
    [_endAddress mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.size.and.top.mas_equalTo(_startAdress);
        
        make.left.mas_equalTo(_startAdress.mas_right).offset(20);
        
    }];
    
    /**
     搜索按钮
     
     */
    
    _serachBtn = [[UIButton alloc]init];
    
    _serachBtn.backgroundColor = HXColor(255, 255, 0);
    
    [_serachBtn setTitle:@"搜索" forState:(UIControlStateNormal)];
    
    [_serachBtn setTintColor:HXColor(255, 255, 255)];
    
    [_serachBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:_serachBtn];
    
    [_serachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_endCity.mas_right).offset(10);
        make.top.mas_equalTo(_endCity.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    _mapView = [[BMKMapView alloc]init];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_startAdress.mas_bottom).offset(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height);
    }];

}


- (void)searchBtnClick:(UIButton *)sender
{

}

@end
