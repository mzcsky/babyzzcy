//
//  QingZiCell.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/12.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMargic    (20*SCREEN_WIDTH)
#define btnCount 3  //每行显示按钮个数

@interface QingZiCell : UITableViewCell

+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
