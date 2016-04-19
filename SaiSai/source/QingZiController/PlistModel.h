//
//  PlistModel.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/19.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistModel : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * age;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSString * time;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;
@end
