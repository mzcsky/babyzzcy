//
//  ProductButtonView.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/26.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "ProductButtonView.h"
@interface ProductButtonView ()

@end
@implementation ProductButtonView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
    }
    return self;
}
- (void)initData{

    
    
    NSArray *arr =@[@"基本信息",@"详细介绍",@"咨询",@"评价"];

    for (int i = 0; i < arr.count; i++) {
       UIButton * PBbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        PBbtn.backgroundColor = [UIColor whiteColor];
        PBbtn.tag = i;
        [PBbtn setTitle:arr[i] forState:UIControlStateNormal];
        [PBbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGFloat btnW = SCREEN_WIDTH/4;
        PBbtn.titleLabel.font = FONT(11);
        CGFloat btnX = btnW*i;
        PBbtn.frame = CGRectMake(btnX, 0, btnW, 40);
        [PBbtn addTarget:self action:@selector(PBbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:PBbtn];
        
        
        if (i==0) {
            _currentBtn = PBbtn;
            [self PBbtnClick:PBbtn];
        }
    }
    
}
-(void)PBbtnClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(PBbtnViewClickSender:)]) {
        [self.delegate PBbtnViewClickSender:sender];
    }

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
