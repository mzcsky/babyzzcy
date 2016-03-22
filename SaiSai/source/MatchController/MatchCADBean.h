//
//  MatchCADBean.h
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchCADBean : NSObject

@property (nonatomic, assign) NSInteger     mId;

@property (nonatomic, assign) NSInteger     status;

@property (nonatomic, retain) NSString      *img;

@property (nonatomic, retain) NSString      *g_guide;


+ (MatchCADBean *)analyseData:(NSDictionary *)dict;

@end
