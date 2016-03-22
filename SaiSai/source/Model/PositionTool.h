//
//  PositionTool.h
//  KuaiDi
//
//  Created by weige on 15/4/26.
//  Copyright (c) 2015年 gexinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol PositionToolDelegate <NSObject>

@optional

/**
 *  通知位置改变
 *
 *  @since 2015-04-26
 */
- (void)noticePositionChanged;

@end

@interface PositionTool : NSObject<CLLocationManagerDelegate>{
    CLLocationManager *_locationManager;
    NSMutableArray    *_delegatesArr;   //代理数组
}

@property (nonatomic, assign) CLLocationDegrees  latitude;
@property (nonatomic, assign) CLLocationDegrees  longitude;
@property (nonatomic, retain) NSString  *positionName;
@property (nonatomic, retain) NSString  *province;
@property (nonatomic, retain) NSString  *city;
@property (nonatomic, retain) NSString  *area;

/**
 *  添加回调代理
 *
 *  @param delegate 回调代理
 *
 *  @since 2015-04-26
 */
- (void)addDelegate:(id)delegate;

/**
 *  移除回调代理
 *
 *  @param delegate 回调代理
 *
 *  @since 2015-04-26
 */
- (void)removeDelegate:(id)delegate;

/**
 *  获取位置中心
 *
 *  @return 位置中心
 *
 *  @since 2015-04-26
 */
- (CLLocationCoordinate2D)getCenter;

/**
 *  更新位置
 *
 *  @since 2015-04-27
 */
- (void)updataLocation;

#pragma mark
#pragma mark ====== 单例初始化 ======
/**
 *  单例初始化
 *
 *  @return 用户信息单例
 *
 *  @since 2015-03-25
 */
+ (PositionTool *)shareInfo;

/**
 *  释放用户信息单例
 *
 *  @since 2015-03-25
 */
+ (void)freeInfo;

@end
