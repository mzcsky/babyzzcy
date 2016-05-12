//
//  MPMController.m
//  SaiSai
//
//  Created by weige on 15/9/5.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MJRefresh.h"
#import "MPMController.h"
#import "MatchCCell.h"
#import "MatchCCBean.h"
#import "MatchDetailController.h"

#define MPMCELL     @"MPMCELL"

@interface MPMController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView       *tableView;

@property (nonatomic, retain) NSMutableArray            *tArray;

@property (nonatomic, assign) NSInteger                 page;

@end

@implementation MPMController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initTableView];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithUserId:(int)userid{
    if (self = [super init]) {
        self.uid = userid;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initData{
    self.page = 1;
    self.tArray = [[NSMutableArray alloc] init];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[MatchCCell class] forCellReuseIdentifier:MPMCELL];
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}

#pragma mark
#pragma mark ====== UITableView delegate datasource ======

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
    MatchCCell *cell = [tableView dequeueReusableCellWithIdentifier:MPMCELL];
    if (!cell) {
        cell = [[MatchCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MPMCELL];
    }
    
    MatchCCBean *bean = [self.tArray objectAtIndex:indexPath.row];
    [cell setInfo:bean];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MatchCCBean *bean = [self.tArray objectAtIndex:indexPath.row];
    MatchDetailController *ctrl = [[MatchDetailController alloc] init];
    ctrl.title = bean.g_title;
    ctrl.m_showBackBt = YES;
    ctrl.fBean = bean;
    [self.navigationController pushViewController:ctrl animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}

#pragma mark
#pragma mark ====== 请求数据 ======

- (void)refreshData{
    self.page = 1;
    [self getData];
}

- (void)loadMoreData{
    self.page++;
    [self getData];
}

- (void)getData{
    NSDictionary *pram = [HttpBody getMyGamesList:/*[[UserModel shareInfo] uid]*/self.uid page:(int)self.page rows:[PAGE_COUNT intValue]];
    
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
            //请求成功
            NSDictionary *data = [resDict objectForKey:@"data"];
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
            if (self.page>1) {
                self.page--;
            }
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        if (self.page>1) {
            self.page--;
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}



@end
