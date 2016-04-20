//
//  QingZiBean.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/20.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiBean.h"

@implementation QingZiBean

+ (QingZiBean *)QZparseInfo:(NSDictionary *)QZinfoDic{
    if (!QZinfoDic || ![QZinfoDic isKindOfClass:[NSDictionary class]]) {
        return [[QingZiBean alloc] init];
    }
    QingZiBean *QZbean = [[QingZiBean alloc] init];
    QZbean.descr     = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:QZinfoDic forKey:@"description"]];
    QZbean.content   = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:QZinfoDic forKey:@"content"]];
    QZbean.datavalue = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:QZinfoDic forKey:@"datavalue"]];
    return QZbean;
}

@end
