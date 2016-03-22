//
//  NDHMenuCell.h
//  PurchaseManager
//
//  Created by weige on 15/5/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDHMenuCell : UICollectionViewCell{
    UILabel     *_label;
    UIImageView *_imageView;
}

@property (nonatomic, retain) UIColor   *selColor;

#pragma mark
#pragma mark ====== 设置 ======
/**
 *  设置标题
 *
 *  @param title 标题
 *
 *  @since 2015-05-30
 */
- (void)setTitle:(NSString *)title;

/**
 *  设置是否选中
 *
 *  @param isSel 是否选中
 *
 *  @since 2015-05-30
 */
- (void)setTitleSelect:(BOOL)isSel;

@end
