//
//  GameListController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/7.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "GameListController.h"
#import "GameListCell.h"

#define HistoryGameCell   @"GameListCell"

@interface GameListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView               *tableView;

@property (nonatomic, retain) NSMutableArray            *tArray;

@property (nonatomic, assign) NSInteger                 page;

@end

@implementation GameListController

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

- (void)initData{
    self.page = 1;
    self.tArray = [[NSMutableArray alloc] init];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[GameListCell class] forCellReuseIdentifier:HistoryGameCell];
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
    return GAMELISTHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GameListCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryGameCell];
    if (!cell) {
        cell = [[GameListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HistoryGameCell];
    }
    SaiBean *bean = [self.tArray objectAtIndex:indexPath.row];
    [cell setInfo:bean andTheme:_matchBean.g_title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SaiBean *bean = [self.tArray objectAtIndex:indexPath.row];

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
    NSDictionary *pram = [HttpBody applyListBody:(int)self.page rows:[PAGE_COUNT intValue] fage:-1 eage:-1 uid:-1 isMy:-1 gid:_matchBean.mId isaward:1 awardconfigId:-1 keyword:@""];
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求获取参赛主题作品列表接口结果:%@",resDict);
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
                SaiBean *bean = [SaiBean  parseInfo:dict];
                [self.tArray addObject:bean];
            }
            if (darray.count<[PAGE_COUNT intValue]) {
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
