//
//  CMCCell.m
//  SaiSai
//
//  Created by weige on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "CMCCell.h"

@implementation CMCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initHeadIcon];
        [self initNameLabel];
        [self initCommentLabel];
        [self initTimeLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, SCREEN_WIDTH-30, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:line];
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

- (void)initHeadIcon{
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 52, 52)];
    _headIcon.layer.cornerRadius = 26;
    _headIcon.clipsToBounds = YES;
    _headIcon.backgroundColor = BACKGROUND_COLOR;
    [self.contentView addSubview:_headIcon];
}

- (void)initNameLabel{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 4, (SCREEN_WIDTH-92)/2, 20)];
    _nameLabel.backgroundColor = CLEARCOLOR;
    _nameLabel.font = Bold_FONT(15);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
}

- (void)initCommentLabel{
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 26, SCREEN_WIDTH-87, 30)];
    _commentLabel.backgroundColor = CLEARCOLOR;
    _commentLabel.numberOfLines = 0;
    _commentLabel.font = FONT(13);
    _commentLabel.textAlignment = NSTextAlignmentLeft;
    _commentLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_commentLabel];
}

- (void)initTimeLabel{
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+31, 4, (SCREEN_WIDTH-92)/2, 20)];
    _timeLabel.backgroundColor = CLEARCOLOR;
    _timeLabel.numberOfLines = 0;
    _timeLabel.font = FONT(13);
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];
}

/**
 *  设置头像
 *
 *  @param icon 头像地址
 */
- (void)setHeadIcon:(NSString *)icon{
    if (icon == nil) {
        icon = @"";
    }
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:icon]];
}

/**
 *  设置姓名
 *
 *  @param name 姓名
 */
- (void)setName:(NSString *)name{
    if (name == nil) {
        name = @"";
    }
    [_nameLabel setText:name];
}

/**
 *  设置时间
 *
 *  @param time 时间
 */
- (void)setTime:(NSString *)time{
    if (time == nil) {
        time = @"";
    }
    [_timeLabel setText:time];
}

/**
 *  设置评论
 *
 *  @param comment 评论
 */
- (void)setComment:(NSString *)comment{
    if (comment == nil) {
        comment = @"";
    }
    [_commentLabel setText:comment];
}

@end
