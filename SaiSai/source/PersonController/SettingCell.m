//
//  SettingCell.m
//  PurchaseManager
//
//  Created by weige on 15/5/5.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "SettingCell.h"
#import "UIImageView+WebCache.h"
@implementation SettingCell
@synthesize alertView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initNameLabel];
        [self initContentLabel];
        [self initHeader];
        [self initArrow];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initNameLabel{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (self.frame.size.height-20-2)/2, 100, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = FONT(13.0f);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:_nameLabel];
}

- (void)initContentLabel{
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, (SETTINGCELL_HEIGHT2-20)/2, SCREEN_WIDTH-180, 20)];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = FONT(13.0f);
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_contentLabel];
}

- (void)initHeader{
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-43, (self.frame.size.height-43-2)/2, 43, 43)];
    _header.backgroundColor = [UIColor colorWithRed:194.0/255.0f green:194.0/255.0f blue:194.0/255.0f alpha:1];
    [self.contentView addSubview:_header];
    _header.layer.cornerRadius = 21.5;
    _header.clipsToBounds = YES;
    _header.hidden = YES;
}

- (void)initArrow{
    UIImage *image = [UIImage imageNamed:@"pc_arrow_r.png"];
    _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-image.size.width-20, (self.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
    [_arrow setImage:image];
    [self.contentView addSubview:_arrow];
}

- (void)createBg:(int)height{
    UIView *view = [self.contentView viewWithTag:1001];
    if (view) {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, height-2);
    }else{
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height-2)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 1001;
        [self.contentView insertSubview:view belowSubview:_nameLabel];
    }
    [self changeFrame:height];
}

- (void)changeFrame:(CGFloat)height{
    UIImage *image = [UIImage imageNamed:@"pc_arrow_r.png"];
    _nameLabel.frame = CGRectMake(20, (height-20-2)/2, 100, 20);
    _header.frame = CGRectMake(SCREEN_WIDTH-20-43, (height-43-2)/2, 43, 43);
    _arrow.frame = CGRectMake(SCREEN_WIDTH-image.size.width-20, (height-image.size.height)/2, image.size.width, image.size.height);
}

#pragma mark
#pragma mark ====== 设置 ======

/**
 *  设置默认位置
 *
 *  @param index 默认位置
 *
 *  @since 2015-05-05
 */
- (void)setIndex:(int)index{
    switch (index) {
        case 0:
        {
            [self createBg:SETTINGCELL_HEIGHT1];
        }
            break;
        case 1:
        {
            [self createBg:SETTINGCELL_HEIGHT2];
        }
            break;
        case 2:
        {
            [self createBg:SETTINGCELL_HEIGHT2];
        }
            break;
        case 3:
        {
            [self createBg:SETTINGCELL_HEIGHT2];
        }
            break;
            
        default:
        {
            [self createBg:SETTINGCELL_HEIGHT2];
        }
            break;
    }
}


/**
 *  设置名称
 *
 *  @param name 名称
 *
 *  @since 2015-05-05
 */
- (void)setName:(NSString *)name{
    if (name == nil) {
        name = @"";
    }
    [_nameLabel setText:name];
}

/**
 *  设置内容
 *
 *  @param content 内容
 */
- (void)setContent:(NSString *)content{
    if (content == nil) {
        content = @"";
    }
    [_contentLabel setText:content];
}

/**
 *  设置头像
 *
 *  @param header 头像
 *  @param show   是否显示
 *
 *  @since 2015-05-05
 */
- (void)setHeader:(NSString *)header isShow:(BOOL)show{
    if (!header) {
        header = @"";
    }
    _header.hidden = !show;
    _arrow.hidden = show;
    _contentLabel.hidden = show;
    [_header sd_setImageWithURL:[NSURL URLWithString:header]];
}

/**
 *  是否修改手机号码
 *
 *  @param edit
 *
 *  @since 2015-06-05
 */
- (void)setEditPhone:(BOOL)edit{
    [_arrow setImage:[UIImage imageNamed:@"pc_arrow_r.png"]];
}

// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //修改alert位置
    CGPoint center = self.alertView.center;
    center.y = SCREEN_HEIGHT/2 - 100;
    self.alertView.center = center;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //修改alert位置
    CGPoint center = self.alertView.center;
    center.y = SCREEN_HEIGHT/2;
    self.alertView.center = center;
}

-(void)dealloc{
    if (self.alertView) {
        self.alertView = nil;
    }
}

@end
