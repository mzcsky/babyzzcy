//
//  MatchCCBean.m
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MatchCCBean.h"

@implementation MatchCCBean

+ (MatchCCBean *)analyseData:(NSDictionary *)dict{
    MatchCCBean *bean = [[MatchCCBean alloc] init];
    
    bean.g_desc = [NetDataCommon stringFromDic:dict forKey:@"g_desc" orKey:@"desc"];
    bean.g_title = [NetDataCommon stringFromDic:dict forKey:@"g_title" orKey:@"title"];
    bean.g_guide = [NetDataCommon stringFromDic:dict forKey:@"g_guide"];
    bean.recommend = [NetDataCommon stringFromDic:dict forKey:@"recommend"];
    bean.img = [NetDataCommon stringFromDic:dict forKey:@"img"];
    bean.mId = [[NetDataCommon stringFromDic:dict forKey:@"id"] integerValue];
    bean.status = [[NetDataCommon stringFromDic:dict forKey:@"status"] integerValue];
    bean.content = [NetDataCommon stringFromDic:dict forKey:@"content"];
    
    return bean;
}

@end
