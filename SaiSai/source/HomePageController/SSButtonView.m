//
//  SSButtonView.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/16.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "SSButtonView.h"

@implementation SSButtonView{
    
    NSMutableArray * _buttonArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)rect TitleArray:(NSArray*)titleArray AndSelectIndex:(NSInteger)index AndBlock:(void(^)(NSInteger index))block{
    if (self = [super initWithFrame:rect]) {
        self.clickBlcok = block;
        self.backgroundColor = [UIColor whiteColor];
        _buttonArray = [NSMutableArray array];
        [self configUIWithTitleArray:titleArray AndIndex:index];
        
    }
    return self;
}

-(void)configUIWithTitleArray:(NSArray*)array AndIndex:(NSInteger)index{
    
    for (int i=0;i<array.count;i++) {
        UIButton * bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        bnt.frame = CGRectMake(i*(SCREEN_WIDTH/array.count), 0, SCREEN_WIDTH/array.count, 40);
        bnt.backgroundColor = [UIColor whiteColor];
        bnt.titleLabel.font = [UIFont systemFontOfSize:15.0];
        bnt.tag = i;
        [_buttonArray addObject:bnt];
        [bnt setTitle:array[i] forState:UIControlStateNormal];
        bnt.layer.borderWidth = 1.0;
        bnt.layer.borderColor =[UIColor lightGrayColor].CGColor;
        [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bnt addTarget:self action:@selector(bntClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bnt];
        
        //默认选中第一个
        
        UIButton * tempBnt = _buttonArray[0];
        [self bntClick:tempBnt];
    }
}

-(void)bntClick:(UIButton*)sender{
    
    for (UIButton * bnt in _buttonArray) {
        [bnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.clickBlcok(sender.tag);
    
    
}

@end
