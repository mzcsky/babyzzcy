//
//  QingZiTitleScroll.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/15.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleScrollDelegate <NSObject>

@optional
- (void)btnClickAtIndex:(NSInteger)index;

@end

@interface QingZiTitleScroll : UIScrollView

@property (nonatomic,weak) id <TitleScrollDelegate>btnDelegate;
- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr;

@end
