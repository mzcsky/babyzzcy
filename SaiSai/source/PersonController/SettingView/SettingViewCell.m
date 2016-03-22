//
//  SettingViewCell.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initNameLabel];
        [self initDataLabel];
        
        UIImage *image2 = [UIImage imageNamed:@"pc_arrow_r.png"];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-image2.size.width, (40-image2.size.height)/2, image2.size.width, image2.size.height)];
        [arrow setImage:image2];
        [self.contentView addSubview:arrow];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = LINECOLOR;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)initNameLabel{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-100, 39.5)];
    _nameLabel.backgroundColor = CLEARCOLOR;
    _nameLabel.font = FONT(15);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
}

-(void)initDataLabel{
    _dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, 10, 55,20)];
    _dataLabel.backgroundColor = CLEARCOLOR;
    _dataLabel.font = FONT(15);
    _dataLabel.textAlignment = NSTextAlignmentRight;
    _dataLabel.textColor = XT_BLACKCOLOR;
    [self.contentView addSubview:_dataLabel];
}

-(void)setCellName:(NSString *)nameStr andIsFirstRow:(BOOL)isFirst andDataStr:(NSString *)dataStr{
    _nameLabel.text = nameStr;
    if (isFirst) {
        _dataLabel.hidden = NO;
        _dataLabel.text = dataStr;
    }
    else{
        _dataLabel.hidden = YES;
    }
}

@end
