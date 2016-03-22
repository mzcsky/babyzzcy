//
//  HotCityCell.h
//  SaiSai
//
//  Created by weige on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityBean.h"

@protocol HotCityCellDelegate <NSObject>

@optional

- (void)chooseCity:(CityBean*)bean;

@end

@interface HotCityCell : UITableViewCell

@property (nonatomic, assign) id<HotCityCellDelegate> delegate;

-(void)setData:(NSArray *)array;

@end
