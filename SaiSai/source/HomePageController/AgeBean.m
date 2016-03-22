//
//  AgeBean.m
//  SaiSai
//
//  Created by Zhoufang on 15/8/25.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "AgeBean.h"

@implementation AgeBean

+(AgeBean *)parseInfo:(NSDictionary *)infoDic{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return [[AgeBean alloc] init];
    }
    
    AgeBean *bean = [[AgeBean alloc] init];
    bean.fromAge = [[NetDataCommon stringFromDic:infoDic forKey:@"fage"] intValue];
    bean.endAge  = [[NetDataCommon stringFromDic:infoDic forKey:@"eage"] intValue];
    bean.aId     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"id"]];
    bean.ageName = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"name"]];
    return bean;
    
}

@end
