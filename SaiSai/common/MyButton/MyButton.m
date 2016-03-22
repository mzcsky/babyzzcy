//
//  MyButton.m
//  SaiSai
//
//  Created by weige on 15/8/19.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.titleLabel.frame;
    frame.size.width = self.frame.size.width;
    self.titleLabel.frame = frame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.center = CGPointMake(self.width/2, 65);
    self.imageView.center = CGPointMake(self.width/2, 35);
}

@end
