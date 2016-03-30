//
//  MyAttendCell.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MyAttendCell.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

@implementation MyAttendCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        headImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
        headImg.backgroundColor = CLEARCOLOR;
        headImg.clipsToBounds = YES;
        headImg.layer.cornerRadius = 20.f;
        [headImg sd_setImageWithURL:[NSURL URLWithString:[[UserModel shareInfo] icon]] placeholderImage:[UIImage imageNamed:@"ic_default_head_image.png"]];
        headImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked)];
        
        [headImg addGestureRecognizer:singleTap];

  
        [self.contentView addSubview:headImg];
        
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 100, 20)];
        nameLab.backgroundColor = CLEARCOLOR;
        nameLab.textColor = XT_BLACKCOLOR;
        nameLab.font = FONT(14);
        [self.contentView addSubview:nameLab];
        
        cancelAttend = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelAttend.frame = CGRectMake(SCREEN_WIDTH-80, 12, 60, 25);
        [cancelAttend setBackgroundImage:[UIImage imageWithColor:LINECOLOR] forState:UIControlStateNormal];
        [cancelAttend setTitle:@"取消关注" forState:UIControlStateNormal];
        [cancelAttend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelAttend.titleLabel.font = FONT(12);
        [cancelAttend addTarget:self action:@selector(cancelAttendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelAttend];
        
        UIImageView *breakImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, MyAttendCellHeight-1, SCREEN_WIDTH, 1)];
        breakImg.backgroundColor = BACKGROUND_COLOR;
        [self.contentView addSubview:breakImg];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellInfo:(AttendOrFansBean *)bean{
    aFbean = bean;
    
    [headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bean.icon]] placeholderImage:[UIImage imageNamed:@"ic_default_head_image"]];
    nameLab.text = bean.nickName;
}

-(void)cancelAttendClick{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelAttend:)]) {
        [_delegate cancelAttend:aFbean];
    }
    
}


-(void)UesrClicked{
    if ([self.delegate respondsToSelector:@selector(UesrHeaderClickedfollow:)]) {
        [self.delegate UesrHeaderClickedfollow:aFbean];
    }
}

@end
