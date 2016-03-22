//
//  MyNavButton.m
//  SaiSai
//
//  Created by weige on 15/9/7.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MyNavButton.h"

@implementation MyNavButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.titleLabel.frame;
    frame.size.width = self.frame.size.width;
    self.titleLabel.frame = frame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.center = CGPointMake(self.width/2, 44);
    self.imageView.center = CGPointMake(self.width/2, 25);
}

@end
