//
//  LastApplyInfoBean.m
//  SaiSai
//
//  Created by weige on 15/9/4.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "LastApplyInfoBean.h"

@implementation LastApplyInfoBean

+ (LastApplyInfoBean *)analyseData:(NSDictionary *)dict{
    LastApplyInfoBean *bean = [[LastApplyInfoBean alloc] init];
    
    bean.mId        = [[NetDataCommon stringFromDic:dict forKey:@"id"] integerValue];
    bean.realname   = [NetDataCommon stringFromDic:dict forKey:@"realname"];
    bean.gender     = [[NetDataCommon stringFromDic:dict forKey:@"gender"] integerValue];
    bean.city_id    = [[NetDataCommon stringFromDic:dict forKey:@"city_id"] integerValue];
    bean.area_id    = [[NetDataCommon stringFromDic:dict forKey:@"area_id"] integerValue];
    bean.birthday   = [NetDataCommon stringFromDic:dict forKey:@"birthday"];
    bean.tel        = [NetDataCommon stringFromDic:dict forKey:@"tel"];
    bean.address    = [NetDataCommon stringFromDic:dict forKey:@"address"];
    bean.email      = [NetDataCommon stringFromDic:dict forKey:@"email"];
    bean.img        = [NetDataCommon stringFromDic:dict forKey:@"img"];
    bean.addtime    = [NetDataCommon stringFromDic:dict forKey:@"addtime"];
    bean.city_name  = [NetDataCommon stringFromDic:dict forKey:@"city_name"];
    bean.area_name  = [NetDataCommon stringFromDic:dict forKey:@"area_name"];

    return bean;
}

@end
