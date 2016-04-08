//
//  MySaiSaiController.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import "HomePageCell.h"
#import "AttendOrFansBean.h"
#import "SaiBean.h"


@interface MySaiSaiController : XTViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) SaiBean  *saiBean;

-(id)initWithUserId:(int)userid bOrAid:(int)boraid ;
@property (nonatomic) int  uid;
@property (nonatomic) int bOrAId;
@property (nonatomic) int saibean;
@end
