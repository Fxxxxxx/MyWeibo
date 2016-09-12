//
//  MapViewController.m
//  Project2
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DataService.h"
#import "WeiboAnnotation.h"
#import "YYModel.h"
@interface MapViewController ()<MKMapViewDelegate>
{
    CLLocationManager * _location;
}
@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _location = [[CLLocationManager alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [_location requestWhenInUseAuthorization];
    }
    _MapView.delegate = self;
    _MapView.showsUserLocation = YES;;
    
    
}

#pragma mark MapDelegate------
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocationCoordinate2D coordinate = userLocation.coordinate;
    //跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    
    [mapView setRegion:MKCoordinateRegionMake(coordinate, span)];
    
    
    NSString * lat = [NSString stringWithFormat:@"%lf", coordinate.latitude];
    NSString * lon = [NSString stringWithFormat:@"%lf", coordinate.longitude];
    
    [DataService requestWithUrl:@"place/nearby_timeline.json" mathod:@"GET" params:@{@"lat" : lat, @"long" : lon} data:nil success:^(id result) {
        
        NSArray * statuses = result[@"statuses"];
        for (NSDictionary * dic in statuses) {
            WeiboModel * model = [WeiboModel yy_modelWithDictionary:dic];
            WeiboAnnotation * annotation = [[WeiboAnnotation alloc] init];
            annotation.model = model;
            [mapView addAnnotation:annotation];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}


@end
