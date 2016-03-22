//
//  HotCityCell.m
//  SaiSai
//
//  Created by weige on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "HotCityCell.h"

@interface HotCityCell ()

@property (nonatomic, retain) NSArray       *array;

@end

@implementation HotCityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
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

- (void)clearView{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
}

-(void)setData:(NSArray *)array{
    [self clearView];
    self.array = array;
    CGFloat width = (SCREEN_WIDTH-59)/3;
    for (int i = 0; i<array.count; i++) {
        CityBean *bean = [array objectAtIndex:i];
        int col = i%3;
        int row = i/3;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:UIColorFromRGB(0x202020) forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(13);
        btn.tag = i;
        btn.frame = CGRectMake(15+col*(width+7), 7+43*row, width, 36);
        [btn setTitle:bean.city_name forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)btnAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    CityBean *bean = [self.array objectAtIndex:btn.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseCity:)]) {
        [_delegate chooseCity:bean];
    }
}

@end
