//
//  UIView+XT.m
//  YunShop
//
//  Created by Zhoufang on 15/7/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "UIView+XT.h"

@implementation UIView (XT)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self resignViewFirstResponse:self];
}

- (void)resignViewFirstResponse:(UIView *)view{
    if (view.subviews.count>0 && (![view isKindOfClass:[UITextField class]] && ![view isKindOfClass:[UITextView class]])) {
        for (UIView *sub in view.subviews) {
            [self resignViewFirstResponse:sub];
        }
    }else{
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField * obj1 = (UITextField *)view;
            [obj1 resignFirstResponder];
        }
        if ([view isKindOfClass:[UITextView class]]) {
            UITextView * obj1 = (UITextView *)view;
            [obj1 resignFirstResponder];
        }
    }
}

@end
