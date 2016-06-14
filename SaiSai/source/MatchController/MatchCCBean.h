//
//  MatchCCBean.h
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchCCBean : NSObject



@property (nonatomic, assign) NSInteger     mId;

@property (nonatomic, assign) NSInteger     status;

@property (nonatomic, retain) NSString      *g_desc;

@property (nonatomic, retain) NSString      *g_guide;

@property (nonatomic, retain) NSString      *recommend;

@property (nonatomic, retain) NSString      *g_title;

@property (nonatomic, retain) NSString      *img;

@property (nonatomic, assign) BOOL          isXG;

@property (nonatomic, retain) NSString      *content;

@property (nonatomic, retain) NSString      *thumbnail;

+ (MatchCCBean *)analyseData:(NSDictionary *)dict;

@end
