//
//  DVersionView.m
//  YunShop
//
//  Created by weige on 15/7/29.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "DVersionView.h"

@implementation DVersionView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BACKGROUND_COLOR;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        headerView.backgroundColor = XT_MAINCOLOR;
        [self addSubview:headerView];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 20, 80, 44);
        _backBtn.backgroundColor = CLEARCOLOR;
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = FONT(14);
        [_backBtn addTarget:self action:@selector(dismissDV) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:_backBtn];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _titleLabel.backgroundColor = CLEARCOLOR;
        _titleLabel.text = @"新版本下载";
        _titleLabel.font = FONT(16);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:_titleLabel];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.backgroundColor = BACKGROUND_COLOR;
        [self addSubview:_webView];
        
        
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH/2-0.5, 50);
        _cancleBtn.backgroundColor = XT_MAINCOLOR;
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = FONT(15);
        [self addSubview:_cancleBtn];
        _cancleBtn.hidden = YES;
        [_cancleBtn addTarget:self action:@selector(dismissDV) forControlEvents:UIControlEventTouchUpInside];
        
        _comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _comfirmBtn.frame = CGRectMake(SCREEN_WIDTH/2+0.5, SCREEN_HEIGHT-50, SCREEN_WIDTH/2-0.5, 50);
        _comfirmBtn.backgroundColor = XT_MAINCOLOR;
        [_comfirmBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comfirmBtn.titleLabel.font = FONT(15);
        [self addSubview:_comfirmBtn];
        _comfirmBtn.hidden = YES;
        [_comfirmBtn addTarget:self action:@selector(comfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    [_titleLabel setText:title];
}

- (void)dismissDV{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)loadUrl:(NSString *)url{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
}

//登陆页用
- (void)loadUrlForLogin:(NSString *)url{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    _webView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
    
    _cancleBtn.hidden = NO;
    _comfirmBtn.hidden = NO;
}

- (void)loadText:(NSString *)text{
    [_webView loadHTMLString:text baseURL:nil];
}

- (void)showAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)comfirmAction{
    if (_delegate && [_delegate respondsToSelector:@selector(comfirmUserProtocal)]) {
        [_delegate comfirmUserProtocal];
    }
}

@end
