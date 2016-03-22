//
//  UIButton+XT.m
//  YunShop
//
//  Created by Zhoufang on 15/7/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "UIButton+XT.h"

@implementation UIButton (XT)

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
     nor_titleColor:(UIColor *)norColor
     sel_titleColor:(UIColor *)selColor
nor_backgroundImage:(UIImage *)norImage
sel_backgroundImage:(UIImage *)selImage
         haveBorder:(BOOL)have
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    self.exclusiveTouch = YES;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:norColor forState:UIControlStateNormal];
    [self setTitleColor:selColor forState:UIControlStateSelected];
    [self setTitleColor:selColor forState:UIControlStateHighlighted];
    [self setBackgroundImage:norImage forState:UIControlStateNormal];
    [self setBackgroundImage:selImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:selImage forState:UIControlStateSelected];
    if (have) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3.f;
        self.layer.borderWidth = 1;
    }
    self.layer.borderColor = norColor.CGColor;
    
    return self;
}

@end
