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
#import "ProductBasicCell.h"

@interface ProductDetailsController ()<UITableViewDelegate, UITableViewDataSource, ProductDetailsCellDelegate, ProductDetailsImageCellDelegate, ProductButtonViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) ProductButtonView * PBView;


@property (nonatomic, strong) UIScrollView * adimagescroll;
@property (nonatomic, strong) NSMutableArray * imageArr;
@property (nonatomic, strong) UIView * BtnView;

@property (nonatomic, strong) UILabel * labImg;
@property (nonatomic, strong) UIButton * sender;


@end

@implementation ProductDetailsController

- (void)viewWillAppear:(BOOL)animated{
    XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
    [rootCtrller setmTabBarViewHidden:YES animation:YES];
    self.TheadView.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initHeaderButton];
    [self initFooterButton];
    
}
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-69) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
}



- (void)initHeaderButton{
    UIButton *btnBlock = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBlock addTarget:self action:@selector(btnClickBlock) forControlEvents:UIControlEventTouchUpInside];
    [btnBlock setImage:[UIImage imageNamed:@"qingzi_block"] forState:UIControlStateNormal];
    btnBlock.frame = CGRectMake(14, 14, 35, 35);
    UIButton *btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCollect addTarget:self action:@selector(btnClickcollect) forControlEvents:UIControlEventTouchUpInside];
    [btnCollect setImage:[UIImage imageNamed:@"qingzi_shoucang"] forState:UIControlStateNormal];
    btnCollect.frame = CGRectMake(SCREEN_WIDTH-14-35, 14, 35, 35);
    
    UIView *labView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-14-45,lunViewHeight/1.5, 45, 45)];
    _labImg = [[UILabel alloc] init];
    labView.backgroundColor = [UIColor blackColor];
    labView.alpha = 0.4;
    _labImg.frame = CGRectMake(0, 0, 45, 45);
    _labImg.textColor = [UIColor whiteColor];
    _labImg.textAlignment = NSTextAlignmentCenter;
    _labImg.font = Bold_FONT(13);
    _labImg.text = @"1/1";
    labView.layer.cornerRadius = labView.width/2;
    [labView addSubview:_labImg];
    
    [_tableView addSubview:labView];
    [_tableView addSubview:btnCollect];
    [_tableView addSubview:btnBlock];

}
- (void)initFooterButton{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH,49)];
    
    CGFloat btnW = SCREEN_WIDTH/4;
    CGFloat btnH = footView.height;
    NSArray *btnarr = @[@"留言",@"分享",@"立即报名",@"我要拼团"];
    for (int i = 0; i < 4; i++) {
        CGFloat btnX = (btnW)*i;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:btnarr[i] forState:UIControlStateNormal];
        [btn setTitleColor:BACKGROUND_FENSE forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(btnX, 0, btnW, btnH);
        btn.tag = i;
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"qingzi_liuyan"] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-18, 0, 0, -23);
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.font = Bold_FONT(11);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0,-18 , -23,0);

        }
        else if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"Match_share"] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-18, 0, 0, -23);
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.font = Bold_FONT(11);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0,-21 , -23,0);

        }
      else  if (i == 2) {
            btn.backgroundColor = BACKGROUND_FENSE;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            btn.titleLabel.font = Bold_FONT(16);
        }
        else  {
            btn.backgroundColor = [UIColor colorWithRed:253/255.0 green:181/255.0 blue:78/255.0 alpha:1.0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            btn.titleLabel.font = Bold_FONT(18);

        }
        [btn addTarget:self action:@selector(btnFooterBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [footView addSubview:btn];
    
    
    }
    [self.view addSubview:footView];

}

#pragma mark ==============UITableViewDataSource===========
//设置表格的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_sender && _sender.tag == 0 ) {
        return 6;
    }
    return 2;
}

//设置每个组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_sender && _sender.tag == 0 ) {
        
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return 4;
                break;
            case 3:
                return 1;
                break;
            default:
                return 0;
                break;
        }
        
    }
    return (section == 0 )? 1:3;
}
#pragma mark ==============UITableViewDelegate=============
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return lunViewHeight;
    }else{
        return 40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_sender && _sender.tag == 0 ) {
        
        return (section==0) ? 0 : 20;
    }
    return 0;
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
        
        UITableViewCell * cell = nil;
//        ProductDetailsCell * cell = [ProductDetailsCell valueWithTableView:tableView indexPath:indexPath];
//        cell.delegate = self;
       if (_sender.tag ==0 ) {
        

            cell = [ProductBasicCell valueWithTableView:tableView indexPath:indexPath];
           
            cell.backgroundColor = [UIColor orangeColor];

        }else if (_sender.tag == 1){
            
            cell = [ProductDetailsCell valueWithTableView:tableView indexPath:indexPath];
            
            cell.backgroundColor = [UIColor yellowColor];

        }else if (_sender.tag == 2){
            cell = [ProductDetailsCell valueWithTableView:tableView indexPath:indexPath];

            cell.backgroundColor = [UIColor redColor];

        }
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
            self.sender = _PBView.currentBtn;
            [_tableView reloadData];
        }
    }
    return _PBView;
}

-(void)PBbtnViewClickSender:(UIButton *)sender{
    
    _sender = sender;
    
    if (sender.tag == 0) {
        NSLog(@"基本信息");
    }else if (sender.tag == 1) {
        NSLog(@"详细信息");
    }else if (sender.tag == 2){
        NSLog(@"咨询");
    }else{
        NSLog(@"评价");
    }
    [_tableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClicksender:(UIButton *)sender{
    QingZiController *QZVC = [[QingZiController alloc] init];
    [self.navigationController popToViewController:QZVC animated:YES];
}
- (void)btnClickBlock{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)btnClickcollect{
    NSLog(@"收藏");
}
- (void)btnFooterBtn:(UIButton *)Footsender{
    if (Footsender.tag == 0) {
        NSLog(@"留言");
    }else if (Footsender.tag == 1) {
        NSLog(@"分享");
    }else if (Footsender.tag == 2) {
        NSLog(@"立即报名");
    } else {
        NSLog(@"我要拼团");
    }
}
@end
