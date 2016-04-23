//
//  QingZiShowController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/20.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiShowController.h"
#import "QingZiShowCell.h"

#define CellHeight lunViewHeight+60
@interface QingZiShowController ()<UITableViewDelegate, UITableViewDataSource, QingZiShowCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataValueArr;
@property (nonatomic, strong) NSArray * plistArr;
@property (nonatomic, strong) UIView * NaviBarView;


@end

@implementation QingZiShowController{
    NSInteger     QZpage;
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
    [rootCtrller setmTabBarViewHidden:YES animation:YES];
    self.TheadView.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self initHeaderView];
    [self initTableView];

    [self plistArr];

//    [self getDataValue];
}








//返回按钮
- (void)initHeaderView{
    _NaviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    _NaviBarView.backgroundColor = [UIColor redColor];
    
    UIButton *Navbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Navbtn.frame = CGRectMake(15, 10, 20, 27);
    [Navbtn setImage:[self imageAutomaticName:@"arrowBack@2x.png"] forState:UIControlStateNormal];
    [Navbtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    CGFloat searchBtnW = (SCREEN_WIDTH - Navbtn.width-15)/4;
    CGFloat searchBtnH = _NaviBarView.height;
    
    NSArray *searchArr = [[NSArray alloc] init];
    searchArr = @[@"分类",@"全城",@"年龄",@"评价"];
    
    for (int i = 0 ; i < 4; i++) {
        
        CGFloat searchBtnX = (Navbtn.width+15)+(searchBtnW)*i;
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        searchBtn.frame = CGRectMake(searchBtnX, 0, searchBtnW, searchBtnH);
        [searchBtn setTitle:searchArr[i] forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        searchBtn.tag = i;
        searchBtn.titleLabel.font = FONT(13);
        
        [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_NaviBarView addSubview:searchBtn];
        
    }
    
    [_NaviBarView addSubview:Navbtn];
    
    [self.view addSubview:_NaviBarView];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initdata{
    QZpage = 1;
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,_NaviBarView.bottom , SCREEN_WIDTH, 35)];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.alpha = 0.5f;
    
    
    CGFloat headerBtnW = SCREEN_WIDTH/3;
    CGFloat headerBtnH = headerView.height;
    
    NSArray *headetBtnArr = [[NSArray alloc]init];
    headetBtnArr = @[@"距离",@"2016-03-13",@"天数"];
    
    for (int i = 0 ; i < 3; i++) {
        CGFloat headerBtnX =(headerView.frame.origin.x)+headerBtnW*i;
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.frame =CGRectMake(headerBtnX, 0, headerBtnW, headerBtnH);
        [headerBtn setTitle:headetBtnArr[i] forState:UIControlStateNormal];
        [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        headerBtn.backgroundColor = [UIColor redColor];
        headerBtn.tag = i;
        
        [headerView addSubview:headerBtn];
    }
    
    [self.view addSubview:headerView];

    
}




#pragma mark ===============演出展览数据请求==================
//- (void)getDataValue{
//    NSDictionary *pram = [HttpBody PrivilegeCheckBox:(int)QZpage rows:10 datavalue:(int)self.model.datavalue];
//    
//    [ProgressHUD show:LOADING];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager GET:URL_Button parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
//    
//    
//    }];
//}













#pragma mark ===============UITableViewDataSource===============
//设置表格的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//设置每个组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _plistArr.count;
}

//设置单元格显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlistModel * Pmodel = [_plistArr objectAtIndex:indexPath.row];

    QingZiShowCell *cell = [QingZiShowCell valueWithTableView:tableView indexPath:indexPath];
    cell.delegate = self;
    cell.Pmodel = Pmodel;
   
    return cell;
}

#pragma mark =============== UITableViewDelegate代理方法===============
//设置每行Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}


- (NSArray *)plistArr{
    
    if (!_plistArr) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QingZiPist" ofType:@"plist"];
        NSArray * plitArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        NSMutableArray * tempArr = [NSMutableArray array];
        for (NSDictionary * dic in plitArr) {
            PlistModel * model = [PlistModel valueWithDic:dic];
            
            [tempArr addObject:model];
            
        }
        
        _plistArr = tempArr;
        [self.tableView reloadData];
    }
    
    return _plistArr;
}


//图片自适应方法
- (UIImage *)imageAutomaticName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    // 计算缩放率 - 3.0f是5.5寸屏的屏密度
    double scale = 3.0f / (SCREEN_WIDTH/414.f);
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
}

- (void)btnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnClick:(UIButton *)searchSender{

    NSLog(@"%ld",(long)searchSender.tag);
}

- (void)headerBtnClick:(UIButton *)headerSender{
    NSLog(@"%ld",(long)headerSender.tag);
}

@end
