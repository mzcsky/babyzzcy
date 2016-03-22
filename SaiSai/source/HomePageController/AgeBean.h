//
//  AgeBean.h
//  SaiSai
//
//  Created by Zhoufang on 15/8/25.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgeBean : NSObject

@property (nonatomic,strong) NSString *aId;
@property (nonatomic,assign) int  fromAge;
@property (nonatomic,assign) int endAge;
@property (nonatomic,strong) NSString *ageName;

+(AgeBean *)parseInfo:(NSDictionary *)infoDic;

@end
