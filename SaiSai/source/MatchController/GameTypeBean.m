//
//  GameTypeBean.m
//  SaiSai
//
//  Created by weige on 15/9/4.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "GameTypeBean.h"

@implementation GameTypeBean

+ (GameTypeBean *)analyseData:(NSDictionary *)dict{
    GameTypeBean *bean = [[GameTypeBean alloc] init];
    
    bean.mId = [[NetDataCommon stringFromDic:dict forKey:@"id"] integerValue];
    bean.name = [NetDataCommon stringFromDic:dict forKey:@"name"];
    
    return bean;
}

@end
