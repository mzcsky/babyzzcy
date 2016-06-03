//
//  UIImage+UIImage.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/6/2.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage)

+ (UIImage *)imageWithUrlStr:(NSString *)urlStr;
+ (NSData *)imageData:(UIImage *)myimage;

@end
