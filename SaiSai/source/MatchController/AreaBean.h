//
//  AreaBean.h
//  SaiSai
//
//  Created by weige on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaBean : NSObject

@property (nonatomic, assign) NSInteger mId;

@property (nonatomic, retain) NSString  *area_name;

+ (AreaBean *)analyseData:(NSDictionary *)dict;

@end
