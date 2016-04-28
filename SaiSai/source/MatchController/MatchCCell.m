//
//  MatchCCell.m
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MatchCCell.h"
#import "UIImageView+WebCache.h"

@implementation MatchCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = CLEARCOLOR;
        
        
        _cView = [[UIView alloc] initWithFrame:CGRectMake(10, 2, SCREEN_WIDTH-20, MATCHCCELL_HEIGHT-2)];
        _cView.backgroundColor = [UIColor whiteColor];
        UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, _cView.top-3, SCREEN_WIDTH, 2)];
        linView.backgroundColor = LINCOLOR;
        
        [_cView addSubview:linView];
        [self.contentView addSubview:_cView];
        [self initImageView];
        [self initNameLabel];
        [self initContentLabel];
        [self initTypeImageView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initImageView{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6, 78, 78)];
    _imageView.backgroundColor = BACKGROUND_COLOR;
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_cView addSubview:_imageView];
}

- (void)initNameLabel{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 15, SCREEN_WIDTH-138, 25)];
    _nameLabel.backgroundColor = CLEARCOLOR;
    _nameLabel.font = Bold_FONT(15.0f);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [_cView addSubview:_nameLabel];
}

- (void)initContentLabel{
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 42, SCREEN_WIDTH-138, 45)];
    _contentLabel.backgroundColor = CLEARCOLOR;
    _contentLabel.font = FONT(8.0f);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.numberOfLines = 0;
    [_cView addSubview:_contentLabel];
}

- (void)initTypeImageView{
    UIImage *image = [UIImage imageNamed:@"match_type1.png"];
    _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_cView.width-image.size.width, 0, image.size.width, image.size.height)];
    _typeImageView.backgroundColor = CLEARCOLOR;
    [_typeImageView setImage:image];
    [_cView addSubview:_typeImageView];
}

#pragma mark
#pragma mark ====== 设置数据 ======
- (void)setInfo:(MatchCCBean *)bean{
    if (bean != nil && [bean isKindOfClass:[MatchCCBean class]]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:bean.img]];
        [_nameLabel setText:bean.g_title];
        [_contentLabel setText:bean.g_desc];
        if (bean.isXG) {
            _typeImageView.hidden = YES;
            return;
        }
        _typeImageView.hidden = NO;
        switch (bean.status) {
            case 1:
            {
                //进行中
                UIImage *image = [UIImage imageNamed:@"match_type1.png"];
                [_typeImageView setImage:image];
            }
                break;
            case 2:
            {
                //评审中
                UIImage *image = [UIImage imageNamed:@"match_type2.png"];
                [_typeImageView setImage:image];
            }
                break;
            case 4:
            {
                //奖项发布
                UIImage *image = [UIImage imageNamed:@"match_type3.png"];
                [_typeImageView setImage:image];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
