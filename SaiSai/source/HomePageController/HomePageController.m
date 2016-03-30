//
//  HomePageController.m
//  SaiSai
//
//  Created by weige on 15/8/15.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "HomePageController.h"
#import "AgeBean.h"
#import "HomePageCell.h"
#import "MyNavButton.h"
#import "HistoryGameController.h"
#import "UsermsgController.h"
#import "SSButtonView.h"
#import "MatchCCell.h"
#import "AwardGameController.h"
#import "AdvertView.h"
#import "MatchCADBean.h"
#import "MatchDetailController.h"
#import "MatchClaBean.h"
#import "SearchWorkController.h"

@interface HomePageController ()<NDHMenuViewDelegate,UITableViewDataSource,UITableViewDelegate,HomePageCellDelegate,AdvertViewDelegate>

@property (nonatomic,strong) NDHMenuView      *ndMenuView;
@property (nonatomic,strong) NSMutableArray   *menuArray;
@property (nonatomic,assign) NSInteger         ndMenuIndex;
@property (nonatomic,strong) UITableView      *tableView;
@property (nonatomic,strong) NSMutableArray   *dataArray;
@property (nonatomic,assign) int               currentPage;
@property (nonatomic,strong) UsermsgController *Usermsg;
@property (nonatomic, strong) UIView            *sectionHeader;

@end

@implementation HomePageController{
    //获奖展示
    UITableView       * _showTableView;
    NSMutableArray    * _showDataArray;
    NSInteger         _showPage;
    
    //轮播
    AdvertView        *_lunadView;
    NSMutableArray    *_lunadArray, *_lunadSArray, *_luntArray;
    NSMutableArray    *_lunclaArray, *_lunclaNames;
    NSInteger         _lunPage;
    NSInteger         _lunprojId;

    BOOL _isFinishedRequest;
    

}
/**
 *  当前页面出现时
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     self.navigationController.navigationBarHidden = YES;
    XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
    [rootCtrller setmTabBarViewHidden:NO animation:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

/**
 *  当前页面消失时
 */
-(void)viewWillDisappear:(BOOL)animated{
       self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initRightItem];
    [self addNotification];
    [self initData];//数据初始化
    [self initTableView];//用户信息请求
    [self lungetData];//广告栏请求
    [self getDetail];//补充广告栏数据请求
    [self getAgeMenu];//获取年龄分类
    

}

- (void)initData{
    _lunPage = 1;
    _lunprojId = 0;
    _lunadArray = [[NSMutableArray alloc] init];
    _lunadSArray = [[NSMutableArray alloc] init];
    _luntArray = [[NSMutableArray alloc] init];

}

/*
 *  添加刷新通知
 */
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDatas) name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCountData) name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)dealloc{
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  搜索
 */

- (void)initRightItem{
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 8, 40, 40);
    [rightItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightItem setTitle:@"搜索" forState:UIControlStateNormal];
    [rightItem setImage:[UIImage imageNamed:@"ic_search.png"] forState:UIControlStateNormal];
    [rightItem setTitleColor:TabbarNTitleColor forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(showGoldS) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem =rightBar;
    
}
/**
 *  进入搜索界面
 */
- (void)showGoldS{
    SearchWorkController *ctrller = [[SearchWorkController alloc] init];
    ctrller.m_showBackBt = YES;
    ctrller.title = @"搜索作品";
    [self.navigationController pushViewController:ctrller animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}

#pragma mark - ===============切换==============
/**
 *  初始化tableview  40+64+49 底层界面位置
 */
-(void)initTableView{
    //切换视图
    _isFinishedRequest = NO;
    _showPage = 1;
    //总的切换
    SSButtonView * bntView = [[SSButtonView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) TitleArray:@[@"风采展示",@"获奖展示",] AndSelectIndex:0 AndBlock:^(NSInteger index) {
        NSLog(@"点击%ld",(long)index);
        if (index ==0) {
            _tableView.hidden = NO;
            _showTableView.hidden = YES;
            _ndMenuView.hidden = NO;
            _lunadView.hidden = NO;
        }else{
            _tableView.hidden = YES;
            _showTableView.hidden = NO;
            _ndMenuView.hidden = YES;
            _lunadView.hidden = YES;
            if (!_isFinishedRequest) {
                [self getData];
            }
            
        }
    }];
    [self.view addSubview:bntView];
    
    //年龄分类
    if (!_ndMenuView) {
        _ndMenuView = [[NDHMenuView alloc] initWithFrame:CGRectMake(0, bntView.bottom, SCREEN_WIDTH, 39)];
        _ndMenuView.backgroundColor = [UIColor whiteColor];
        _ndMenuView.delegate = self;
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _ndMenuView.bottom,SCREEN_WIDTH, 1)];
        lineImg.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineImg];
        [self.view addSubview:_ndMenuView];
    }
    _showDataArray = [NSMutableArray array];
    
    //风采展示
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _ndMenuView.bottom+1, SCREEN_WIDTH, SCREEN_HEIGHT-148)];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.hidden = NO;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(getAgeMenu)];
    [_tableView addFooterWithTarget:self action:@selector(loadMore)];
    
    //获奖展示
    _showTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-148)];
    _showTableView.dataSource = self;
    _showTableView.delegate   = self;
    _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _showTableView.backgroundColor = BACKGROUND_COLOR;
    _showTableView.hidden = YES;
    [self.view addSubview:_showTableView];
    [_showTableView addHeaderWithTarget:self action:@selector(getHuojiang)];
    [_showTableView addFooterWithTarget:self action:@selector(loadHuojiang)];
  
//    _contentView.contentSize = CGSizeMake(SCREEN_WIDTH, 150+_lunadView.height+bntView.height+_tableView.height);
    
}
/**
 *  获取年龄分类
 */
-(void)getAgeMenu{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *paraDic = [HttpBody ageTypeListBody];
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
        NSLog(@"请求年龄分类结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArr = [[NSArray alloc] initWithArray:[jsonDic objectForKey:@"data"]];
            if (dataArr && dataArr.count > 0) {
                _menuArray = [[NSMutableArray alloc] init];
                for (int i = 0 ; i < dataArr.count; i++) {
                    AgeBean *bean = [AgeBean parseInfo:dataArr[i]];
                    [_menuArray addObject:bean];
                }
                NSMutableArray *titleArr = [[NSMutableArray alloc] init];
                for (AgeBean *bean in _menuArray) {
                    [titleArr addObject:bean.ageName];
                }
                [titleArr insertObject:@"全部" atIndex:0];
                [_menuArray addObject:[[AgeBean alloc] init]];
                [_ndMenuView setTitles:titleArr];
                [self refreshDatas];
            }
            else{
                [_tableView headerEndRefreshing];
                [_tableView footerEndRefreshing];
                [ProgressHUD showError:@"未获取到年龄分类"];
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



#pragma mark - ==============广告栏轮播数据===========
/**
 *  轮播
 *
 *  @param index
 */
- (void)didSelectIndex:(NSInteger)index{
    if (!_lunadArray || _lunadArray.count==0) {
        return;
    }
    if (index<0) {
        index = 0;
    }
    if (index>=_lunadArray.count) {
        index = _lunadArray.count-1;
    }
    MatchCCBean *bean = [_lunadArray objectAtIndex:index];
    
    MatchDetailController *ctrl = [[MatchDetailController alloc] init];
    ctrl.adSArray = [NSArray arrayWithArray:_lunadArray];
    ctrl.adArray = [NSArray arrayWithArray:_lunadSArray];
    ctrl.title = @"详情";
    ctrl.m_showBackBt = YES;
    ctrl.fBean = bean;
    [self.navigationController pushViewController:ctrl animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}
/*
 *   轮播数据框位置
 */
- (void)initAdView{
    if (_lunadView == nil) {
        _lunadView = [[AdvertView alloc] initWithFrame:CGRectMake(0, 21, SCREEN_WIDTH, 150) delegate:self withImageArr:_lunadSArray];
        
        _tableView.tableHeaderView = _lunadView;
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,_lunadView.bottom,SCREEN_WIDTH, 1)];
        lineImg.backgroundColor = [UIColor lightGrayColor];
        [_tableView addSubview:lineImg];

        
        [_tableView reloadData];
    }
}
/*
 * 轮播数据请求
 */
- (void)lungetData{
    NSDictionary *pram = [HttpBody gameListBody:(int)_lunPage rows:[PAGE_COUNT intValue] status:-1 projectid:(int)_lunprojId];
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求获取轮播列表接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            NSDictionary *data = [resDict objectForKey:@"data"];
            //请求成功
            //解析轮播数据
            if (_lunadArray != nil && _lunadArray.count>0) {
                //轮播已有数据，不作处理
            }else{
                //轮播无数据
                NSArray *adArray = [data objectForKey:@"recommend"];
                for (NSDictionary *dict in adArray) {
                    //赋值信息
                    MatchCCBean *bean = [MatchCCBean analyseData:dict];
                    [_lunadArray addObject:bean];
                    [_lunadSArray addObject:bean.img];
                }
                [self initAdView];
            }
                        [_tableView reloadData];
            [ProgressHUD dismiss];
        }else{
            //数据请求失败
            _lunPage--;
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}
/**
 *     补充广告栏数据接口请求。
 */
- (void)getDetail{
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:KGetRecommendList parameters:@{} success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求获取参赛主题列表接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            NSDictionary *data = [resDict objectForKey:@"data"];
            //请求成功
            //解析轮播数据
            [_lunadArray removeAllObjects];
            [_lunadSArray removeAllObjects];
            if (_lunadArray != nil && _lunadArray.count>0) {
                //轮播已有数据，不作处理
            }else{
                //轮播无数据
                NSArray *adArray = [data objectForKey:@"recommend"];
                for (NSDictionary *dict in adArray) {
                    MatchCCBean *bean = [MatchCCBean analyseData:dict];
                    
                    [_lunadArray addObject:bean];
                    [_lunadSArray addObject:bean.img];
                }
                [self initAdView];
            }
            
            [_tableView reloadData];
            [ProgressHUD dismiss];
        }else{
            //  数据请求失败
            _lunPage--;
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}

#pragma mark  ==============获取参赛作品数据接口===========
/**
 *  获取参数作品数据
 */
-(void)getDataArrWithCurPage:(int)page andCount:(int)count{
    
    if (!_menuArray || _menuArray.count <= 0) {
        return;
    }
    int fromAge, toAge;
    if (_ndMenuIndex == 0)
    {
        fromAge = -1;
        toAge   = -1;
    }
    else{
        AgeBean *bean = _menuArray[_ndMenuIndex-1];
        fromAge = bean.fromAge;
        toAge   = bean.endAge;
    }
    
    int uId = -1;
    if ([[UserModel shareInfo] isLogin]) {
        uId = [[UserModel shareInfo] uid];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *paraDic = [HttpBody applyListBody:page rows:count fage:fromAge eage:toAge uid:uId isMy:-1 gid:-1 isaward:-1 awardconfigId:-1 keyword:@""];
    
    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求获取参数作品数据结果:%@",jsonDic);
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
                    if (bean.applySubArr && [bean.applySubArr isKindOfClass:[NSArray class]] && bean.applySubArr.count > 0) {
                        [_dataArray addObject:bean];
                    }
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


#pragma mark =============获奖展示接口请求==============
/*
 * 请求获奖展示
 */
- (void)getData{
    NSDictionary *pram = [HttpBody gameListBody:(int)_showPage rows:[PAGE_COUNT intValue] status:4 projectid:0];

    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
        [_showTableView headerEndRefreshing];
        [_showTableView footerEndRefreshing];
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求获取参赛主题列表接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            //请求成功
            _isFinishedRequest = YES;
            NSDictionary *data = [resDict objectForKey:@"data"];
            //解析列表数据
            if (_showPage == 1) {
                [_showDataArray removeAllObjects];
            }
            NSArray *darray = [data objectForKey:@"data"];
            for (NSDictionary *dict in darray) {
                MatchCCBean *bean = [MatchCCBean analyseData:dict];
                [_showDataArray addObject:bean];
            }
            if (darray.count<10) {
                [_showTableView setFooterHidden:YES];
            }else{
                [_showTableView setFooterHidden:NO];
            }
            [_showTableView reloadData];
            [ProgressHUD dismiss];
        }else{
            //数据请求失败
            if (_showPage>1) {
                _showPage--;
            }
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        if (_showPage>1) {
            _showPage--;
        }
        [_showTableView headerEndRefreshing];
        [_showTableView footerEndRefreshing];
    }];
}

#pragma mark ==================== NDHMenuView delegate =======================
#pragma mark =======年龄分类切换=====

/*
 *     年龄分类切换
 */
-(void)menuDidSelected:(int)index{
    _ndMenuIndex = index;
    [self refreshDatas];
}

#pragma mark
#pragma mark ==============UITableView dataSource and delegate ===============

//给tableViewCell赋值
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tableView){
        //风采展示
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
    }else if (tableView == _showTableView){
        //获奖展示
        static NSString * cellId = @"cellId";
        MatchCCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MatchCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        MatchCCBean *bean = [_showDataArray objectAtIndex:indexPath.row];
        [cell setInfo:bean];
        return cell;
    }else{
        //广告栏
        static NSString *MATCHCELL = @"MATCHCELL";
        MatchCCell *cell = [tableView dequeueReusableCellWithIdentifier:MATCHCELL];
        if (!cell) {
            cell = [[MatchCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MATCHCELL];
        }
        MatchCCBean *bean = [_luntArray objectAtIndex:indexPath.row];
        [cell setInfo:bean];
        
        return cell;
    
    }
}
//tableViewCell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableView == tableView) {
        return _dataArray.count;
    }else if(_showTableView == tableView){
        
        return _showDataArray.count;
    }else{
        return 0;
    }
}
//tableViewcell的高度返回值
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _tableView){
    HomePageCell *cell = [[HomePageCell alloc] init];
    SaiBean *saibean = (SaiBean *)_dataArray[indexPath.row];
    CGFloat height = [cell returnHeight:saibean];
        return height;
    }
    if(tableView == _showTableView){
        return MATCHCCELL_HEIGHT;
    }
    return 0;
}
//点击CELL时触发的事件。
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _showTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MatchCCBean *bean = [_showDataArray objectAtIndex:indexPath.row];
        
        AwardGameController *ctrller = [[AwardGameController alloc] init];
        ctrller.m_showBackBt = YES;
        ctrller.title = bean.g_title;
        ctrller.matchBean = bean;
        [self.navigationController pushViewController:ctrller animated:YES];

    }
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
    //刷新数据
    [_tableView reloadData];

}

-(void)UesrHeaderClicked:(SaiBean*)bean{
    UsermsgController * msgVC = [[UsermsgController alloc]initWithBean:bean];
    msgVC.title = bean.realname;
    self.title = @"";
    [self.navigationController pushViewController:msgVC animated:YES];
}
#pragma mark - 获奖展示刷新
//获奖展示下拉刷新
-(void)getHuojiang{
    _showPage = 1;
    [self getData];
    
}
//获奖展示上拉加载更多
-(void)loadHuojiang{
    _showPage++;
    [self getData];
    
}
#pragma mark - 风采展示刷新数据

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
-(void)refreshCountData{
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


@end
