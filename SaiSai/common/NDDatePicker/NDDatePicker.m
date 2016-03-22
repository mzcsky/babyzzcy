//
//  NDDatePicker.m
//  YunShop
//
//  Created by weige on 15/7/14.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "NDDatePicker.h"

@interface NDDatePicker ()

@property (nonatomic, retain) UIDatePicker  *picker;

@end

@implementation NDDatePicker

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [button addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-306, SCREEN_WIDTH, 306)];
        view.backgroundColor = BACKGROUND_COLOR;
        [self addSubview:view];
        
        [self initButtons];
        [self initPicker];
    }
    return self;
}

- (void)initButtons{
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.backgroundColor = [UIColor clearColor];
    cancleBtn.frame = CGRectMake(15, self.height-296, 40, 25);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancleBtn.layer.borderWidth = 0.5;
    [self addSubview:cancleBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor clearColor];
    sureBtn.frame = CGRectMake(SCREEN_WIDTH-55, self.height-296, 40, 25);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sureBtn.layer.borderWidth = 0.5;
    [self addSubview:sureBtn];
}

- (void)initPicker{
    self.picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.height-266, SCREEN_WIDTH, 266)];
    self.picker.maximumDate = [NSDate date];
    self.picker.datePickerMode = UIDatePickerModeDate;
    self.picker.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.picker];
}

-(void)setMaxDate:(NSDate *)maxDate{
    self.picker.maximumDate = maxDate;
}

-(void)setMinDate:(NSDate *)minDate{
    self.picker.minimumDate = minDate;
}

- (void)setDate:(NSDate *)date{
    self.picker.date = date;
}

- (void)setModel:(UIDatePickerMode)model{
    self.picker.datePickerMode = model;
}

- (void)cancleAction{
    [self removeFromSuperview];
}

- (void)sureAction{
    if (_delegate && [_delegate respondsToSelector:@selector(dateDidSelected:)]) {
        [_delegate dateDidSelected:self.picker.date];
    }
    [self removeFromSuperview];
}

@end
