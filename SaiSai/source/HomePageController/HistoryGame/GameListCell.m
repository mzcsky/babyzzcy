
//
//  GameListCell.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/7.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "GameListCell.h"
#import "UIImageView+WebCache.h"

@implementation GameListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = CLEARCOLOR;
        _cView = [[UIView alloc] initWithFrame:CGRectMake(10, 2, SCREEN_WIDTH-20, GAMELISTHEIGHT-2)];
        _cView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_cView];
        [self initImageView];
        [self initThemeLabel];
        [self initNameLabel];
        [self initContentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initImageView{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, GAMELISTHEIGHT/2-40, 78, 78)];
    _imageView.backgroundColor = BACKGROUND_COLOR;
    [_cView addSubview:_imageView];
}

-(void)initThemeLabel{
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 5, SCREEN_WIDTH-138, 15)];
    _themeLabel.backgroundColor = CLEARCOLOR;
    _themeLabel.font = Bold_FONT(14.0f);
    _themeLabel.textAlignment = NSTextAlignmentLeft;
    _themeLabel.textColor = XT_BLACKCOLOR;
    [_cView addSubview:_themeLabel];
}

- (void)initNameLabel{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 30,80, 15)];
    _nameLabel.backgroundColor = XT_MAINCOLOR;
    _nameLabel.font = Bold_FONT(15.0f);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor whiteColor];
    [_cView addSubview:_nameLabel];
}

- (void)initContentLabel{
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 50, SCREEN_WIDTH-138, 45)];
    _contentLabel.backgroundColor = CLEARCOLOR;
    _contentLabel.font = FONT(10.0f);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.contentMode = UIViewContentModeTop;
    _contentLabel.numberOfLines = 0;
    [_cView addSubview:_contentLabel];
}


#pragma mark
#pragma mark ====== 设置数据 ======
- (void)setInfo:(SaiBean *)bean andTheme:(NSString *)theme{
    _themeLabel.text = theme;
    if (bean != nil && [bean isKindOfClass:[SaiBean class]]) {
        [_imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bean.applySubUrl]] placeholderImage:[UIImage imageNamed:@"ic_default_head_image"]];
        [_nameLabel setText:[NSString stringWithFormat:@"%i",bean.award_level]];
        [_contentLabel setText:bean.pic_desc];
    }
}

@end
