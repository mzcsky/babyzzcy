//
//  NDDataPicker.m
//  YunShop
//
//  Created by weige on 15/7/14.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "NDDataPicker.h"

@interface NDDataPicker ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) UIPickerView  *picker;

@end

@implementation NDDataPicker

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//        [button addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
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
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.height-266, SCREEN_WIDTH, 266)];
    self.picker.backgroundColor = [UIColor whiteColor];
    self.picker.delegate = self;
    [self addSubview:self.picker];
}

- (void)cancleAction{
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(cancelSelect)]) {
        [_delegate cancelSelect];
    }
}

- (void)sureAction{
    int index = (int)[self.picker selectedRowInComponent:0];
    if (index>=self.datas.count || self.datas.count==0) {
        [self removeFromSuperview];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(dataDidSelected:index:)]) {
        [_delegate dataDidSelected:[self.datas objectAtIndex:index] index:index+1];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(dataDidSelected:index:picker:)]) {
        [_delegate dataDidSelected:[self.datas objectAtIndex:index] index:index+1 picker:self];
    }
    [self removeFromSuperview];
}

- (void)reloadData{
    [self.picker reloadAllComponents];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.datas && [self.datas isKindOfClass:[NSArray class]]) {
        return self.datas.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.datas && [self.datas isKindOfClass:[NSArray class]]) {
        return [self.datas objectAtIndex:row];
    }
    return @"未知";
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    if (self.datas && [self.datas isKindOfClass:[NSArray class]]) {
        label.text = [self.datas objectAtIndex:row];
    }
    label.font = FONT(15);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
