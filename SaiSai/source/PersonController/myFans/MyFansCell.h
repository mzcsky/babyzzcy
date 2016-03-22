//
//  MyFansCell.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendOrFansBean.h"
@class MyFansCell;

#define MyFansCellIdentifier  @"MyFansCellIdentifier"
#define MyFansCellHeight      50@


@protocol MyFansCellDelegate <NSObject>
-(void)UesrHeaderClickedfans:(AttendOrFansBean*)bean;

/**
 *  添加或取消关注
 */
-(void)cancelOrAttend:(AttendOrFansBean *)bean;

@end

@interface MyFansCell : UITableViewCell
{
    UIImageView *headImg;
    UILabel    *nameLab;
    UIButton   *attendOrCancelBtn;
    
    AttendOrFansBean *aFBean;
}
@property (nonatomic,assign) id<MyFansCellDelegate> delegate;

-(void)setCellInfo:(AttendOrFansBean *)bean;

@end
