//
//  SearchFriendController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "SearchFriendController.h"
#import "MyFansCell.h"

@interface SearchFriendController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MyFansCellDelegate>

@property (nonatomic,strong) UITableView     *tableView;
@property (nonatomic,strong) NSMutableArray  *dataArray;
@property (nonatomic,strong) UISearchBar     *searchBar;
@property (nonatomic,assign) int              currentPage;

@end

@implementation SearchFriendController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _searchBar.backgroundColor = CLEARCOLOR;
    _searchBar.delegate = self;
    _tableView.tableHeaderView = _searchBar;
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshDatas)];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
}

/**
 *  刷新数据
 */
-(void)refreshDatas{
    _currentPage = 1;
    [self searchFriendsWithCurPage:1 count:[PAGE_COUNT intValue]];
}

/**
 *  加载更多
 */
-(void)loadMore{
    _currentPage++;
    [self searchFriendsWithCurPage:_currentPage count:[PAGE_COUNT intValue]];
}

/**
 *  刷新到当前页
 */
-(void)refreshCountData{
    int count = _currentPage * [PAGE_COUNT intValue];
    [self searchFriendsWithCurPage:1 count:count];
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

-(void)searchFriendsWithCurPage:(int)page count:(int)count{
    NSString *searchStr = _searchBar.text;
    if (!searchStr && [searchStr isEqualToString:@""]) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *paraDic = [HttpBody searchMember:[[UserModel shareInfo] uid] page:page rows:count keyword:searchStr];
    
    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求搜索好友结果:%@",jsonDic);
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
    static NSString *cellIndentifier = MyFansCellIdentifier;
    MyFansCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[MyFansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.delegate = self;
    [cell setCellInfo:_dataArray[indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark
#pragma mark ===================== UIScrollView delegate ==================
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *str = _searchBar.text;
    if (!str && [str isEqualToString:@""]) {
        return;
    }
    [_searchBar resignFirstResponder];
    // 调用接口
    [self refreshDatas];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (!searchText || [searchText isEqualToString:@""]) {
        return;
    }
    //调用接口
    [self refreshDatas];
}

#pragma mark
#pragma mark =============== MyAttendCell delegate =================
/**
 *  取消关注  或者 关注接口    //attention 0：未关注 1：已关注   status 1 关注  2取消关注
 */
-(void)cancelOrAttend:(AttendOrFansBean *)bean{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    int status = 0;
    if (bean.attention == 0) {
        status = 1;
    }
    else{
        status = 2;
    }
    
    NSDictionary *parm = [HttpBody attendOrCancelAttendWithUId:[[UserModel shareInfo] uid] bId:[bean.afId intValue] status:status];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求关注或者取消关注结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            [self refreshCountData];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

@end
