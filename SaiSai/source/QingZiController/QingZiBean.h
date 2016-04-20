//
//  QingZiBean.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/20.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QingZiBean : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * descr;
@property (nonatomic, strong) NSString * datavalue;

+(QingZiBean *)QZparseInfo:(NSDictionary *)QZinfoDic;

@end
