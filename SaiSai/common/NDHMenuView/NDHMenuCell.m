//
//  NDHMenuCell.m
//  PurchaseManager
//
//  Created by weige on 15/5/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "NDHMenuCell.h"

#define sliderHerght 3
@implementation NDHMenuCell
//切换选择条
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initLabel];
    }
    return self;
}

- (void)initLabel{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    _imageView.backgroundColor = XT_MAINCOLOR;
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = 1.0f;
    [self.contentView addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = TabbarNTitleColor;
    _label.font = FONT(14);
    
    [self.contentView addSubview:_label];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _imageView.frame = CGRectMake(0,36, self.frame.size.width, self.frame.size.height);
}

#pragma mark
#pragma mark ====== 设置 ======
/**
 *  设置标题
 *
 *  @param title 标题
 *
 *  @since 2015-05-30
 */
- (void)setTitle:(NSString *)title{
    if (!title) {
        title = @"";
    }
    
    [_label setText:title];
}

/**
 *  设置是否选中
 *
 *  @param isSel 是否选中
 *
 *  @since 2015-05-30
 */
- (void)setTitleSelect:(BOOL)isSel{
    if (isSel) {
        _label.textColor = self.selColor;
        _label.font = [UIFont systemFontOfSize:15.0f];
    }else{
        _label.textColor = XT_BLACKCOLOR;
        _label.font = [UIFont systemFontOfSize:14.0f];
    }
    [self showSlider:isSel];
}

/**
 *  是否显示滑动条
 *
 *  @param isShow 是否显示
 */
- (void)showSlider:(BOOL)isShow{
  //  _imageView.hidden = !isShow;
    if (isShow) {
       _imageView.backgroundColor = XT_MAINCOLOR;
    }
    else{
        _imageView.backgroundColor = UIColorFromRGB(0xf7f8f9);
    }
}

@end
