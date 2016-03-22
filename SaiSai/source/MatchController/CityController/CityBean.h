//
//  CityBean.h
//  SaiSai
//
//  Created by weige on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityBean : NSObject

@property (nonatomic, assign) NSInteger     mId;

@property (nonatomic, retain) NSString      *city_name;

@property (nonatomic, retain) NSString      *simple;

+ (CityBean *)analyseData:(NSDictionary *)dict;

@end
