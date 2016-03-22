//
//  BMController.h
//  SaiSai
//
//  Created by weige on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import "MatchCCBean.h"

@protocol BMControllerDelegate <NSObject>

@optional

- (void)showCansaiZhiDao;

@end

@interface BMController : XTViewController{
    dispatch_source_t _timer;
}

@property (nonatomic, assign) id<BMControllerDelegate> delegate;

@property (nonatomic, retain) MatchCCBean       *fBean;

@end
