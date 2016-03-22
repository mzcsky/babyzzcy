//
//  MatchClaBean.h
//  SaiSai
//
//  Created by 葛新伟 on 15/12/7.
//  Copyright © 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchClaBean : NSObject

@property (nonatomic, strong) NSString      *mID;

@property (nonatomic, strong) NSString      *name;

/**
 *  @author Xinwei  Ge, 15-12-07 09:43:17
 *
 *  解析数据
 *
 *  @param dict 数据源
 *
 *  @return 比赛主题分类
 */
+ (MatchClaBean *)analyseData:(NSDictionary *)dict;

@end
