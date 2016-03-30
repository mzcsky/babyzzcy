//
//  AwardLevelBean.m
//  SaiSai
//
//  Created by weige on 15/9/14.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "AwardLevelBean.h"

@implementation AwardLevelBean

+(AwardLevelBean *)parseInfo:(NSDictionary *)infoDic{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return [[AwardLevelBean alloc] init];
    }
    AwardLevelBean *bean = [[AwardLevelBean alloc] init];
    //mid 
    bean.mId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"id"]];
    bean.mName = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"name"]];
    return bean;
}

@end
