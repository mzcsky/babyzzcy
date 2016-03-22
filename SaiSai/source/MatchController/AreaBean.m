//
//  AreaBean.m
//  SaiSai
//
//  Created by weige on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "AreaBean.h"

@implementation AreaBean

+ (AreaBean *)analyseData:(NSDictionary *)dict{
    AreaBean *bean = [[AreaBean alloc] init];
    
    bean.mId = [[NetDataCommon stringFromDic:dict forKey:@"id"] integerValue];
    bean.area_name = [NetDataCommon stringFromDic:dict forKey:@"area_name"];
    
    return bean;
}

@end
