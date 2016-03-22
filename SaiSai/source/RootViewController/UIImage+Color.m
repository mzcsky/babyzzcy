//
//  UIImage+Color.m
//  YunShop
//
//  Created by weige on 15/7/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

/**
 *  将图片拉伸到指定尺寸
 *
 *  @param img  图片
 *  @param size 指定尺寸
 *
 *  @return 拉伸后的图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *  通过颜色创建指定尺寸图片
 *
 *  @param color 颜色
 *  @param size  指定尺寸
 *
 *  @return 创建后的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

/**
 *  通过颜色创建图片
 *
 *  @param color 颜色
 *
 *  @return 创建后的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  转换图片中指定区域的图片
 *
 *  @param image     原图
 *  @param rect      指定区域
 *  @param transform 转换量
 *
 *  @return 转换后的图片
 */
+ (UIImage*)imageFromImage:(UIImage*)image inRect:(CGRect)rect transform:(CGAffineTransform)transform{
    CGSize newSize=rect.size;
    UIGraphicsBeginImageContext(newSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, newSize.width / 2, newSize.height / 2);
    CGContextConcatCTM(context, transform);
    CGContextTranslateCTM(context, newSize.width / -2, newSize.height / -2);
    CGContextSetFillColorWithColor(context,
                                   [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    
    [image drawInRect:CGRectMake(rect.origin.x, rect.origin.y, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
