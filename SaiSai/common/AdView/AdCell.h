//
//  AdCell.h
//  SaleForIos
//
//  Created by weige on 15/3/7.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface AdCell : UICollectionViewCell{
    UIImageView *_imageView;
}

/**
 *  设置图片
 *
 *  @param path 图片网络路径
 *
 *  @since 2015-03-07
 */
- (void)setImage:(NSString *)path;

@end
