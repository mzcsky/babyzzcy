//
//  CityViewController.h
//  SaiSai
//
//  Created by weige on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import "CityBean.h"

@protocol CityViewControllerDelegate <NSObject>

@optional

- (void)chooseCity:(CityBean*)bean;

@end

@interface CityViewController : XTViewController

@property (nonatomic, assign) id<CityViewControllerDelegate> delegate;

@end
