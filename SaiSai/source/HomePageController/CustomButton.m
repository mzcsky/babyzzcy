//
//  CustomButton.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/7.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画大圆并填充颜
    UIColor*aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:0.3];
    
    /*画扇形和椭圆*/
    //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
    aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.3];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    //以10为半径围绕圆心画指定角度扇形
    //X,Y
    CGContextMoveToPoint(context, self.width  , 0);
    CGContextAddArc(context, self.width , 0,
                    self.width,  180 * PI / 180, 90 * PI / 180, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
}


@end
