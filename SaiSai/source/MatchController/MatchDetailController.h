//
//  MatchDetailController.h
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import "MatchCCBean.h"

@interface MatchDetailController : XTViewController<UMSocialUIDelegate>

@property (nonatomic, retain) MatchCCBean   *fBean;

@property (nonatomic, retain) NSArray            *adArray;
@property (nonatomic, retain) NSArray            *adSArray;

@end
