//
//  UIImage+UIImage.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/6/2.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "UIImage+UIImage.h"

@implementation UIImage (UIImage)
+ (UIImage *)imageWithUrlStr:(NSString *)urlStr{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];

    UIImage *image = [UIImage imageWithData:data];

    return image;
}




@end
