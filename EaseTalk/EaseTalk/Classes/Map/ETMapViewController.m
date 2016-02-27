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
@interface ETMapViewController ()<BMKGeneralDelegate,BMKMapViewDelegate>
{

    BMKMapManager *_manager;
    BMKMapView *_mapView;
    
}

@end

@implementation ETMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
/**增加地图*/
    
    _manager = [[BMKMapManager alloc]init];
    [_manager start:@"sz2zQujVUlpGiEhavzmeG1up" generalDelegate:self];
    _mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _mapView ;
    

}

-(void)viewWillAppear:(BOOL)animated
{

    [_mapView viewWillAppear];
    _mapView.delegate = self;

}

-(void)viewWillDisappear:(BOOL)animated
{

    [_mapView viewWillDisappear];
    _mapView.delegate = nil;

}

@end
