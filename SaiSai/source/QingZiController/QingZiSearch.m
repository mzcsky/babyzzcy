//
//  QingZiSearch.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/19.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiSearch.h"
#import "HomePageCell.h"
#import "AgeBean.h"
#import "AttendOrFansBean.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface QingZiSearch ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,HomePageCellDelegate>
@property (nonatomic,strong) NDHMenuView      *ndMenuView;
@property (nonatomic,strong) UITableView      *tableView;

@end

@implementation QingZiSearch
{

UITableView       *_QZtableView;
NSMutableArray    *_QZdataArray;
UISearchBar       *_QZsearchBar;
int               _QZpage;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self initTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QZrefreshDatas) name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QZrefreshCountData) name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESHCOUNTDATA object:nil];
}
- (void)dealloc{
    [self removeNotification];
}


- (void)initTableView{
    _QZtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    _QZtableView.backgroundColor = CLEARCOLOR;
    _QZtableView.dataSource = self;
    _QZtableView.delegate = self;
    _QZtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_QZtableView];
    
    _QZsearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _QZsearchBar.backgroundColor = CLEARCOLOR;
    _QZsearchBar.delegate = self;
    [self.view addSubview:_QZsearchBar];
    
    [_QZtableView addFooterWithTarget:self action:@selector(QZloadMore)];
    
    
}

/**
 *  刷新数据
 */
-(void)QZrefreshDatas{
    _QZpage = 1;
    [self searchFriendsWithCurPage:1 count:[PAGE_COUNT intValue]];
}

/**
 *  加载更多
 */
-(void)QZloadMore{
    if ([_QZsearchBar.text isEqualToString:@""]) {
        return;
    }
    _QZpage++;
    [self searchFriendsWithCurPage:_QZpage count:[PAGE_COUNT intValue]];
}

/**
 *  刷新到当前页
 */
-(void)QZrefreshCountData{
    int count = _QZpage * [PAGE_COUNT intValue];
    [self searchFriendsWithCurPage:1 count:count];
}

/**
 *  网络调用失败 页数－1
 */
-(void)QZreducePage{
    _QZpage--;
    if (_QZpage <= 0) {
        _QZpage = 1;
        
    }
}
/**
 *  搜索作品请求
 *
 *  @param page
 *  @param count
 */
-(void)searchFriendsWithCurPage:(int)page count:(int)count{
    NSString *searchStr = _QZsearchBar.text;
    if (!searchStr && [searchStr isEqualToString:@""]) {
        return;
    }
    
    int uId = -1;
    if ([[UserModel shareInfo] isLogin]) {
        uId = [[UserModel shareInfo] uid];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *paraDic = [HttpBody applyListBody:page rows:count fage:-1 eage:-1 uid:uId isMy:-1
                                                gid:-1 isaward:-1 awardconfigId:-1 keyword:searchStr];
    
    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_QZtableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"===========请求搜索作品数据结果========:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
            if (page == 1) {
                if (_QZdataArray && _QZdataArray.count > 0) {
                    [_QZdataArray removeAllObjects];
                    _QZdataArray = nil;
                }
                _QZdataArray = [[NSMutableArray alloc] init];
            }
            
            if (dataArr && dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i++) {
                    SaiBean *bean = [SaiBean parseInfo:dataArr[i]];
                    if (bean.applySubArr && [bean.applySubArr isKindOfClass:[NSArray class]]
                        && bean.applySubArr.count > 0) {
                        [_QZdataArray addObject:bean];
                    }
                }
            }
            if (dataArr.count < [PAGE_COUNT intValue]) {
                _QZtableView.footerHidden =YES;
            }
            else{
                _QZtableView.footerHidden = NO;
            }
            [_QZtableView reloadData];
            
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
            [self QZreducePage];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        
        [_QZtableView footerEndRefreshing];
    }];
    
    
}


#pragma mark =================TableViewCell delegate=============
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = HomePageCellIdentifier;
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[HomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.oTView.contrller = self;
    cell.delegate = self;
    SaiBean *commentBean = (SaiBean *)_QZdataArray[indexPath.row];
    [cell setCellInfo:commentBean];
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _QZdataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCell *cell = [[HomePageCell alloc] init];
    SaiBean *saibean = (SaiBean *)_QZdataArray[indexPath.row];
    CGFloat height = [cell returnHeight:saibean];
    return height;
}

#pragma mark
#pragma mark ===================== UIScrollView delegate ==================
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_QZsearchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *str = _QZsearchBar.text;
    if (!str && [str isEqualToString:@""]) {
        return;
    }
    [_QZsearchBar resignFirstResponder];
    // 调用接口
    [self QZrefreshDatas];
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
    [self QZrefreshDatas];
    
    
}

#pragma mark
#pragma mark =============== MyAttendCell delegate =================

/**
 *  取消关注或者关注接口
 *
 *  @param beanattention 0：未关注 1：已关注   status 1 关注  2取消关注
 */
-(void)attentionClick:(SaiBean *)bean{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    int status = 0;
    if ([bean.attention isEqualToString:@"0"]) {
        status = 1;
    }
    else{
        status = 2;
    }
    
    NSDictionary *parm = [HttpBody attendOrCancelAttendWithUId:[[UserModel shareInfo] uid] bId:[bean.uId intValue] status:status];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求关注或者取消关注结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            [self QZrefreshCountData];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}



@end
