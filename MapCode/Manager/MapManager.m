//
//  MapManager.m
//  Driver
//
//  Created by caesar on 2020/1/17.
//  Copyright © 2020 caesar. All rights reserved.
//

#import "MapManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kRootViewController kAppDelegate.window.rootViewController

@implementation MapManager

- (void)mapArrayInitWithLatitude:(double)latitude andLongitude:(double)longitude andDestinationName:(NSString *)destinationName{
    NSMutableArray *mapArr = [NSMutableArray arrayWithCapacity:0];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        [mapArr addObject:@"百度地图"];
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        [mapArr addObject:@"高德地图"];
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]){
        [mapArr addObject:@"腾讯地图"];
    }
    
    [mapArr addObject:@"Apple地图"];
    if (mapArr.count == 1) {
        [self jumpToMapWith:mapArr[0] andLatitude:latitude andLongitude:longitude andDestinationName:destinationName];
    }else if(mapArr.count > 0){
        UIAlertController *mapAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *mapName in mapArr) {
            UIAlertAction *Action = [UIAlertAction actionWithTitle:mapName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self jumpToMapWith:action.title andLatitude:latitude andLongitude:longitude andDestinationName:destinationName];
            }];
            [mapAlert addAction:Action];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [mapAlert addAction:cancelAction];
        
        [kRootViewController presentViewController:mapAlert animated:YES completion:nil];
        
    }else{
        [self jumpToMapWith:@"Apple地图" andLatitude:latitude andLongitude:longitude andDestinationName:destinationName];
    }
}

- (void)jumpToMapWith:(NSString*)mapName andLatitude:(double)latitude andLongitude:(double)longitude andDestinationName:(NSString *)destinationName{
    if ([mapName isEqualToString:@"Apple地图"]) {
        [self appleMapWithLatitude:latitude longitude:longitude destinationName:destinationName];
    }else if ([mapName isEqualToString:@"百度地图"]){
        [self baiDuMapWithLatitude:latitude longitude:longitude destinationName:destinationName];
    }else if ([mapName isEqualToString:@"高德地图"]){
        [self iosMapWithLatitude:latitude longitude:longitude destinationName:destinationName];
    }else if ([mapName isEqualToString:@"腾讯地图"]){
        [self qqMapWithLatitude:latitude longitude:longitude destinationName:destinationName];
    }
}

/**
 调起百度地图
 
 @param lat lat
 @param log log
 http://lbsyun.baidu.com/index.php?title=uri/api/ios  2.2.3 路线规划
 */
- (void)baiDuMapWithLatitude:(double)lat longitude:(double)log destinationName:(NSString *)destinationName{
    
    CLLocationCoordinate2D gcj02Coord = [self BD09FromGCJ02:CLLocationCoordinate2DMake(lat, log)];
    float latitude = gcj02Coord.latitude;
    float longitude = gcj02Coord.longitude;
    //mode=driving(驾车), transit(公交) ...
    NSString *urlString = [[NSString alloc]init];
    if (_isLoadToUnload) {// 该判断是为了区分"当前位置"是否是装货地
        urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=name:%@|latlng:%f,%f&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.loadAddress, self.loadLat.doubleValue, self.loadLng.doubleValue, latitude, longitude];
    } else {
        urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",latitude, longitude];
    }
    if (latitude != 0 && longitude != 0) {
        urlString = [NSString stringWithFormat:@"%@&destination=latlng:%f,%f|name:%@", urlString, latitude, longitude, destinationName];
    }else{
        urlString = [NSString stringWithFormat:@"%@&destination=%@|name:%@", urlString, @"绿地中心", destinationName];
    }
     urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

/**
 调起高德地图
 
 @param latitude latitude
 @param longitude longitude
 https://lbs.amap.com/api/amap-mobile/guide/ios/route 路线规划
 */
- (void)iosMapWithLatitude:(double)latitude longitude:(double)longitude destinationName:(NSString *)destinationName{
    NSString *urlString = [[NSString alloc]init];
    if (_isLoadToUnload) {// 该判断是为了区分"当前位置"是否是装货地
        urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&backScheme=%@&sid=&slat=%f&slon=%f&sname=%@&dev=0&&style=2", @"HDDDriver", @"HDDDriver",self.loadLat.doubleValue, self.loadLng.doubleValue, self.loadAddress];
    } else {
       urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&backScheme=%@&dev=0&&style=2", @"HDDDriver", @"HDDDriver"];
    }
    if (latitude != 0 && longitude != 0) {
        urlString = [NSString stringWithFormat:@"%@&dlat=%f&dlon=%f&dname=%@", urlString, latitude, longitude ,destinationName];
    }else{
        urlString = [NSString stringWithFormat:@"%@&dname=%@",urlString, destinationName];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}


/**
 苹果地图
 
 @param latitude latitude
 @param longitude longitude
 */
- (void)appleMapWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude destinationName:(NSString *)destinationName{
    CLLocationCoordinate2D desCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    currentLocation.name = @"我的位置";
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
    toLocation.name = [NSString stringWithFormat:@"%@", destinationName];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

/**
 腾讯地图
  * latitude 纬度
  * longitude 经度
 https://lbs.qq.com/uri_v1/guide-mobile-navAndRoute.html 导航和路线规划
 */
- (void)qqMapWithLatitude:(double)lat longitude:(double)lng destinationName:(NSString *)destinationName{
    
    CLLocationCoordinate2D gcj02Coord = [self BD09FromGCJ02:CLLocationCoordinate2DMake(lat, lng)];
    float latitude = gcj02Coord.latitude;
    float longitude = gcj02Coord.longitude;
    NSString *urlString = [[NSString alloc]init];
    if (_isLoadToUnload) {// 该判断是为了区分"当前位置"是否是装货地
        urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&from=%@&referer=jikexiu",self.loadLat.doubleValue, self.loadLng.doubleValue,self.loadAddress];
    } else {
        urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&from=我的位置&referer=jikexiu",latitude, longitude];
    }
    urlString = [NSString stringWithFormat:@"%@&tocoord=%f,%f&to=%@",urlString, latitude, longitude, destinationName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

/**
 高德转百度
 
 @param coord CLLocationCoordinate2D
 @return CLLocationCoordinate2D
 */
- (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coord{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coord.longitude, y = coord.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}


@end
