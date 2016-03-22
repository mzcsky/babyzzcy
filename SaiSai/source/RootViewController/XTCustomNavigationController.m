//
//  CustomNavigationController.m
//  Exercises
//
//  Created by wjkang on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "XTCustomNavigationController.h"
#import "XTViewController.h"
@implementation UINavigationBar (UINavigationBarCategory)

-(void)setBackgroundImage:(UIImage*)image  
{  
    NSArray * views = [self subviews];
    if ([views count]) {
        UIView * groundView = [views objectAtIndex:0];
        if(image == nil) {
            UIView * subView = [groundView viewWithTag:1000];
            if (subView) {
                [subView removeFromSuperview];
            }
            return;
        }
        self.backgroundColor = [UIColor clearColor];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];  
        backgroundView.tag = 1000;  
        backgroundView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);  
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [groundView addSubview:backgroundView];
    }
}

@end 

@implementation XTCustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarBg];
}

-(void)setNavigationBarBg {
    UIImage *image=[UIImage imageWithColor:XT_MAINCOLOR];
    [self.navigationBar setBackgroundImage:image];
    
    if (IOS_VERSION >= 7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    XTCustomNavigationController* nvc = [super initWithRootViewController:rootViewController];
    if (IOS_VERSION>=7) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    nvc.delegate = self;
    return nvc;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1)
        self.currentShowVC = Nil;
    else
        self.currentShowVC = viewController;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (IOS_VERSION>=7 && gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController);
    }
    return YES;
}

@end
