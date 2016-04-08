//
//  MySaiSaiController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MySaiSaiController.h"
#import "AttendOrFansBean.h"

@interface MySaiSaiController ()<HomePageCellDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,assign) int               currentPage;

@end

@implementation MySaiSaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    
    [self addNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(id)initWithUserId:(int)userid bOrAid:(int)boraid {
    if (self = [super init]) {
        self.uid = userid;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
//    [self refreshCountData];
}


-(void)dealloc{
    [self removeNotification];
}

/**
 *  添加刷新通知
 */
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCountData) name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESHCOUNTDATA object:nil];
}

/**
 *  初始化tableview  40+64+49
 */
-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshDatas)];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    
 //   _currentPage = 1;
    
    [self refreshDatas];
}

/**
 *  刷新数据
 */
-(void)refreshDatas{
    _currentPage = 1;
    [self getDataArrWithCurPage:1 andCount:[PAGE_COUNT intValue]];
}

/**
 *  加载更多
 */
-(void)loadMore{
    _currentPage++;
    [self getDataArrWithCurPage:_currentPage andCount:[PAGE_COUNT intValue]];
}

/**
 *  刷新到当前页
 */
-(void) refreshCountData{
    int count = _currentPage * [PAGE_COUNT intValue];
    [self getDataArrWithCurPage:1 andCount:count];
}

/**
 *  网络调用失败 页数－1
 */
-(void)reducePage{
    _currentPage--;
    if (_currentPage <= 0) {
        _currentPage = 1;
    }
}

/**
 *  获取参数作品数据
 */
    
-(void)getDataArrWithCurPage:(int)page andCount:(int)count{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        
        NSDictionary *paraDic = [HttpBody applyListBody:page rows:count fage:-1 eage:-1 uid:/*[[UserModel shareInfo] uid]*/self.uid   isMy:1 gid:-1 isaward:-1 awardconfigId:-1 keyword:@""];
        
        [ProgressHUD show:LOADING];
        
        [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            NSLog(@"请求获取我的参数作品数据结果:%@",jsonDic);
            if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
                NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
                if (page == 1) {
                    if (_dataArray && _dataArray.count > 0) {
                        [_dataArray removeAllObjects];
                        _dataArray = nil;
                    }
                    _dataArray = [[NSMutableArray alloc] init];
                }

                if (dataArr && dataArr.count > 0) {
                    for (int i = 0; i < dataArr.count; i++) {
                        SaiBean *bean = [SaiBean parseInfo:dataArr[i]];
                        [_dataArray addObject:bean];
                    }
                }
                if (dataArr.count < [PAGE_COUNT intValue]) {
                    _tableView.footerHidden = YES;
                }
                else{
                    _tableView.footerHidden = NO;
                }
                [_tableView reloadData];
                
                [ProgressHUD dismiss];
            }
            else{
                [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
                [self reducePage];
            }
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"failuer");
            [ProgressHUD showError:CHECKNET];
            
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
        }];
    }


#pragma mark
#pragma mark ==============UITableView dataSource and delegate ===============
//他的作品展
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = HomePageCellIdentifier;
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[HomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.oTView.contrller = self;
    cell.delegate = self;
    [cell setCellInfo:_dataArray[indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCell *cell = [[HomePageCell alloc] init];
    CGFloat height = [cell returnHeight:_dataArray[indexPath.row]];
    return height;
}




@end
