//
//  ClassificationButton.m
//  YunShop
//
//  Created by weige on 15/7/14.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "ClassificationButton.h"

@implementation ClassificationButton

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.imageView.center = CGPointMake(self.frame.size.width-8, 17.5);
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width-15, 35);
    self.titleLabel.center = CGPointMake((self.frame.size.width-15)/2, 17.5);
}

@end
