//
//  AwardLevelBean.h
//  SaiSai
//
//  Created by weige on 15/9/14.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwardLevelBean : NSObject

@property (nonatomic,strong) NSString *mId;
@property (nonatomic,strong) NSString *mName;

+(AwardLevelBean *)parseInfo:(NSDictionary *)infoDic;

@end
