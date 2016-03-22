//
//  SettingViewCell.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SettingViewCellIdentifier  @"SettingViewCellIdentifier"
#define SettingViewCellHeight      40

@interface SettingViewCell : UITableViewCell
{
    UILabel *_nameLabel;
    UILabel *_dataLabel;
}

-(void)setCellName:(NSString *)nameStr andIsFirstRow:(BOOL)isFirst andDataStr:(NSString *)dataStr;

@end
