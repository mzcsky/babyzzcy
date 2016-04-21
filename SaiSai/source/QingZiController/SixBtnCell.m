//
//  SixBtnCell.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/15.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "SixBtnCell.h"
@interface SixBtnCell ()

@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSArray * btnArr;
@property (nonatomic, strong) NSArray * dataArr;

@end

@implementation SixBtnCell



+ (instancetype)valueWithTableView:(UITableView *)tableView dataArr:(NSArray *)dataArr{
    
    static NSString * cellID = @"SixBtnCell";
    
    SixBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    
    if (!cell) {
        cell = [[SixBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.dataArr = dataArr;
    
    if (dataArr.count && !cell.btnArr) {
        [cell createBtn];
    }
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}
- (void)createBtn{
    
    NSMutableArray * buttonArr = [NSMutableArray array];
    for (int i = 0; i < self.dataArr.count; i ++) {
        
        QingZiBean *bena = [_dataArr objectAtIndex:i];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:bena.content forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:bena.descr]]] forState:UIControlStateNormal];
        btn.tag = i;
        
        [buttonArr addObject:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:btn];
    }
    
    self.btnArr = buttonArr;
}

- (void)btnClick:(UIButton *)sender{
    
    QingZiBean *bena = [_dataArr objectAtIndex:sender.tag];
    if ([self.delegate respondsToSelector:@selector(pushViewWithIndex:andModel:)]) {
        [self.delegate pushViewWithIndex:sender.tag andModel:bena];
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
