//
//  SettingCell.h
//  PurchaseManager
//
//  Created by weige on 15/5/5.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXAlertView.h"

#define SETTINGCELL_HEIGHT1     66
#define SETTINGCELL_HEIGHT2     52

@interface SettingCell : UITableViewCell<UITextFieldDelegate>{
    UILabel         *_nameLabel;
    UIImageView     *_header;
    
    UILabel         *_contentLabel;
    
    UIImageView     *_arrow;
}
@property (nonatomic, retain) PXAlertView   *alertView;

#pragma mark
#pragma mark ====== 设置 ======

/**
 *  设置默认位置
 *
 *  @param index 默认位置
 *
 *  @since 2015-05-05
 */
- (void)setIndex:(int)index;

/**
 *  设置名称
 *
 *  @param name 名称
 *
 *  @since 2015-05-05
 */
- (void)setName:(NSString *)name;

/**
 *  设置内容
 *
 *  @param content 内容
 */
- (void)setContent:(NSString *)content;

/**
 *  是否修改手机号码
 *
 *  @param edit
 *
 *  @since 2015-06-04
 */
- (void)setEditPhone:(BOOL)edit;

/**
 *  设置头像
 *
 *  @param header 头像
 *  @param show   是否显示
 *
 *  @since 2015-05-05
 */
- (void)setHeader:(NSString *)header isShow:(BOOL)show;
@end
