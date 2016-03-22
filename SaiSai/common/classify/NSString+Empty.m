//
//  NSString+Empty.m
//  YunShop
//
//  Created by weige on 15/7/10.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "NSString+Empty.h"

@implementation NSString (Empty)

/**
 *  判断string 是否为空
 *
 *  @return 是否为空
 */
- (BOOL)isEmpty{
    if (self == nil || [self isKindOfClass:[NSNull class]] || [self isEqualToString:@""] || [self rangeOfString:@"null"].length>0) {
        return YES;
    }
    return NO;
}

@end
