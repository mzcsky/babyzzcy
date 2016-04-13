//
//  QingZiController.m
//  SaiSai
//
//  Created by 葛新伟 on 15/12/1.
//  Copyright © 2015年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiController.h"
#import "QingZiCell.h"

@interface QingZiController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, strong) UIScrollView * Adscroll;

@property (nonatomic, strong) UITableView * tabw;

@property (nonatomic, strong) NSArray * dataArr;
@end

@implementation QingZiController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.TheadView.hidden = NO;
}




- (void)viewDidLoad{
    [super viewDidLoad];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.zzcyer.com"]];
    [_webView loadRequest:request];
    
}


@end
