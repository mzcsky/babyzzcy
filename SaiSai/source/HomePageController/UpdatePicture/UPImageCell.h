//
//  UPImageCell.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/4.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UPImageCellDelegate <NSObject>

-(void)upImageCellAlert:(NSIndexPath *)indexPath;

@end

@interface UPImageCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIButton    *alertBtn;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,assign)id<UPImageCellDelegate> delegate;

-(void)setImage:(UIImage *)image;

- (void)setImageURL:(NSString *)url;

@end
