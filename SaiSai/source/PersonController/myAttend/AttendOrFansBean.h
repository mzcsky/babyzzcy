//
//  AttendOrFansBean.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendOrFansBean : NSObject

@property (nonatomic,strong) NSString *afId;
@property (nonatomic,strong) NSString *bOrAId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,assign) int        attention;  //是否关注 0：未关注 1：已关注

+(AttendOrFansBean *)parseInfo:(NSDictionary *)infoDic;

@end
