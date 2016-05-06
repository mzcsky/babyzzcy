//
//  PlistModel.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/19.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "QingImageBean.h"

@implementation QingImageBean
+(id)ImageBeanparseInfo:(NSDictionary *)IBinfoDic{
            if (!IBinfoDic || ![IBinfoDic isKindOfClass:[NSDictionary class]]) {
                        return [[QingImageBean alloc] init];
                                        }
    QingImageBean *PMbean = [[QingImageBean alloc] init];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.distance = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.totalcount = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.name = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.otherTitle = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.provinceId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.localX = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.localY = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];

    return PMbean;
}

@end
