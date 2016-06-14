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



+(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>=10*1024) {
        if (data.length>100*1024) {//100k以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>50*1024) {//50-100k
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>20*1024) {//20-50k
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>10*1024) {//10-20k
            data=UIImageJPEGRepresentation(myimage, 0.8);
        }
    }
    return data;
}


@end
