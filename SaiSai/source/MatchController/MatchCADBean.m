//
//  MatchCADBean.m
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MatchCADBean.h"

@implementation MatchCADBean

+ (MatchCADBean *)analyseData:(NSDictionary *)dict{
    MatchCADBean *bean = [[MatchCADBean alloc] init];
    
    bean.mId = [[NetDataCommon stringFromDic:dict forKey:@"id"] integerValue];
    bean.g_guide = [NetDataCommon stringFromDic:dict forKey:@"g_guide"];
    bean.img = [NetDataCommon stringFromDic:dict forKey:@"img" orKey:@"pic_url"];
    bean.status = [[NetDataCommon stringFromDic:dict forKey:@"status"] integerValue];
    
    return bean;
}

@end
