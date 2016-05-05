//
//  PlistModel.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/19.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "PlistModel.h"

@implementation PlistModel
+ (PlistModel *)PMparseInfo:(NSDictionary *)PMinfoDic{
    if (!PMinfoDic || ![PMinfoDic isKindOfClass:[NSDictionary class]]) {
        return [[PlistModel alloc] init];
    }
    PlistModel *PMbean = [[PlistModel alloc] init];
    PMbean.logoPath     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];
    PMbean.name     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:PMinfoDic forKey:@"description"]];

    return PMbean;
}

@end
