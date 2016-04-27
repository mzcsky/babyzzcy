//
//  ProductDetailsController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/26.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "ProductDetailsController.h"
#import "ProductDetailsCell.h"
#import "ProductDetailsImageCell.h"
#import "ProductButtonView.h"
#import "QingZiController.h"
#import "ActivityDetailController.h"
@interface ProductDetailsController ()<UITableViewDelegate, UITableViewDataSource, ProductDetailsCellDelegate, ProductDetailsImageCellDelegate, ProductButtonViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) ProductButtonView * PBView;


@property (nonatomic, strong) UIScrollView * adimagescroll;
@property (nonatomic, strong) NSMutableArray * imageArr;
@property (nonatomic, strong) UIView * BtnView;


@end

@implementation ProductDetailsController

- (void)viewWillAppear:(BOOL)animated{
    XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
    [rootCtrller setmTabBarViewHidden:YES animation:YES];
    self.TheadView.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClick addTarget:self action:@selector(btnClickBlock) forControlEvents:UIControlEventTouchUpInside];
    btnClick.frame = CGRectMake(20, 20, 40, 40);
    btnClick.backgroundColor = [UIColor blueColor];
    
    [_tableView addSubview:btnClick];
    [self.view addSubview:_tableView];
    
}

- (void)btnClickBlock{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark ==============UITableViewDataSource===========
//设置表格的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//设置每个组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section==0) ? 1 : 20;
}
#pragma mark ==============UITableViewDelegate=============
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return lunViewHeight;
    }else{
        return 80;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section==0 ) {
        ProductDetailsImageCell *cell = [ProductDetailsImageCell valueWithTableView:tableView imageArr:_imageArr];
        self.adimagescroll = cell.imagescroll;
        self.adimagescroll.delegate = self;
        cell.delegate = self;
        
        return cell;
        
          }
    else {
        ProductDetailsCell * cell = [ProductDetailsCell valueWithTableView:tableView indexPath:indexPath];
        cell.delegate = self;
              
              
            return cell;
          }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==1) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_PBView == nil) {
        if (!_PBView) {
            _PBView = [[ProductButtonView alloc] init];
            _PBView.delegate = self;
        }
    }
    return _PBView;
}

-(void)PBbtnViewClickSender:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag == 0) {
        NSLog(@"跳");
    }else if (sender.tag == 1) {
        NSLog(@"水");
    }else if (sender.tag == 2){
        NSLog(@"冠");
    }else{
        NSLog(@"军");
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClicksender:(UIButton *)sender{
    QingZiController *QZVC = [[QingZiController alloc] init];
    [self.navigationController popToViewController:QZVC animated:YES];
}



@end
