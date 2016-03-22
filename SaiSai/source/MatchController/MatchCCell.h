//
//  MatchCCell.h
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchCCBean.h"

#define MATCHCCELL_HEIGHT       92

@interface MatchCCell : UITableViewCell{
    UIView          *_cView;
    UIImageView     *_imageView;
    UILabel         *_nameLabel;
    UILabel         *_contentLabel;
    UIImageView     *_typeImageView;
}

#pragma mark
#pragma mark ====== 设置数据 ======
- (void)setInfo:(MatchCCBean *)bean;

@end
