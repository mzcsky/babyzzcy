//
//  QingZiController.m
//  SaiSai
//
//  Created by 葛新伟 on 15/12/1.
//  Copyright © 2015年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiController.h"

@interface QingZiController ()

@property (nonatomic, strong) UIWebView     *webView;

@end

@implementation QingZiController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-64)];
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.zzcyer.com"]];
    [_webView loadRequest:request];
}

@end
