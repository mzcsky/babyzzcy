//
//  UIImage+Color.h
//  YunShop
//
//  Created by weige on 15/7/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 *  将图片拉伸到指定尺寸
 *
 *  @param img  图片
 *  @param size 指定尺寸
 *
 *  @return 拉伸后的图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/**
 *  通过颜色创建指定尺寸图片
 *
 *  @param color 颜色
 *  @param size  指定尺寸
 *
 *  @return 创建后的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  通过颜色创建图片
 *
 *  @param color 颜色
 *
 *  @return 创建后的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  转换图片中指定区域的图片
 *
 *  @param image     原图
 *  @param rect      指定区域
 *  @param transform 转换量
 *
 *  @return 转换后的图片
 */
+ (UIImage*)imageFromImage:(UIImage*)image inRect:(CGRect)rect transform:(CGAffineTransform)transform;

@end
