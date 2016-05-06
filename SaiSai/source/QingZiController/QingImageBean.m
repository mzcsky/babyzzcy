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
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
    PMbean.logoPath = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:IBinfoDic forKey:@"description"]];
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
