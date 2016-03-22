//
//  NDDataPicker.h
//  YunShop
//
//  Created by weige on 15/7/14.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NDDataPicker;

@protocol NDDataPickerDelegate <NSObject>

@optional

/**
 *  内容已选择
 *
 *  @param date 选择的内容
 */
- (void)dataDidSelected:(NSString *)data index:(int)index;

/**
 *  内容已选择
 *
 *  @param date 选择的内容
 */
- (void)dataDidSelected:(NSString *)data index:(int)index picker:(NDDataPicker *)picker;

/**
 *  取消选择
 */
-(void)cancelSelect;

@end

@interface NDDataPicker : UIView

@property (nonatomic, assign) id<NDDataPickerDelegate> delegate;

@property (nonatomic, retain) NSArray   *datas;

- (void)reloadData;

@end
