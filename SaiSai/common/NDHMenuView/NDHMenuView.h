//
//  NDHMenuView.h
//  PurchaseManager
//
//  Created by weige on 15/5/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NDHMenuViewDelegate <NSObject>

@optional

/**
 *  菜单栏选中
 *
 *  @param index 选中位置
 *
 *  @since 2015-05-30
 */
- (void)menuDidSelected:(int)index;

@end

@interface NDHMenuView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    UICollectionView    *_collectionView;
    
    NSArray             *_array;
    NSMutableArray      *_sizeArray;
    int                 _curIndex;
}

@property (nonatomic, retain) UIColor   *selColor;

@property (nonatomic, assign) id<NDHMenuViewDelegate> delegate;

/**
 *  设置菜单标题
 *
 *  @param array 菜单标题
 *
 *  @since 2015-05-30
 */
- (void)setTitles:(NSArray *)array;

@end
