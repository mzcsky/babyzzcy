//
//  NSMutableString+easy.m
//  PurchaseManager
//
//  Created by weige on 15/7/31.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "NSMutableAttributedString+easy.h"

@implementation NSMutableAttributedString (easy)

/**
 *  设置基础字体
 *
 *  @param font 基础字体
 */
- (void)setBaseFont:(UIFont *)font{
    NSRange range;
    range.location = 0;
    range.length = self.string.length;
    [self addAttribute:NSFontAttributeName
                 value:font
                 range:range];
}

/**
 *  设置基础颜色
 *
 *  @param color 基础颜色
 */
- (void)setBaseTextColor:(UIColor *)color{
    NSRange range;
    range.location = 0;
    range.length = self.string.length;
    [self addAttribute:NSForegroundColorAttributeName
                 value:color
                 range:range];
}

/**
 *  设置子字符串字体
 *
 *  @param font   子字符串字体
 *  @param subStr 子字符串
 */
- (void)setFont:(UIFont *)font forSubStr:(NSString *)subStr{
    [self addAttribute:NSFontAttributeName
                 value:font
                 range:[self.string rangeOfString:subStr]];
}

/**
 *  设置子字符串颜色
 *
 *  @param color  子字符串颜色
 *  @param subStr 子字符串
 */
- (void)setTextColor:(UIColor *)color forSubStr:(NSString *)subStr{
    
    
    [self addAttribute:NSForegroundColorAttributeName
                 value:color
                 range:[self.string rangeOfString:subStr]];
}

/**
 *  设置指定区域字体
 *
 *  @param font  指定区域字体
 *  @param range 指定区域
 */
- (void)setFont:(UIFont *)font inRange:(NSRange)range{
    [self treateRange:&range];
    [self addAttribute:NSFontAttributeName
                 value:font
                 range:range];
}

/**
 *  设置指定区域颜色
 *
 *  @param color  自定区域颜色
 *  @param subStr 指定区域
 */
- (void)setTextColor:(UIColor *)color inRange:(NSRange)range{
    [self treateRange:&range];
    [self addAttribute:NSForegroundColorAttributeName
                 value:color
                 range:range];
}


/**
 *  处理range越界
 *
 *  @param range 指定区域
 */
- (void)treateRange:(NSRange *)range{
    if (range->location>=self.string.length) {
        range->location = 0;
        range->length = 0;
        NSLog(@"range.location 超出字符长度");
    }
    if ((range->location+range->length)>self.string.length) {
        range->length = self.string.length-range->location-1;
        NSLog(@"range.length 超长");
    }
}

@end
