//
//  QingZiTitleScroll.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/15.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiTitleScroll.h"

#define margicX 10

@interface QingZiTitleScroll ()

@property (nonatomic, strong) NSArray * btnArr;


@end
@implementation QingZiTitleScroll

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr{

    if (self == [super initWithFrame:frame]) {
        
        
        NSMutableArray * totleArr = [NSMutableArray array];
        for (int i = 0; i < titleArr.count; i ++) {
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGFloat btnW = 100;
            CGFloat btnX = margicX + (btnW+margicX)*i;
            CGFloat btnY = margicX;
            CGFloat btnH = frame.size.height-btnY*2;
            
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            btn.layer.cornerRadius = 8;
            btn.clipsToBounds = YES;
            btn.layer.borderColor = [UIColor purpleColor].CGColor;
            btn.layer.borderWidth = 1;
            
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];

            btn.titleLabel.font = FONT(15);
            btn.tag = i;
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:btn];
            
            if (i==(titleArr.count-1)) {
                self.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame)+margicX, 0);
            }
            
            [totleArr addObject:btn];
        }
        self.btnArr = totleArr;
        
    }
    
    return self;
}
- (void)btnClick:(UIButton *)sender{

    sender.selected = YES;
    
    for (UIButton * btn in self.btnArr) {
        if (btn.tag!=sender.tag) {
            btn.selected = NO;
        }
    }
    if ([self.btnDelegate respondsToSelector:@selector(btnClickAtIndex:)]) {
        [self.btnDelegate btnClickAtIndex:sender.tag];
    }
}
@end
