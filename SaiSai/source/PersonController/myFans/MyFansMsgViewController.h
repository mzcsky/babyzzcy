//
//  MyFansMsgViewController.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/1.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import "AttendOrFansBean.h"
@interface MyFansMsgViewController : XTViewController

@property (nonatomic,strong) AttendOrFansBean * userBean;

-(id)initWithBean:(AttendOrFansBean *)bean;

@end
