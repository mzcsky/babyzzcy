//
//  ProductDetailsCell.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/26.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ProductDetailsCellDelegate <NSObject>



@end
@interface ProductDetailsCell : UITableViewCell

@property (nonatomic, weak)  id<ProductDetailsCellDelegate>delegate;

+ (instancetype)valueWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
