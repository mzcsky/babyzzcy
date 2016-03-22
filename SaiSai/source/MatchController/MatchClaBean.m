//
//  MatchClaBean.m
//  SaiSai
//
//  Created by 葛新伟 on 15/12/7.
//  Copyright © 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MatchClaBean.h"

@implementation MatchClaBean

/**
 *  @author Xinwei  Ge, 15-12-07 09:43:17
 *
 *  解析数据
 *
 *  @param dict 数据源
 *
 *  @return 比赛主题分类
 */
+ (MatchClaBean *)analyseData:(NSDictionary *)dict{
    MatchClaBean *bean = [[MatchClaBean alloc] init];
    if (bean) {
        bean.mID = [NetDataCommon stringFromDic:dict forKey:@"id"];
        bean.name = [NetDataCommon stringFromDic:dict forKey:@"name"];
    }
    return bean;
}

@end
