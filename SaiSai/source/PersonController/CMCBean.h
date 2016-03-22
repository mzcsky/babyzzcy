//
//  CMCBean.h
//  SaiSai
//
//  Created by weige on 15/9/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCBean : NSObject

@property (nonatomic, assign) NSInteger     uid;

@property (nonatomic, retain) NSString      *nick_name;

@property (nonatomic, retain) NSString      *icon;

@property (nonatomic, retain) NSString      *connent;

@property (nonatomic, retain) NSString      *addtime;

+ (CMCBean *)analyseData:(NSDictionary *)dcit;

@end
