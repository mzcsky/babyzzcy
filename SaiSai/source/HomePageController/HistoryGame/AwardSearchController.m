//
//  AwardSearchController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/22.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "AwardSearchController.h"
#import "HomePageCell.h"
#import "AgeBean.h"
#import "AttendOrFansBean.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "AwardLevelBean.h"
#import "HttpBody.h"
@interface AwardSearchController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, HomePageCellDelegate>

@property (nonatomic,strong) NDHMenuView      *ndMenuView;
@property (nonatomic,assign) NSInteger         ndMenuIndex;
@property (nonatomic,strong) UITableView      *tableView;
@property (nonatomic,strong) NSMutableArray   *menuArray;
 @end

@implementation AwardSearchController{
    UITableView       *_AStableView;
    NSMutableArray    *_ASdataArray;
    UISearchBar       *_ASsearchBar;
    int               _ASpage;


}
-(id)initWithInfo:(NSDictionary*)info{
    if (self = [super init]) {
        self.requestInfo = info;
    }
    return self;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ASrefreshDataA) name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ASrefreshCountDataA) name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESHCOUNTDATA object:nil];
}
- (void)dealloc{
    [self removeNotification];
}


- (void)initTableView{
    _AStableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _AStableView.backgroundColor = CLEARCOLOR;
    _AStableView.dataSource = self;
    _AStableView.delegate = self;
    _AStableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_AStableView];
    
    _ASsearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _ASsearchBar.backgroundColor = CLEARCOLOR;
    _ASsearchBar.delegate = self;
    [self.view addSubview:_ASsearchBar];
    
    [_AStableView addFooterWithTarget:self action:@selector(ASloadMoreDataA)];
    
    
}

- (void)ASrefreshDataA{
    _ASpage = 1;
    [self getDataArrPage:1 andCount:[PAGE_COUNT intValue]];
}
/*
 *加载更多
 */
- (void)ASloadMoreDataA{
    _ASpage++;
    [self getDataArrPage:_ASpage andCount:[PAGE_COUNT intValue]];
}
/**
 *    网络调用失败  页数－1
 */

-(void)ASreducePage{
    _ASpage--;
    if (_ASpage <= 0) {
        _ASpage = 1;
    }
}
/*
 *刷新当前页面
 */
-(void)ASrefreshCountDataA{
    int count = _ASpage * [PAGE_COUNT intValue];
    [self getDataArrPage:1 andCount:count];
}


//
-(void)getDataArrPage:(int)page andCount:(int)count{
    NSString *searchStr = _ASsearchBar.text;
    if (!searchStr && [searchStr isEqualToString:@""]) {
        return;
    }
    

    AwardLevelBean *bean = _menuArray[_ndMenuIndex];
    int awardId = [bean.mId intValue];
    int uId = -1;
    if ([[UserModel shareInfo] isLogin]) {
        uId = [[UserModel shareInfo] uid];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *paraDic = [HttpBody applyListBody:page rows:count fage:-1 eage:-1 uid:uId isMy:-1 gid:5 isaward:-1 awardconfigId:awardId keyword:searchStr];

    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_AStableView headerEndRefreshing];
        [_AStableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求获奖作品数据结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
            if (page == 1){
                if (_ASdataArray && _ASdataArray.count > 0) {
                    [_ASdataArray removeAllObjects];
                    _ASdataArray = nil;
                }
                _ASdataArray = [[NSMutableArray alloc] init];
            }
            if (dataArr && dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i++) {
                    SaiBean *bean = [SaiBean parseInfo:dataArr[i]];
                    
                    if (bean.applySubArr && [bean.applySubArr isKindOfClass:[NSArray class]] && bean.applySubArr.count >0) {
                        [_ASdataArray addObject:bean];
                    }
                }
            }
            if (dataArr.count<[PAGE_COUNT integerValue]) {
                [_AStableView setFooterHidden:YES];
            }else{
                [_AStableView setFooterHidden:NO];
            }
            [_AStableView reloadData];
            
            [ProgressHUD dismiss];
        }
        else{
            
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
            [self ASreducePage];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        [_AStableView headerEndRefreshing];
        [_AStableView footerEndRefreshing];
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
    SaiBean *commentBean = (SaiBean *)_ASdataArray[indexPath.row];
    [cell setCellInfo:commentBean];
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ASdataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCell *cell = [[HomePageCell alloc] init];
    SaiBean *saibean = (SaiBean *)_ASdataArray[indexPath.row];
    CGFloat height = [cell returnHeight:saibean];
    return height;
}

#pragma mark
#pragma mark ===================== UIScrollView delegate ==================
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_ASsearchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *str = _ASsearchBar.text;
    if (!str && [str isEqualToString:@""]) {
        return;
    }
    [_ASsearchBar resignFirstResponder];
    // 调用接口
    [self ASrefreshDataA];
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
    [self ASrefreshDataA];
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
            [self ASrefreshCountDataA];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}
//显示大图
- (void)showBigPics:(SaiBean *)bean{
    NSInteger count = bean.applySubArr.count;
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSDictionary *dict = [bean.applySubArr objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.size = CGSizeMake(300, 300);
        
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic_url"]]];
        photo.srcImageView = imgView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = photos; // 设置所有的图片
    browser.currentPhotoIndex = 0;
    [browser show];
}

//显示更多
-(void)showMoreComment:(SaiBean *)bean{
    bean.isShowMore = !bean.isShowMore;
    
    [_AStableView reloadData];
    
}


@end
