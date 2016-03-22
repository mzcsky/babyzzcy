//
//  CMCBean.m
//  SaiSai
//
//  Created by weige on 15/9/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "CMCBean.h"

@implementation CMCBean

+ (CMCBean *)analyseData:(NSDictionary *)dcit{
    CMCBean *bean = [[CMCBean alloc] init];
    
    bean.uid = [[NetDataCommon stringFromDic:dcit forKey:@"uid"] integerValue];
    
    bean.connent = [NetDataCommon stringFromDic:dcit forKey:@"content"];
    
    bean.nick_name = [NetDataCommon stringFromDic:dcit forKey:@"nick_name"];
    
    bean.icon = [NetDataCommon stringFromDic:dcit forKey:@"icon"];
    
    bean.addtime = [NetDataCommon stringFromDic:dcit forKey:@"addtime"];
    
    return bean;
}

@end
