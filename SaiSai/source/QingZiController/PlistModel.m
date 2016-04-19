//
//  PlistModel.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/19.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "PlistModel.h"

@implementation PlistModel
+ (instancetype)valueWithDic:(NSDictionary *)dic{

    return [[self alloc] initWithDic:dic];
}
- (instancetype)initWithDic:(NSDictionary *)dic{

    if (self = [super init]) {
        self.name = dic[@"name"];
        self.age = dic[@"age"];

        self.time = dic[@"time"];

        self.area = dic[@"area"];

    }
    
    return self;
}
@end
