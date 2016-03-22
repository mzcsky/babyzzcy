//
//  UPImageCell.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/4.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "UPImageCell.h"
#import "UIImageView+WebCache.h"

@implementation UPImageCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
        [self.contentView addSubview:_imageView];
        
        _alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertBtn setBackgroundImage:[UIImage imageWithColor:XT_MAINCOLOR] forState:UIControlStateNormal];
        _alertBtn.frame = CGRectMake(10, 80, 58, 20);
        [_alertBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_alertBtn setTitleColor:XT_BLACKCOLOR forState:UIControlStateNormal];
        _alertBtn.titleLabel.font = FONT(13);
        [_alertBtn addTarget:self action:@selector(alertImg) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_alertBtn];
    }
    return self;
}

//点击修改图片
-(void)alertImg{
    if (_delegate && [_delegate respondsToSelector:@selector(upImageCellAlert:)]) {
        [_delegate upImageCellAlert:_indexPath];
    }
}

-(void)setImage:(UIImage *)image{
    [_imageView setImage:image];
}

- (void)setImageURL:(NSString *)url{
    if (!url) {
        url = @"";
    }
    [_imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] placeholderImage:[UIImage imageNamed:@"ic_default_head_image"]];
}

@end
