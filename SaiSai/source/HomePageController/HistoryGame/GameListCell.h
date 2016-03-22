//
//  GameListCell.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/7.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiBean.h"
#define GAMELISTHEIGHT    102

@interface GameListCell : UITableViewCell
{
    UIView          *_cView;
    UIImageView     *_imageView;
    UILabel         *_themeLabel;
    UILabel         *_nameLabel;
    UILabel         *_contentLabel;
}

- (void)setInfo:(SaiBean *)bean andTheme:(NSString *)theme;

@end
