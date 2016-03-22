//
//  AdvertView.h
//  Qmjg
//
//  Created by mac on 14-3-13.
//  Copyright (c) 2014年 XYTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

@class AdvertView;

#pragma mark - AdvertViewDelegate
@protocol AdvertViewDelegate <NSObject>

@required
- (void)didSelectIndex:(NSInteger)index;

@end

@interface AdvertView : UIView<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView    *_collectionView;
    StyledPageControl *_pageControl;
    NSMutableArray *_imageArr;
    NSTimer *_timer;
    
    int _currentIndex;
    
    BOOL  _isUN;
}
@property (nonatomic, assign) id<AdvertViewDelegate> _delegate;

/**
 *  @author Xinwei  Ge, 15-11-10 11:11:32
 *
 *  重新加载数据（刷新操作）
 *
 *  @param array 图片数组
 */
- (void)reloadDataWithArray:(NSArray *)array;

- (id)initWithFrame:(CGRect)frame delegate:(id<AdvertViewDelegate>)delegate withImageArr:(NSArray*)imageArr;

- (id)initUNWithFrame:(CGRect)frame delegate:(id<AdvertViewDelegate>)delegate withImageArr:(NSMutableArray*)imageArr;

#pragma mark
#pragma mark ====== animation timer ======
/**
 *  开始轮播动画
 *
 *  @since 2015-03-07
 */
- (void)startAnimation;

/**
 *  停止轮播动画
 *
 *  @since 2015-03-07
 */
- (void)stopAnimation;

/**
 *  设置滑动时放大image
 *
 *  @param frame image的frame
 *
 *  @since 2015-03-09
 */
- (void)setScrollImageFrame:(CGRect)frame;

/**
 *  移除放大的image
 *
 *  @since 2015-03-09
 */
- (void)removeImage;
@end