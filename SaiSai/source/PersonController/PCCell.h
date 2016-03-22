//
//  PCCell.h
//  SaiSai
//
//  Created by weige on 15/8/31.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCell : UITableViewCell{
    UIImageView     *_imageView;
    UILabel         *_nameLabel;
}

- (void)setIcon:(NSString *)icon;

- (void)setName:(NSString *)name;

@end
