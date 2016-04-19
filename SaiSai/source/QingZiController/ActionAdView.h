//
//  ActionAdView.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/15.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchCCBean.h"
@protocol ActionAdViewDelegate <NSObject>

@optional
- (void)imageViewClickAtIndex:(NSInteger)index;
- (void)searchBtnClickSender:(UIButton *)sender;
@end


@interface ActionAdView : UITableViewCell



@property (nonatomic, weak) id <ActionAdViewDelegate>delegate;

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIPageControl * pageControl;


+ (instancetype)valueWithTableView:(UITableView *)tableView imgArr:(NSArray *)imgArr;

@end
