//
//  SixBtnCell.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/15.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QingZiBean.h"

#define kMargic    20
#define btnCount 3  //每行显示按钮个数

@protocol SixBtnCellDelegate <NSObject>

@optional
- (void)pushViewWithIndex:(NSInteger)index andModel:(QingZiBean *)model;

@end

@interface SixBtnCell : UITableViewCell

@property (nonatomic, weak) id <SixBtnCellDelegate>delegate;


+ (instancetype)valueWithTableView:(UITableView *)tableView dataArr:(NSArray *)dataArr;
@end
