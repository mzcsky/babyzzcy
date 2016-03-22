//
//  UIButton+XT.h
//  YunShop
//
//  Created by Zhoufang on 15/7/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XT)

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
     nor_titleColor:(UIColor *)norColor
     sel_titleColor:(UIColor *)selColor
nor_backgroundImage:(UIImage *)norImage
sel_backgroundImage:(UIImage *)selImage
         haveBorder:(BOOL)have;

@end
