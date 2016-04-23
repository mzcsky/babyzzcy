
//
//  UpdatePictureController.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import "SaiBean.h"
#import "BMPreData.h"

@interface UpdatePictureController : XTViewController

@property (nonatomic,strong) SaiBean *saiBean;

- (void)setPreData:(BMPreData *)data;

- (void)setPPram:(NSMutableDictionary *)pram;

@end
