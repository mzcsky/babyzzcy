//
//  AwardGameController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/8.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "AwardGameController.h"
#import "HomePageCell.h"
#import "AwardLevelBean.h"
#import "AwardSearchController.h"


@interface AwardGameController ()<UITableViewDataSource,UITableViewDelegate,NDHMenuViewDelegate,HomePageCellDelegate>

@property (nonatomic,strong) UITableView      *tableView;
@property (nonatomic,strong) NSMutableArray   *dataArray;
@property (nonatomic,strong) NDHMenuView      *ndMenuView;
@property (nonatomic,strong) NSMutableArray   *menuArray;
@property (nonatomic,assign) NSInteger        ndMenuIndex;
@property (nonatomic,assign) int              page;
@end

@implementation AwardGameController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNotification];
    [self initRightItem];
    [self initMenuView];
    [self initTableView];
    XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
    [rootCtrller setmTabBarViewHidden:YES animation:YES];
    self.view.backgroundColor = [UIColor whiteColor];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self removeNotification];
    
}
- (void)showGoldAward{

    NSNumber *mid = [NSNumber numberWithInteger:self.matchBean.mId];
    AwardSearchController *ctrller = [[AwardSearchController alloc] initWithInfo:@{@"mid":mid}];
    ctrller.m_showBackBt = YES;
    ctrller.title = @"获奖作品搜索";
    [self.navigationController pushViewController:ctrller animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}
- (void)initRightItem{
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 8, 40, 40);
    [rightItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightItem setImage:[UIImage imageNamed:@"ic_search.png"] forState:UIControlStateNormal];
    [rightItem setTitleColor:TabbarNTitleColor forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(showGoldAward) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem =rightBar;
}

-(void)initMenuView{
    _ndMenuView = [[NDHMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
    _ndMenuView.backgroundColor = [UIColor whiteColor];
    _ndMenuView.delegate = self;
    [self.view addSubview:_ndMenuView];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5,SCREEN_WIDTH, 0.5)];
    lineImg.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImg];
    [self getMenu];

}

#pragma mark
#pragma mark ==================== NDHMenuView delegate =======================
-(void)menuDidSelected:(int)index{
    CGFloat currentY = _tableView.contentOffset.y;
    if (currentY > 0) {
        _tableView.contentOffset = CGPointMake(0,0);
        
    }
    _ndMenuIndex = index;
    [self refreshDataA];
    
}

/**
 *  获取奖项分类
 */
-(void)getMenu{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *paraDic = [HttpBody getAwardLevel:(int)_matchBean.mId];
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
        NSLog(@"请求奖项分类结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
            if (dataArr && dataArr.count > 0) {
                _menuArray = [[NSMutableArray alloc] init];
                for (int i = 0 ; i < dataArr.count; i++) {
                    AwardLevelBean *bean = [AwardLevelBean parseInfo:dataArr[i]];
                    [_menuArray addObject:bean];
                }
            
                NSMutableArray *titleArr = [[NSMutableArray alloc] init];
                for (AwardLevelBean *bean in _menuArray) {
                    [titleArr addObject:bean.mName];
                }
                [_ndMenuView setTitles:titleArr];
                [self refreshDataA];
            }
            else{
                [_tableView headerEndRefreshing];
                [_tableView footerEndRefreshing];
                [ProgressHUD showError:@"未获取到奖项分类"];
            }
        }
        else{
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

/**
 *  添加刷新通知
 */
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataA) name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCountDataA) name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,_ndMenuView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-64-_ndMenuView.height)];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(refreshDataA)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreDataA)];
    
}
#pragma mark ===============请求数据===============
/*
 * 刷新数据
 */
- (void)refreshDataA{
    _page = 1;
    [self getDataArrPage:1 andCount:[PAGE_COUNT intValue]];
}
/*
 *加载更多
 */
- (void)loadMoreDataA{
    _page++;
    [self getDataArrPage:_page andCount:[PAGE_COUNT intValue]];
}
/**
 *    网络调用失败  页数－1
 */

-(void)reducePage{
    _page--;
    if (_page <= 0) {
        _page = 1;
    }
}
/*
 *刷新当前页面
 */
-(void) refreshCountDataA{
    int count = _page * [PAGE_COUNT intValue];
    [self getDataArrPage:1 andCount:count];
}
/**
 *  获取参数作品数据
 */
-(void)getDataArrPage:(int)page andCount:(int)count{
    
    if (!_menuArray || _menuArray.count <= 0) {
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
    
    NSDictionary *paraDic = [HttpBody applyListBody:page rows:count fage:-1 eage:-1 uid:uId isMy:-1 gid:-1 isaward:-1 awardconfigId:awardId keyword:@""];
    
    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//        NSLog(@"请求获取获奖展示作品数据结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
            if (page == 1){
                if (_dataArray && _dataArray.count > 0) {
                    [_dataArray removeAllObjects];
                    _dataArray = nil;
                }
                _dataArray = [[NSMutableArray alloc] init];
            }
            if (dataArr && dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i++) {
                    SaiBean *bean = [SaiBean parseInfo:dataArr[i]];

                    if (bean.applySubArr && [bean.applySubArr isKindOfClass:[NSArray class]]
                        && bean.applySubArr.count >0) {
                        [_dataArray addObject:bean];
                    }
                }
            }
            if (_dataArray.count<[PAGE_COUNT integerValue]) {
                [_tableView setFooterHidden:YES];
            }else{
                [_tableView setFooterHidden:NO];
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
    static NSString *cellIndentifier = HomePageCellIdentifier;
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[HomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.oTView.contrller = self;
    cell.delegate = self;
    SaiBean *commentBean = (SaiBean *)_dataArray[indexPath.row];
    [cell setCellInfo:commentBean];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCell *cell = [[HomePageCell alloc] init];
    SaiBean *saibean =(SaiBean *)_dataArray[indexPath.row];
    
    CGFloat height = [cell returnHeight:saibean];
    return height;
}

#pragma mark
#pragma mark ============== UITableViewCell delegate =====================
/**
 *  取消关注  或者 关注接口    //attention 0：未关注 1：已关注   status 1 关注  2取消关注
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
//        NSLog(@"请求关注或者取消关注结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            [self refreshCountDataA];
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
- (void)showMoreComment:(SaiBean *)bean{
    bean.isShowMore =!bean.isShowMore;
    [_tableView reloadData];
}



@end
