//
//  LastApplyInfoBean.h
//  SaiSai
//
//  Created by weige on 15/9/4.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LastApplyInfoBean : NSObject

@property (nonatomic, assign) NSInteger     mId;

@property (nonatomic, retain) NSString      *realname;

@property (nonatomic, assign) NSInteger     gender;

@property (nonatomic, assign) NSInteger     city_id;

@property (nonatomic, assign) NSInteger     area_id;

@property (nonatomic, retain) NSString      *birthday;

@property (nonatomic, retain) NSString      *tel;

@property (nonatomic, retain) NSString      *address;

@property (nonatomic, retain) NSString      *email;

@property (nonatomic, retain) NSString      *img;

@property (nonatomic, retain) NSString      *addtime;

@property (nonatomic, retain) NSString      *city_name;

@property (nonatomic, retain) NSString      *area_name;

@property (nonatomic, retain) NSString      *is_org;


+ (LastApplyInfoBean *)analyseData:(NSDictionary *)dict;


@end
