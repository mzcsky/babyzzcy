//
//  XTTabBarItem.h
//  XiaoliuFruits
//
//  Created by mac on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    NORMAL,
    HIGHLIGHT,
    SELECTED,
};


@interface XTTabItem : NSObject {
    UIImage * imageNor;
    UIImage * imageSel;
    NSString * itemtittle;
}
@property (nonatomic,retain) UIImage * imageNor;
@property (nonatomic,retain) UIImage * imageSel;
@property (nonatomic,retain) NSString * itemtittle;
@end

@interface XTTabBarItem : UIControl
{
    XTTabItem * item;
    UIImageView * itemBgImage;

    UILabel *mItemBgLabel;
    UIImageView * tipImage;
    UILabel * tipLabel;
}

@property (nonatomic,retain) UIImageView * itemBgImage;
@property (nonatomic,retain) UILabel * mItemBgLabel;
@property (nonatomic,retain) XTTabItem * item;
-(void)setItem:(XTTabItem*)aItem;
-(void)setTips:(NSInteger)tipsNum;
- (void)setPoint:(BOOL)show;
-(void)setItemImage:(BOOL)isSel;
- (void)setItemHightImage:(BOOL)isSel;
-(void)hiddenTips;

@end
