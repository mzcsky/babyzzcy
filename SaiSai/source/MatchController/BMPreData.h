//
//  BMPreData.h
//  SaiSai
//
//  Created by weige on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameTypeBean.h"
#import "LastApplyInfoBean.h"

@interface BMPreData : NSObject

@property (nonatomic, retain) NSArray   *games_type;
@property (nonatomic, retain) NSArray   *games_type_name;

@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, assign) NSInteger mId;
//验证码是否必填1：非必填2：必填
@property (nonatomic, assign) NSInteger is_code;
//作品类型是否必填1：非必填2：必填
@property (nonatomic, assign) NSInteger is_games_type_relative;
//级别是否必填1：非必填2：必填
@property (nonatomic, assign) NSInteger is_level;
//参赛组织是否必填  1：非必填  2：必填
@property (nonatomic, assign) NSInteger is_org;
//指导老师是否必填1：非必填2：必填
@property (nonatomic, assign) NSInteger is_teacher;
//分类id
@property (nonatomic, assign) NSInteger tid;
//参数者照片是否必填1：非必填2：必填
@property (nonatomic, assign) NSInteger is_img;
//是否需要上传作品1 需要2 不需要
@property (nonatomic, assign) NSInteger is_upload;
//是否是单张1 是单张2：多张
@property (nonatomic, assign) NSInteger is_single;

@property (nonatomic, retain) LastApplyInfoBean   *last_apply_info;



+ (BMPreData *)analyseData:(NSDictionary *)dict;

@end
