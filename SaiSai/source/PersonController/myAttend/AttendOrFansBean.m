//
//  AttendOrFansBean.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "AttendOrFansBean.h"

@implementation AttendOrFansBean

+(AttendOrFansBean *)parseInfo:(NSDictionary *)infoDic{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return [[AttendOrFansBean alloc] init];
    }
    AttendOrFansBean *bean = [[AttendOrFansBean alloc] init];
    bean.afId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"id"]];
    bean.bOrAId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"bid" orKey:@"aid"]];

    
    
    
    bean.nickName = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"nick_name"]];
    bean.icon = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"icon"]];
    //我的关注，我的粉丝 返参: attention 是否关注 0：未关注 1：已关注
    //搜索好友时，      返参：status:   关注状态 0 未关注  1 关注
    bean.attention = [[NetDataCommon stringFromDic:infoDic forKey:@"attention" orKey:@"status"] intValue];
    return bean;
}

@end
