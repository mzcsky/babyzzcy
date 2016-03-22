//
//  CustomNavigationController.h
//  Exercises
//
//  Created by wjkang on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (UINavigationBarCategory)

- (void)setBackgroundImage:(UIImage*)image;

@end

@interface XTCustomNavigationController: UINavigationController<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UIView * mTittleView;
}

@property(nonatomic,weak) UIViewController* currentShowVC;

-(void)setNavigationBarBg;

@end
