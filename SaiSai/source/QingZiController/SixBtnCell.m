//
//  SixBtnCell.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/15.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "SixBtnCell.h"


@interface SixBtnCell ()

@property (nonatomic, strong) NSArray * btnArr;
@property (nonatomic, strong) NSArray * titleArr;


@end

@implementation SixBtnCell

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"艺术课堂",@"演出展览",@"出游日期",@"拉客的看",@"我去欧文",@"配需机构"];
    }
    return _titleArr;
}
+ (instancetype)valueWithTableView:(UITableView *)tableView{
    
    static NSString * cellID = @"SixBtnCell";
    
    SixBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    
    if (!cell) {
        cell = [[SixBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createBtn];
    }
    
    return self;
}
- (void)createBtn{
    
    NSMutableArray * buttonArr = [NSMutableArray array];
    for (int i = 0; i < self.titleArr.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"download_img"] forState:UIControlStateNormal];
        btn.tag = i;
        
        [buttonArr addObject:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:btn];
    }
    
    self.btnArr = buttonArr;
}

- (void)btnClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(pushViewWithIndex:andTitle:)]) {
        [self.delegate pushViewWithIndex:sender.tag andTitle:sender.currentTitle];
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    for (UIButton * btn in self.btnArr) {
        
        CGFloat btnW = (SCREEN_WIDTH - btnCount*2*kMargic)/btnCount;
        CGFloat btnX = kMargic + (btnW+kMargic*2)*(btn.tag%btnCount);
        CGFloat btnH = btnW;
        CGFloat btnY = kMargic + (btnH+kMargic)*(btn.tag/btnCount);
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }
    
}
@end
