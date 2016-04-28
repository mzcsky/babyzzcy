//
//  MyAttendController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MyAttendController.h"
#import "MyAttendCell.h"
#import "MyUsermsgViewController.h"
@interface MyAttendController ()<UITableViewDataSource,UITableViewDelegate,MyAttendCellDelegate>

@property (nonatomic,strong) UITableView          *tableView;
@property (nonatomic,strong) NSMutableArray      *dataArray;
@property (nonatomic,assign) int                 currentPage;

@end

@implementation MyAttendController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
\

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithUserId:(int)userid{
    if (self = [super init]) {
        self.uid = userid;
    
    }
    return self;
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
    
     [self refreshDatas];
    

    
}

/**
 *  刷新数据
 */
-(void)refreshDatas{
    _currentPage = 1;
    [self getAttendtionArrWithCurPage:1 andCount:[PAGE_COUNT intValue]];
}

/**
 *  加载更多
 */
-(void)loadMore{
    _currentPage++;
    [self getAttendtionArrWithCurPage:_currentPage andCount:[PAGE_COUNT intValue]];
}

/**
 *  刷新到当前页
 */
-(void) refreshCountData{
    int count = _currentPage * [PAGE_COUNT intValue];
    [self getAttendtionArrWithCurPage:1 andCount:count];
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
 *  获取我的关注列表
 */
-(void)getAttendtionArrWithCurPage:(int)page andCount:(int)count{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *paraDic = [HttpBody getMyAttendWithUId:/*[[UserModel shareInfo] uid]*/self.uid page:page rows:count];
    
    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//        NSLog(@"请求获取我的关注结果:%@",jsonDic);
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
                    AttendOrFansBean  *bean = [AttendOrFansBean parseInfo:dataArr[i]];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = MyAttendCellIdentifier;
    MyAttendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[MyAttendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.delegate = self;
    [cell setCellInfo:_dataArray[indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MyAttendCellHeight;
}

#pragma mark 
#pragma mark =============== MyAttendCell delegate =================
/**
 *  取消关注
 */
-(void)cancelAttend:(AttendOrFansBean *)bean{
    NSDictionary *parm = [HttpBody attendOrCancelAttendWithUId:[[UserModel shareInfo] uid] bId:[bean.bOrAId intValue] status:2];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求取消关注结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            [self refreshCountData];
        }
     
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
            [self refreshCountData ];

        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}





//进入已关注人界面
-(void)UesrHeaderClickedfollow:(AttendOrFansBean *)bean{
    MyUsermsgViewController * MUVC = [[MyUsermsgViewController alloc]initWithBean:bean];
    MUVC.title = bean.nickName;
    self.title = @"";
    [self.navigationController pushViewController:MUVC animated:YES];
}

@end
