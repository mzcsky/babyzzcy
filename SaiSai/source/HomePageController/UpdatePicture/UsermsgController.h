//
//  UsermsgController.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/2/29.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import "SaiBean.h"
@interface UsermsgController : XTViewController


@property (nonatomic,strong) SaiBean * userBean;

-(id)initWithBean:(SaiBean*)bean;

@end
