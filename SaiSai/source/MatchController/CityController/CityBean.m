//
//  CityBean.m
//  SaiSai
//
//  Created by weige on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "CityBean.h"

@implementation CityBean

+ (CityBean *)analyseData:(NSDictionary *)dict{
    CityBean *bean = [[CityBean alloc] init];
    
    bean.mId = [[NetDataCommon stringFromDic:dict forKey:@"id"] integerValue];
    bean.city_name = [NetDataCommon stringFromDic:dict forKey:@"city_name"];
    bean.simple = [NetDataCommon stringFromDic:dict forKey:@"simple"];
    
    return bean;
}

@end
