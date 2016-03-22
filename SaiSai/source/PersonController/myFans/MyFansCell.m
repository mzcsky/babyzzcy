//
//  MyFansCell.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MyFansCell.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"

@implementation MyFansCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        headImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
        headImg.backgroundColor = CLEARCOLOR;
        headImg.clipsToBounds = YES;
        headImg.layer.cornerRadius = 20.f;
        headImg.userInteractionEnabled = YES;
        [headImg sd_setImageWithURL:[NSURL URLWithString:[[UserModel shareInfo] icon]] placeholderImage:[UIImage imageNamed:@"ic_default_head_image.png"]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked)];
        
        [headImg addGestureRecognizer:singleTap];
        [self.contentView addSubview:headImg];
        
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 100, 20)];
        nameLab.backgroundColor = CLEARCOLOR;
        nameLab.textColor = XT_BLACKCOLOR;
        nameLab.font = FONT(14);
        [self.contentView addSubview:nameLab];
        
        attendOrCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attendOrCancelBtn.frame = CGRectMake(SCREEN_WIDTH-80, 10, 70, 30);
        [attendOrCancelBtn setBackgroundImage:[UIImage imageWithColor:LINECOLOR] forState:UIControlStateNormal];
        [attendOrCancelBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [attendOrCancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        attendOrCancelBtn.titleLabel.font = FONT(12);
        [attendOrCancelBtn addTarget:self action:@selector(attendOrCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:attendOrCancelBtn];
        
        UIImageView *breakImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50-1, SCREEN_WIDTH, 1)];
        breakImg.backgroundColor = BACKGROUND_COLOR;
        [self.contentView addSubview:breakImg];
    }
    return self;
}

-(void)setCellInfo:(AttendOrFansBean *)bean{
    aFBean = bean;
    [headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bean.icon]] placeholderImage:[UIImage imageNamed:@"ic_default_head_image"]];
    nameLab.text = bean.nickName;
    
    // 0：未关注 1：已关注
    if (bean.attention == 0) {
        [attendOrCancelBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    else if (bean.attention == 1){
        [attendOrCancelBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
}

-(void)attendOrCancelClick{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelOrAttend:)]) {
        [_delegate cancelOrAttend:aFBean];
    }
}
-(void)UesrClicked{
    if ([self.delegate respondsToSelector:@selector(UesrHeaderClickedfans:)]) {
        [self.delegate UesrHeaderClickedfans:aFBean];
    }
}

@end
