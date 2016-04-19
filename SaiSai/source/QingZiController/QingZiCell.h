//
//  QingZiCell.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/12.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlistModel.h"


@interface QingZiCell : UITableViewCell

+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@property (nonatomic, strong) PlistModel * model;


@end
