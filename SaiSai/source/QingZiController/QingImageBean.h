//
//  PlistModel.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/19.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QingImageBean : NSObject

@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString * totalcount;
@property (nonatomic, strong) NSString * logoPath;             //图片
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * otherTitle;
@property (nonatomic, strong) NSString * provinceId;
@property (nonatomic, strong) NSString * minAge;
@property (nonatomic, strong) NSString * maxAge;
@property (nonatomic, strong) NSString * districtId;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, strong) NSString * localX;
@property (nonatomic, strong) NSString * localY;
@property (nonatomic, strong) NSString * stock;
@property (nonatomic, strong) NSString * showPrice;
@property (nonatomic, strong) NSString * count;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * introduceId;
@property (nonatomic, strong) NSString * privilege;


+(QingImageBean *)ImageBeanparseInfo:(NSDictionary *)IBinfoDic;

@end
