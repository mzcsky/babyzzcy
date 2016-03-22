//
//  NSMutableString+easy.h
//  PurchaseManager
//
//  Created by weige on 15/7/31.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (easy)

/**
 *  设置基础字体
 *
 *  @param font 基础字体
 */
- (void)setBaseFont:(UIFont *)font;

/**
 *  设置基础颜色
 *
 *  @param color 基础颜色
 */
- (void)setBaseTextColor:(UIColor *)color;

/**
 *  设置子字符串字体
 *
 *  @param font   子字符串字体
 *  @param subStr 子字符串
 */
- (void)setFont:(UIFont *)font forSubStr:(NSString *)subStr;

/**
 *  设置子字符串颜色
 *
 *  @param color  子字符串颜色
 *  @param subStr 子字符串
 */
- (void)setTextColor:(UIColor *)color forSubStr:(NSString *)subStr;

/**
 *  设置指定区域字体
 *
 *  @param font  指定区域字体
 *  @param range 指定区域
 */
- (void)setFont:(UIFont *)font inRange:(NSRange)range;

/**
 *  设置指定区域颜色
 *
 *  @param color  自定区域颜色
 *  @param subStr 指定区域
 */
- (void)setTextColor:(UIColor *)color inRange:(NSRange)range;



@end
