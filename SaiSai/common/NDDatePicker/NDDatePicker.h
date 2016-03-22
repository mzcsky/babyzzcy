//
//  NDDatePicker.h
//  YunShop
//
//  Created by weige on 15/7/14.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDDatePickerDelegate <NSObject>

@optional

/**
 *  日期已选择
 *
 *  @param date 选择的日期
 */
- (void)dateDidSelected:(NSDate *)date;

@end

@interface NDDatePicker : UIView

@property (nonatomic,strong) NSDate*  maxDate;
@property (nonatomic,strong) NSDate*  minDate;
@property (nonatomic, assign) id<NDDatePickerDelegate> delegate;

- (void)setDate:(NSDate *)date;

- (void)setModel:(UIDatePickerMode)model;

@end
