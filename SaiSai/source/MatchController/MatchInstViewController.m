//
//  MatchInstViewController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/21.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "MatchInstViewController.h"

@interface MatchInstViewController ()

@property (nonatomic, strong) UIWebView * webView;


@end

@implementation MatchInstViewController


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    label.backgroundColor = [UIColor whiteColor];
    label.alpha = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"机构学校合作申请";
    
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom, SCREEN_WIDTH, 1)];
    linView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton * popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popBtn.frame = CGRectMake(11,29, 38, 26);
    [popBtn setImage:[self imageAutomaticName:@"arrowBack@2x.png"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    _webView.backgroundColor = [UIColor whiteColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.saisaiapp.com/col.jsp?id=108"]];
    [_webView loadRequest:request];
    [self.view addSubview:label];
    [self.view addSubview:linView];
    [self.view addSubview:_webView];
    [self.view addSubview:popBtn];
 
    

    
}
- (UIImage *)imageAutomaticName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    // 计算缩放率 - 3.0f是5.5寸屏的屏密度
    double scale = 3.0f / (SCREEN_WIDTH/414.f);
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
}


/**
 *  返回按钮点击方法
 */
-(void)leftDrawerButtonPress:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
