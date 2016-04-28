//
//  MatchController.m
//  SaiSai
//
//  Created by weige on 15/8/15.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MyNavButton.h"
#import "NDHMenuView.h"
#import "MJRefresh.h"
#import "MatchController.h"
#import "AdvertView.h"
#import "MatchCCell.h"
#import "MatchCADBean.h"
#import "MatchCCBean.h"
#import "MatchDetailController.h"
#import "MatchClaBean.h"
#import "HistoryGameController.h"

#define MATCHCELL       @"MATCHCELL"
@interface MatchController ()<UITableViewDataSource, UITableViewDelegate, AdvertViewDelegate, NDHMenuViewDelegate>

@property (nonatomic, retain) UITableView       *tableView;

@property (nonatomic, retain) AdvertView        *adView;

@property (nonatomic, strong) UIView            *sectionHeader;
@property (nonatomic, strong) NDHMenuView       *ndMenuView;

@property (nonatomic, retain) NSMutableArray            *adArray;
@property (nonatomic, retain) NSMutableArray            *adSArray;

@property (nonatomic, retain) NSMutableArray            *tArray;

@property (nonatomic, strong) NSMutableArray            *claArray;
@property (nonatomic, strong) NSMutableArray            *claNames;

@property (nonatomic, assign) NSInteger                 page;

@property (nonatomic, assign) NSInteger                 projId;

@end

@implementation MatchController

- (void)viewDidLoad{
    [super viewDidLoad];
    if ([[UserModel shareInfo] isLogin]) {
        //登录后初始化页面
        [self initData];
        [self initTableView];
        [self getData];
        [self getDetail];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_TAB" object:nil];
    self.TheadView.hidden = NO;
}

- (void)showGold{
    HistoryGameController *ctrller = [[HistoryGameController alloc] init];
    ctrller.m_showBackBt = YES;
    ctrller.title = @"金奖主题";
    [self.navigationController pushViewController:ctrller animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}



- (void)initData{
    self.page = 1;
    self.projId = 0;
    self.adArray = [[NSMutableArray alloc] init];
    self.adSArray = [[NSMutableArray alloc] init];
    self.tArray = [[NSMutableArray alloc] init];
    self.claArray = [[NSMutableArray alloc] init];
    self.claNames = [[NSMutableArray alloc] init];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[MatchCCell class] forCellReuseIdentifier:MATCHCELL];
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

- (void)initAdView{
    if (self.adView == nil) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lunViewHeight)];
        contentView.backgroundColor = CLEARCOLOR;
        _tableView.tableHeaderView = contentView;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lunViewHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:bgView];
        
        self.adView = [[AdvertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lunViewHeight) delegate:self withImageArr:self.adSArray];
        [bgView addSubview:self.adView];
    }
}

#pragma mark
#pragma mark ====== AdvertViewDelegate ======
- (void)didSelectIndex:(NSInteger)index{
    if (!self.adArray || self.adArray.count==0) {
        return;
    }
    if (index<0) {
        index = 0;
    }
    if (index>=self.adArray.count) {
        index = self.adArray.count-1;
    }
    MatchCCBean *bean = [self.adArray objectAtIndex:index];

    MatchDetailController *ctrl = [[MatchDetailController alloc] init];
    ctrl.adSArray = [NSArray arrayWithArray:self.adSArray];
    ctrl.adArray = [NSArray arrayWithArray:self.adArray];
    ctrl.title = @"详情";
    ctrl.m_showBackBt = YES;
    ctrl.fBean = bean;
    [self.navigationController pushViewController:ctrl animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}

#pragma mark
#pragma mark ====== UITableView delegate && datasource ======

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 39;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!_ndMenuView) {
        _sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _sectionHeader.backgroundColor = CLEARCOLOR;
        _ndMenuView = [[NDHMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
        _ndMenuView.backgroundColor = [UIColor whiteColor];
        _ndMenuView.delegate = self;
        
        UIView *lintop = [[UIView alloc] initWithFrame:CGRectMake(0,_ndMenuView.top+1 , SCREEN_WIDTH, 1)];
        lintop.backgroundColor = [UIColor lightGrayColor];
        [_ndMenuView addSubview:lintop];
//        UIView *linbottom = [[UIView alloc] initWithFrame:CGRectMake(0, _ndMenuView.bottom+1, SCREEN_WIDTH, 1)];
//        linbottom.backgroundColor = [UIColor lightGrayColor];
//        [_ndMenuView addSubview:linbottom];
        
        [_sectionHeader addSubview:_ndMenuView];
    }
    
    if (_claNames && _claNames.count>0) {
        [_ndMenuView setTitles:_claNames];
    }
    
    return _sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tArray) {
        return self.tArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MATCHCCELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MatchCCell *cell = [tableView dequeueReusableCellWithIdentifier:MATCHCELL];
    if (!cell) {
        cell = [[MatchCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MATCHCELL];
    }
    
    MatchCCBean *bean = [self.tArray objectAtIndex:indexPath.row];
    [cell setInfo:bean];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MatchCCBean *bean = [self.tArray objectAtIndex:indexPath.row];
    MatchDetailController *ctrl = [[MatchDetailController alloc] init];
    ctrl.adSArray = [NSArray arrayWithArray:self.adSArray];
    ctrl.adArray = [NSArray arrayWithArray:self.adArray];
    ctrl.title = bean.g_title;
    ctrl.m_showBackBt = YES;
    ctrl.fBean = bean;
    [self.navigationController pushViewController:ctrl animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}

#pragma mark
#pragma mark ====== 获取数据 ======

- (void)getData{
    NSDictionary *pram = [HttpBody gameListBody:(int)self.page rows:[PAGE_COUNT intValue] status:-1 projectid:(int)_projId];
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//        NSLog(@"请求获取参赛主题列表接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            NSDictionary *data = [resDict objectForKey:@"data"];
            if (self.claArray != nil && self.claArray.count>0) {

            }else{
                //主题无数据
                [_claArray removeAllObjects];
                [_claNames removeAllObjects];
                NSArray *claArray = [data objectForKey:@"projectdata"];
                
                MatchClaBean *maBean = [[MatchClaBean alloc] init];
                maBean.mID = @"0";
                maBean.name = @"全部";
                [_claArray addObject:maBean];
                [_claNames addObject:maBean.name];
                for (NSDictionary *claDict in claArray) {
                    MatchClaBean *bean = [MatchClaBean analyseData:claDict];
                    [_claArray addObject:bean];
                    [_claNames addObject:bean.name];
                }
                //初始化
                if (_ndMenuView) {
                    [_ndMenuView setTitles:self.claNames];
                }
            }
            
            //解析列表数据
            if (self.page == 1) {
                [self.tArray removeAllObjects];
            }
            NSArray *darray = [data objectForKey:@"data"];
            for (NSDictionary *dict in darray) {
                MatchCCBean *bean = [MatchCCBean analyseData:dict];
                [self.tArray addObject:bean];
            }
            if (darray.count<10) {
                [_tableView setFooterHidden:YES];
            }else{
                [_tableView setFooterHidden:NO];
            }
            
            [_tableView reloadData];
            [ProgressHUD dismiss];
        }else{
            //数据请求失败
            self.page--;
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

#pragma mark - 补充详情数据请求（还可以优化）
- (void)getDetail{
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:KGetRecommendList parameters:@{} success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//        NSLog(@"=============================请求获取参赛主题列表接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            NSDictionary *data = [resDict objectForKey:@"data"];
            //请求成功
            //解析轮播数据
            [self.adArray removeAllObjects];
            [self.adSArray removeAllObjects];
            if (self.adArray != nil && self.adArray.count>0) {
                //轮播已有数据，不作处理
            }else{
                //轮播无数据
                NSArray *adArray = [data objectForKey:@"recommend"];
                for (NSDictionary *dict in adArray) {
                    MatchCCBean *bean = [MatchCCBean analyseData:dict];
                    
                    [self.adArray addObject:bean];
                    [self.adSArray addObject:bean.img];
                }
                [self initAdView];
            }
            
            [_tableView reloadData];
            [ProgressHUD dismiss];
        }else{
          //  数据请求失败
            self.page--;
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

- (void)refreshData{
    self.page = 1;
    [self getData];
}

- (void)loadMoreData{
    self.page++;
    [self getData];
}

#pragma mark
#pragma mark ====== NDHMenuViewDelegate ======
/**
 *  菜单栏选中
 *
 *  @param index 选中位置
 *
 *  @since 2015-05-30
 */
- (void)menuDidSelected:(int)index{
    MatchClaBean *bean = [_claArray objectAtIndex:index];
    _projId = [bean.mID intValue];
    CGFloat currentY = _tableView.contentOffset.y;
    if (currentY >lunViewHeight) {
        _tableView.contentOffset = CGPointMake(0, lunViewHeight);
    }
    [self refreshData];
}

@end
