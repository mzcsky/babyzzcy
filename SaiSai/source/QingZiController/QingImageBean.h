//
//  PlistModel.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/19.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QingImageBean : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * age;
@property (nonatomic, strong) NSString * logoPath;             //图片
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, strong) NSString * reg;
@property (nonatomic, strong) NSString * total;
@property (nonatomic, strong) NSString * spell;


+(QingImageBean *)ImageBeanparseInfo:(NSDictionary *)IBinfoDic;

@end
