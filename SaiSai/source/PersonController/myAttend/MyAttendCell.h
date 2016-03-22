//
//  MyAttendCell.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendOrFansBean.h"
#import "SaiBean.h"
#import "UsermsgController.h"

#define MyAttendCellIdentifier  @"MyAttendCellIdentifier"
#define MyAttendCellHeight      50
@class MyAttendCell;

@protocol MyAttendCellDelegate <NSObject>
//点击头像跳转到个人资料
-(void)UesrHeaderClickedfollow:(AttendOrFansBean*)bean;

/**
 *  取消关注
 */
-(void)cancelAttend:(AttendOrFansBean *)bean;

@end

@interface MyAttendCell : UITableViewCell
{
    UIImageView *headImg;
    UILabel    *nameLab;
    UIButton   *cancelAttend;
    SaiBean    *saibean;
    AttendOrFansBean *aFbean;
}

@property (nonatomic,assign) id<MyAttendCellDelegate> delegate;

-(void)setCellInfo:(AttendOrFansBean *)bean;

@end
