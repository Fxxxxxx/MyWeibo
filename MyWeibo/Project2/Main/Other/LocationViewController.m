//
//  LocationViewController.m
//  Project2
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "Common.h"



@interface LocationViewController ()<CLLocationManagerDelegate,SinaWeiboRequestDelegate>
@property (nonatomic,strong) CLLocationManager * loactionManager;
@property (nonatomic,strong) NSArray * locationArr;


@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loactionManager = [[CLLocationManager alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [_loactionManager requestWhenInUseAuthorization];
    }
    
    _loactionManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _loactionManager.delegate = self;
    [_loactionManager startUpdatingLocation];
}


#pragma CllocationDelegate-----
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"定位成功");
    
    [manager stopUpdatingLocation];
    CLLocation * location = locations.lastObject;
    double lat = location.coordinate.latitude;
    double lon = location.coordinate.longitude;
    NSString * latStr = [NSString stringWithFormat:@"%lf",lat];
    NSString * longStr  = [NSString stringWithFormat:@"%lf",lon];
    
    AppDelegate * delegate =  [UIApplication sharedApplication].delegate;
    [delegate.sinaweibo requestWithURL:@"place/nearby/pois.json" params:[@{@"lat": latStr,@"long":longStr}mutableCopy] httpMethod:@"GET" delegate:self];
    
    
}

#pragma sinarequest----
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result;{
    NSLog(@"解析地址");
    NSArray *posArr= result[@"pois"];
    _locationArr= posArr;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _locationArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationcell" forIndexPath:indexPath];
    
    NSDictionary *locationDic = [_locationArr objectAtIndex:indexPath.row];
    NSString *text = locationDic[@"address"];
    
    if ([text isKindOfClass:[NSString class]]) {
        cell.textLabel.text =text;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _location([tableView cellForRowAtIndexPath:indexPath].textLabel.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
