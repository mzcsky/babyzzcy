//
//  CommentMsgController.m
//  SaiSai
//
//  Created by weige on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MJRefresh.h"
#import "CommentMsgController.h"
#import "CMCCell.h"
#import "CMCBean.h"

#define CMCCELL     @"CMCCELL"

@interface CommentMsgController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView       *tableView;

@property (nonatomic, assign) NSInteger         page;

@property (nonatomic, retain) NSMutableArray    *array;

@end

@implementation CommentMsgController

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
    self.array = [[NSMutableArray alloc] init];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerClass:[CMCCell class] forCellReuseIdentifier:CMCCELL];
    [self.view addSubview:_tableView];
}

#pragma mark
#pragma mark ====== UITableView delegate datasource ======

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CMCCELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CMCCell *cell = [tableView dequeueReusableCellWithIdentifier:CMCCELL];
    if (!cell) {
        cell = [[CMCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CMCCELL];
    }
    
    CMCBean *bean = [self.array objectAtIndex:indexPath.row];
    [cell setHeadIcon:bean.icon];
    [cell setName:bean.nick_name];
    [cell setTime:bean.addtime];
    [cell setComment:bean.connent];
    
    return cell;
}

- (void)getData{
//    NSDictionary *pram = [HttpBody getCommentList:[[UserModel shareInfo] uid] page:(int)self.page rows:[PAGE_COUNT intValue]];
    NSDictionary *pram = [HttpBody getCommentList:[[UserModel shareInfo] uid] page:(int)self.page rows:[PAGE_COUNT intValue]];

    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
//        NSLog(@"请求获取参赛主题列表接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            //请求成功
            NSDictionary *data = [resDict objectForKey:@"data"];
            //解析列表数据
            if (self.page == 1) {
                [self.array removeAllObjects];
            }
            
            NSArray *darray = [data objectForKey:@"data"];
            for (NSDictionary *dict in darray) {
                CMCBean *bean = [CMCBean analyseData:dict];
                [self.array addObject:bean];
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
