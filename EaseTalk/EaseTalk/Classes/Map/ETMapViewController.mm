//
//  ETMapViewController.m
//  EaseTalk
//
//  Created by einsphy on 16/2/19.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "ETMapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

//#import "BMKMapManager.h"
//#import "BMKMapView.h"
//#import "BMKLocationService.h"
//#import "BMKPointAnnotation.h"
//#import "BMKGeocodeSearch.h"

#import "Masonry.h"
@interface ETMapViewController ()<BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,UITextFieldDelegate>
{

    //管理者
    BMKMapManager *_manager;
    
    
    //百度地图
    BMKMapView *_mapView;
    
    
    //定位服务对象属性（定位）
    BMKLocationService *_locationService;
    
    
    //地理编码
    BMKGeoCodeSearch *_geoCodeSearch;
    
    
    //路线
    BMKRouteSearch *_routeSearch;
    
    
    //开始节点
    BMKPlanNode *_startNode;
    
    
    
    //结束节点
    BMKPlanNode *_endNode;
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
    
    _geoCodeSearch.delegate = nil;
    
    _routeSearch.delegate = nil;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
/**增加地图*/
    
    _manager = [[BMKMapManager alloc]init];
    [_manager start:@"sz2zQujVUlpGiEhavzmeG1up" generalDelegate:self];

    
    

    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    _locationService.distanceFilter = 10;
    
    
    //地理编码
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    
    
    //路线规划搜索
    _routeSearch = [[BMKRouteSearch alloc]init];
    _routeSearch.delegate = self;
    
    [self addNavigationItems];
    [self addSubviews];
}

-(void)addNavigationItems
{

    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"开始定位" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = left;
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"取消定位" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = right;

}

-(void)addSubviews
{
    /**
     起始城市
     
     */
    _startCity = [[UITextField alloc]init];
    
    _startCity.textAlignment  = NSTextAlignmentCenter;
    
    _startCity.backgroundColor = HXColor(255, 255, 255);
    
    _startCity.delegate = self;
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
        make.size.mas_equalTo(_startCity);
        make.top.mas_equalTo(_startCity);
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
        
        make.size.mas_equalTo(_startCity);
        make.left.mas_equalTo(_startCity);
        
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
    
        make.top.mas_equalTo(_startAdress);
        make.size.mas_equalTo(_startAdress);
        
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
    
    //地图
    
    _mapView = [[BMKMapView alloc]init];
    
    _mapView.delegate = self;

    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_startAdress.mas_bottom).offset(10);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(_startAdress.frame) - 10);
    }];

}

- (void)leftClick
{

    //1.开启定位服务
    [_locationService startUserLocationService];
    
    //2.在地图上显示用户的位置
    _mapView.showsUserLocation = YES;
    HXLog(@"left");

}
/**
 关闭定位服务
 
 */
-(void)rightClick
{
    //1.关闭定位
    [_locationService stopUserLocationService];

    //2.设置地图不显示用户的位置
    _mapView.showsUserLocation = NO;
    
    //3.删除初入地图的标注
    [_mapView removeAnnotation:[_mapView.annotations lastObject]];
}
/**
 规划路线
 
 */
- (void)searchBtnClick:(UIButton *)sender
{
    //完成地理编码
    
    //1.创建地理编码选项对象
    BMKGeoCodeSearchOption *geoCodeSeachOption = [[BMKGeoCodeSearchOption alloc]init];
    
    
    //2.给进行地理编码的位置赋值
    geoCodeSeachOption.city = _startCity.text;
    geoCodeSeachOption.address = _startAdress.text;
    
    //3.执行编码
    [_geoCodeSearch geoCode:geoCodeSeachOption];

}

#pragma mark --BMKLocation代理方法

/**
 开始定位
 
 */
-(void)willStartLocatingUser
{
    HXLog(@"开始定位");

}

/**
 定位失败
 
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{

    HXLog(@"定位失败%@",error);

}


/**
 定位成功,再次定位的方法
 
 */
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    HXLog(@"定位成功");
    //1.完成逆地理编码
    BMKReverseGeoCodeOption *reverseOption = [[BMKReverseGeoCodeOption alloc]init];
    
    
    //2.给逆地理编码选项赋值
    reverseOption.reverseGeoPoint = userLocation.location.coordinate;
    
    
    //3.执行逆地理编码操作
    [_geoCodeSearch reverseGeoCode:reverseOption];
    
    
    
   

}

#pragma mark geoCodeSearch代理方法（逆地理编码）
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{


    //定义大头针标注
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
    
    //设置标注的位置坐标
    annotation.coordinate = result.location;
    
    //
    annotation.title = result.address;
    
    //添加到地图里
    [_mapView addAnnotation:annotation];
    
    //地图显示到该区域
    [_mapView setCenterCoordinate:result.location animated:YES];
    
}


#pragma mark --BMKGeoCodeSearch代理方法(地理编码)
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

//

    if ([result.address isEqualToString:_startAdress.text]) {
        
        //说明当前编码的对象是开始节点
        _startNode = [[BMKPlanNode alloc]init];
        
        
        //给开始节点赋值
        _startNode.pt = result.location;
    
    
        //发起对目标节点的地理编码
        //1.创建正向地理编码选项
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        
        geoCodeSearchOption.city = _endCity.text;
        geoCodeSearchOption.address = _endAddress.text;
        
        //执行地理编码
        [_geoCodeSearch geoCode:geoCodeSearchOption];
        _endNode = nil;
    }else
    {
    
        _endNode = [[BMKPlanNode alloc]init];
        _endNode.pt = result.location;
        
        if (_startNode != nil && _endNode != nil) {
            //开始路线规划
            //1.创建路线规划
            BMKDrivingRoutePlanOption *drivingRoutOption = [[BMKDrivingRoutePlanOption alloc]init];
            //指定开始节点和目标节点
            drivingRoutOption.from = _startNode;
            drivingRoutOption.to = _endNode;
            
            [_routeSearch drivingSearch:drivingRoutOption];
        }
    
    
    }
    
}

//获取到自驾路线的回调

-(void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    
    //删除掉原来的覆盖物
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    //删除overlays(删除掉原来的轨迹)
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
        //选取获取到所有路线中的一条
        BMKDrivingRouteLine *routLine = [result.routes objectAtIndex:0];
        
        
        //计算路线方案中路段的数目
        NSUInteger size = [routLine.steps count];
        
        
        //声明一个整形变量用来计算所有的轨迹点的总数
        int planPointCounts = 0;
        for (int i = 0; i < size; i++)
        {
            
            //获取路线中的路段
            BMKDrivingStep *step = routLine.steps[i];
            if (i == 0) {
                //地图显示经纬区域
                
                [_mapView setRegion:(BMKCoordinateRegionMake(step.entrace.location,BMKCoordinateSpanMake(0.001,0.001))) animated:YES];
            }
            
            //累计轨迹点
            planPointCounts += step.pointsCount;
        }
        
        
        //声明一个结构体数组，用来保存所有的轨迹点（每一个轨迹点都是一个结构体）
        //轨迹点结构体名字为BMKMapPoint

        BMKMapPoint *tempPoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        
        for (int j = 0; j < size; j++) {
            BMKDrivingStep *drivingStep = [routLine.steps objectAtIndex:j];
            
            
            int k = 0;
            for (k = 0; k < drivingStep.pointsCount; k++) {
                //获取每个轨迹点的x，y放入数组中
                tempPoints[i].x = drivingStep.points[k].x;
                tempPoints[i].y = drivingStep.points[k].y;
                i++;
            }
        }
        
        //通过轨迹点构造BMKPolyline（折线）
        BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:tempPoints count:planPointCounts];
        
        //添加到mapview上
        //想要在地图上显示轨迹，只能先添加overlay对象(类比大头针标注)，添加好之后，地图就会根据你设置的overlay显示出轨迹
        [_mapView addOverlay:polyLine];
        
        
    }

}

#pragma mark --mapview代理方法
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{


    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polyLineView = [[BMKPolylineView alloc]initWithOverlay:overlay];
        
        //设置该线条的填充颜色
        polyLineView.fillColor = [UIColor redColor];
        
        //设置线条颜色
        polyLineView.strokeColor = [UIColor blueColor];
        
        //设置折线宽度
        polyLineView.lineWidth = 3.0;
        
        return polyLineView;
        
        
        
    }
    
    
    return nil;


}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [self.view resignFirstResponder];
    
    
    return YES;

}

@end
