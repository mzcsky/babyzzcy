//
//  PositionTool.m
//  KuaiDi
//
//  Created by weige on 15/4/26.
//  Copyright (c) 2015年 gexinwei. All rights reserved.
//

#import "PositionTool.h"

static PositionTool    *_positionTool;

@implementation PositionTool

#pragma mark
#pragma mark ====== 单例初始化 ======
/**
 *  单例初始化
 *
 *  @return 用户信息单例
 *
 *  @since 2015-03-25
 */
+ (PositionTool *)shareInfo{
    @synchronized(self){
        if (_positionTool == nil) {
            _positionTool = [[PositionTool alloc] init];
            _positionTool.positionName = @"暂无";
        }
    }
    return _positionTool;
}

/**
 *  释放用户信息单例
 *
 *  @since 2015-03-25
 */
+ (void)freeInfo{
    if (_positionTool) {
        [_positionTool clear];
        _positionTool = nil;
    }
}

- (id)init{
    self = [super init];
    if (self) {
        _delegatesArr = [[NSMutableArray alloc] init];
        [self getLocation];
    }
    return self;
}

- (void)clear{
    
}

/**
 *  添加回调代理
 *
 *  @param delegate 回调代理
 *
 *  @since 2015-04-26
 */
- (void)addDelegate:(id<PositionToolDelegate>)delegate{
    [_delegatesArr addObject:delegate];
    NSLog(@"代理数组1%@",_delegatesArr);
}

/**
 *  移除回调代理
 *
 *  @param delegate 回调代理
 *
 *  @since 2015-04-26
 */
- (void)removeDelegate:(id)delegate{
    [_delegatesArr removeObject:delegate];
}

/**
 *  获取位置中心
 *
 *  @return 位置中心
 *
 *  @since 2015-04-26
 */
- (CLLocationCoordinate2D)getCenter{
    return [_locationManager location].coordinate;
}

/**
 *  更新位置
 *
 *  @since 2015-04-27
 */
- (void)updataLocation{
    [_locationManager startUpdatingLocation];
}

#pragma mark
#pragma mark ====== 获取位置信息 ======
-(void)getLocation {
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        
        _locationManager.distanceFilter = 500; //控制定位服务更新频率。单位是“米”
        
        [_locationManager startUpdatingLocation];
        
        //在ios 8.0下要授权
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [_locationManager requestAlwaysAuthorization];  //调用了这句,就会弹出允许框了.
        }
    }
}

#pragma mark
#pragma mark ====== CLLocationManagerDelegate ======
// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
    
}
// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%lu", (unsigned long)[locations count]);
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    NSLog(@"新的经度：%f,新的纬度：%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
                           
                           self.positionName = place.name;
                           NSLog(@"name,%@",place.name);
                           self.province = place.administrativeArea;
                           self.city = place.locality;
                           self.area = place.subLocality;
//                            位置名
//                                                      NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//                                                      NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//                                                      NSLog(@"locality,%@",place.locality);               // 市
//                                                      NSLog(@"subLocality,%@",place.subLocality);         // 区
//                                                      NSLog(@"country,%@",place.country);                 // 国家
                       }
                       NSLog(@"代理数组3%@",_delegatesArr);
                       for (id<PositionToolDelegate> delegate in _delegatesArr) {
                           if (delegate && [delegate respondsToSelector:@selector(noticePositionChanged)]) {
                               [delegate noticePositionChanged];
                           }
                       }
                       
                   }];
    NSLog(@"代理数组2%@",_delegatesArr);
    for (id<PositionToolDelegate> delegate in _delegatesArr) {
        if (delegate && [delegate respondsToSelector:@selector(noticePositionChanged)]) {
            [delegate noticePositionChanged];
        }
    }
    
//    NSString *position = [NSString stringWithFormat:@"%f-%f",self.longitude,self.latitude];
//    NSString *uid = [NSString stringWithFormat:@"%d",[[UserModel shareInfo] uid]];
//    NSString *role = [[UserModel shareInfo] roleType]==0? @"2":@"1";
//    NSDictionary *pram = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"userid", position, @"position", role, @"user_type", nil];
//    [SVHTTPRequest GET:POSITION_UPDATE parameters:pram completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        if (response && error== nil) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
//            NSLog(@"更新位置结果：%@",dict);
//        }
//    }];
}

// 6.0 调用此函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"aaa%@", @"ok");
}

@end
