//
//  MatchWorkController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/25.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "MatchWorkController.h"
#import "HomePageCell.h"
#import "AgeBean.h"
#import "AttendOrFansBean.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface MatchWorkController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,HomePageCellDelegate>
@property (nonatomic,strong) NDHMenuView      *ndMenuView;
@property (nonatomic,strong) UITableView      *tableView;
@end

@implementation MatchWorkController{
    UITableView       *_MWtableView;
    NSMutableArray    *_MWdataArray;
    UISearchBar       *_MWsearchBar;
    int               _MWpage;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self initTableView];    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MWrefreshDatas) name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MWrefreshCountData) name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESHCOUNTDATA object:nil];
}
- (void)dealloc{
    [self removeNotification];
}


- (void)initTableView{
    _MWtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    _MWtableView.backgroundColor = CLEARCOLOR;
    _MWtableView.dataSource = self;
    _MWtableView.delegate = self;
    _MWtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_MWtableView];
    
    
    
    
    _MWsearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _MWsearchBar.backgroundColor = CLEARCOLOR;
    _MWsearchBar.delegate = self;
    [self.view addSubview:_MWsearchBar];
    
    [_MWtableView addFooterWithTarget:self action:@selector(MWloadMore)];
    
    
}

/**
 *  刷新数据
 */
-(void)MWrefreshDatas{
    _MWpage = 1;
    [self searchFriendsWithCurPage:1 count:[PAGE_COUNT intValue]];
}

/**
 *  加载更多
 */
-(void)MWloadMore{
    if ([_MWsearchBar.text isEqualToString:@""]) {
        return;
    }
    _MWpage++;
    [self searchFriendsWithCurPage:_MWpage count:[PAGE_COUNT intValue]];
}

/**
 *  刷新到当前页
 */
-(void)MWrefreshCountData{
    int count = _MWpage * [PAGE_COUNT intValue];
    [self searchFriendsWithCurPage:1 count:count];
}

/**
 *  网络调用失败 页数－1
 */
-(void)MWreducePage{
    _MWpage--;
    if (_MWpage <= 0) {
        _MWpage = 1;
    }
}

-(void)searchFriendsWithCurPage:(int)page count:(int)count{
    NSString *searchStr = _MWsearchBar.text;
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
        [_MWtableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"===========请求搜索作品数据结果========:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
            if (page == 1) {
                if (_MWdataArray && _MWdataArray.count > 0) {
                    [_MWdataArray removeAllObjects];
                    _MWdataArray = nil;
                }
                _MWdataArray = [[NSMutableArray alloc] init];
            }
            
            if (dataArr && dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i++) {
                    SaiBean *bean = [SaiBean parseInfo:dataArr[i]];
                    if (bean.applySubArr && [bean.applySubArr isKindOfClass:[NSArray class]]
                        && bean.applySubArr.count > 0) {
                        [_MWdataArray addObject:bean];
                    }
                }
            }
            if (dataArr.count < [PAGE_COUNT intValue]) {
                _MWtableView.footerHidden =YES;
            }
            else{
                _MWtableView.footerHidden = NO;
            }
            [_MWtableView reloadData];
            
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
            [self MWreducePage];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        
        [_MWtableView footerEndRefreshing];
    }];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = HomePageCellIdentifier;
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[HomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.oTView.contrller = self;
    cell.delegate = self;
    SaiBean *commentBean = (SaiBean *)_MWdataArray[indexPath.row];
    [cell setCellInfo:commentBean];
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _MWdataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCell *cell = [[HomePageCell alloc] init];
    SaiBean *saibean = (SaiBean *)_MWdataArray[indexPath.row];
    CGFloat height = [cell returnHeight:saibean];
    return height;
}

#pragma mark
#pragma mark ===================== UIScrollView delegate ==================
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_MWsearchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *str = _MWsearchBar.text;
    if (!str && [str isEqualToString:@""]) {
        return;
    }
    [_MWsearchBar resignFirstResponder];
    // 调用接口
    [self MWrefreshDatas];
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
    [self MWrefreshDatas];
}

#pragma mark
#pragma mark =============== MyAttendCell delegate =================
/**
 *  取消关注  或者 关注接口    attention 0：未关注 1：已关注   status 1 关注  2取消关注
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
            [self MWrefreshCountData];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}


@end
