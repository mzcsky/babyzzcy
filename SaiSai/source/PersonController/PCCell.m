//
//  PCCell.m
//  SaiSai
//
//  Created by weige on 15/8/31.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "PCCell.h"

@implementation PCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initIcon];
        [self initNameLabel];
        
        UIImage *image2 = [UIImage imageNamed:@"pc_arrow_r.png"];
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-image2.size.width, (46-image2.size.height)/2, image2.size.width, image2.size.height)];
        [arrow setImage:image2];
        [self.contentView addSubview:arrow];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
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

- (void)initIcon{
    UIImage *image = [UIImage imageNamed:@"pc_setting.png"];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, (40-image.size.height)/2, image.size.width, image.size.height)];
    [_imageView setImage:image];
    [self.contentView addSubview:_imageView];
}

- (void)initNameLabel{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-105, 40)];
    _nameLabel.backgroundColor = CLEARCOLOR;
    _nameLabel.font = FONT(15);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
}

- (void)setIcon:(NSString *)icon{
    UIImage *image = [UIImage imageNamed:icon];
    [_imageView setImage:image];
}

- (void)setName:(NSString *)name{
    [_nameLabel setText:name];
}

@end
