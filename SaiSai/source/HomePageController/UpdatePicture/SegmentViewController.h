//
//  SegmentViewController.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/16.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"
#import <UIKit/UIKit.h>
@protocol SegmentViewControllerDelegate <NSObject>
@optional
- (void)segmentSelected:(int)index;
- (void)tappedAtImage:(long)gallertId;
@end


@interface SegmentViewController : UIView{
    NSMutableArray    *btnArray;
}
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) id<SegmentViewControllerDelegate> delegate;

@property (nonatomic, retain) UIColor *selectedBackgoundColor;
@property (nonatomic, retain) UIColor *normalBackgroundColor;
@property (nonatomic, retain) UIColor *selectedTextColor;
@property (nonatomic, retain) UIColor *normalTextColor;
@property (nonatomic, retain) UIColor *borderColor;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (UIButton *)segmentAtIndex:(int)index;
- (void)updateLayout;
@end
