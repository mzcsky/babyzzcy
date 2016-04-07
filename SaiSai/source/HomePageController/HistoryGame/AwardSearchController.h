//
//  AwardSearchController.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/22.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import "MatchCCBean.h"
@interface AwardSearchController : XTViewController


@property (nonatomic,strong) NSDictionary * requestInfo;
@property (nonatomic,strong) MatchCCBean *matchBean;

-(id)initWithInfo:(NSDictionary*)info;

@end
