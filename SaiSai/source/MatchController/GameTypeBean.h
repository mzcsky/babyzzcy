//
//  GameTypeBean.h
//  SaiSai
//
//  Created by weige on 15/9/4.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameTypeBean : NSObject

@property (nonatomic, assign) NSInteger     mId;

@property (nonatomic, retain) NSString      *name;

+ (GameTypeBean *)analyseData:(NSDictionary *)dict;

@end
