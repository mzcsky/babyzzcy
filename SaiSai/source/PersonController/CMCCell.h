//
//  CMCCell.h
//  SaiSai
//
//  Created by weige on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CMCCELL_HEIGHT      60

@interface CMCCell : UITableViewCell{
    UIImageView     *_headIcon;
    UILabel         *_nameLabel;
    UILabel         *_commentLabel;
    UILabel         *_timeLabel;
}

/**
 *  设置头像
 *
 *  @param icon 头像地址
 */
- (void)setHeadIcon:(NSString *)icon;

/**
 *  设置姓名
 *
 *  @param name 姓名
 */
- (void)setName:(NSString *)name;

/**
 *  设置时间
 *
 *  @param time 时间
 */
- (void)setTime:(NSString *)time;

/**
 *  设置评论
 *
 *  @param comment 评论
 */
- (void)setComment:(NSString *)comment;

@end
