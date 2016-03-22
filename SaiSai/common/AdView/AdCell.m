//
//  AdCell.m
//  SaleForIos
//
//  Created by weige on 15/3/7.
//
//

#import "AdCell.h"

@implementation AdCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initImageView];
    }
    return self;
}

- (void)initImageView{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
}

/**
 *  设置图片
 *
 *  @param path 图片网络路径
 *
 *  @since 2015-03-07
 */
- (void)setImage:(NSString *)path{
    if (path == nil) {
        path = @"";
    }
//    [_imageView setImageWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_ad.png"]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"pic_default.jpg"]];
}

@end
