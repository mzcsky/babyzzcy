//
//  SegmentViewController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/16.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "SegmentViewController.h"


#define BASIC_TAG 88888


@implementation SegmentViewController

- (void)dealloc{
    btnArray = nil;
    self.selectedBackgoundColor = nil;
    self.normalBackgroundColor = nil;
    self.selectedTextColor = nil;
    self.normalTextColor = nil;
    self.borderColor = nil;
    self.delegate = nil;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        int count = titles.count;
        btnArray = [[NSMutableArray alloc]init];
        _selectedIndex = 0;
        
        float btnWidth = (frame.size.width*1.0)/count;
        for (int i = 0; i < count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, frame.size.height);
            btn.tag = BASIC_TAG+i;
            
            
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:MIN(14, frame.size.height - 4)];
            
            [btn addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btnArray addObject:btn];
        }
        [self updateLayout];
    }
    return self;
}


- (void)setSelectedIndex:(int)selectedIndex{
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        for (int i = 0; i < btnArray.count; i++) {
            UIButton *btn = [btnArray objectAtIndex:i];
            if ( i == selectedIndex) {
                btn.backgroundColor = self.selectedBackgoundColor;
                [btn setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
            }else{
                btn.backgroundColor = self.normalBackgroundColor;
                [btn setTitleColor:self.normalTextColor forState:UIControlStateNormal];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentSelected:)]) {
            [self.delegate segmentSelected:selectedIndex];
        }
    }
}

- (void)updateLayout{
    for (UIButton *btn in btnArray) {
        btn.layer.borderColor = self.borderColor.CGColor;
        btn.layer.borderWidth = 1;
    }
    for (int i = 0; i < btnArray.count; i++) {
        UIButton *btn = [btnArray objectAtIndex:i];
        if (i == _selectedIndex) {
            btn.backgroundColor = self.selectedBackgoundColor;
            [btn setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = self.normalBackgroundColor;
            [btn setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        }
    }

}

- (UIButton *)segmentAtIndex:(int)index{
    if ([btnArray count] > index) {
        return [btnArray objectAtIndex:index];
    }
    return nil;
}

- (void)segmentSelected:(UIButton *)btn{
    int index = btn.tag - BASIC_TAG;
    self.selectedIndex = index;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
