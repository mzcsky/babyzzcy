//
//  ProductDetailsImageCell.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/26.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductDetailsImageCellDelegate <NSObject>
@required
@end

@interface ProductDetailsImageCell : UITableViewCell

@property (nonatomic, strong) UIScrollView * imagescroll;
@property (nonatomic, weak) id<ProductDetailsImageCellDelegate>delegate;


+ (instancetype)valueWithTableView:(UITableView *)tableView imageArr:(NSMutableArray *)imageArr;

@end
