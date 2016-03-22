//
//  XTTabBarController.h
//  XiaoliuFruits
//
//  Created by wjkang on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
enum
{
    eUnLogin,
    eAddFriend,
    eUnService
};


@interface XTTabBarController : UITabBarController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIView * mTabBarView;
    
    float mTabBarHeigth;
    
    NSMutableArray * itemArr;
    
    NSMutableArray * itemAnimations;
    
}

@property (nonatomic,retain) NSString *mGiftNameFilePath;
-(void)stupTabBarViewWithHeigth:(float)higth norImage:(NSArray *)norImage selImage:(NSArray *)selImage titleArr:(NSArray *)titleArr;

-(void)itemPressed:(id)sender;

-(void)addTipWithIndex:(NSInteger)index messageNum:(NSInteger)num;

-(void)setItemAnimationWithIndex:(NSInteger)index ImageArray:(NSArray*)iamgeArray;

-(void)setmTabBarViewHidden:(BOOL)stade animation:(BOOL)animated;

- (NSArray *)reversedArray:(NSArray *)pArray;
- (void)setSelectedItem:(NSUInteger)selectIndex;
-(void)popSelf;

@end
