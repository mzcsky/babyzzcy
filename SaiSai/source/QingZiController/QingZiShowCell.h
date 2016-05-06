//
//  QingZiShowCell.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/20.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QingZiBean.h"
@protocol QingZiShowCellDelegate <NSObject>

@end

@interface QingZiShowCell : UITableViewCell

@property (nonatomic, weak) id<QingZiShowCellDelegate>delegate;

+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
