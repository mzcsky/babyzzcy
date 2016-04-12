//
//  MatchDetailController.m
//  SaiSai
//
//  Created by weige on 15/8/30.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "DVersionView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MyNavButton.h"
#import "MatchDetailController.h"
#import "MJRefresh.h"
#import "SaiBean.h"
#import "HomePageCell.h"
#import "BMController.h"
#import "ShareView.h"
#import "MatchCCell.h"
#import "MatchCADBean.h"
#import "MatchWorkController.h"






#define HomePageCellIdentifier1 @"HomePageCellIdentifier1"

#define MATCHDCCELL     @"MATCHDCCELL"
#define MATCHCCELL      @"MATCHCCELL"
#define MATCHDC_BASE_TAG        71300
@interface MatchDetailController ()<UITableViewDataSource, UITableViewDelegate, AdvertViewDelegate, HomePageCellDelegate, BMControllerDelegate , UIWebViewDelegate>

@property (nonatomic, retain) UITableView       *tableView;
//@property (nonatomic, retain) XTTabBarController    *tabCtrl;



@property (nonatomic, retain) AdvertView        *adView;

@property (nonatomic, retain) UIView            *headView;

@property (nonatomic, retain) NSMutableArray            *tArray;

@property (nonatomic, assign) NSInteger                 page;

@property (nonatomic, assign) NSInteger                 type;

@property (nonatomic, retain) NSMutableArray            *xgArray;
@property (nonatomic, retain) UILabel                   *CSlabel;
@property (nonatomic, retain) UIWebView                 *webView;
@end

@implementation MatchDetailController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNotification];
    
    [self initRightItem];
    [self initData];
    [self initTableView];
    [self getData];
    

    
    if (self.adSArray && self.adArray) {
        [self initAdView];
    }
    
    if (self.fBean && (self.fBean.status==1)) {
        UIImage *imagee = [UIImage imageNamed:@"hp_shareBgGG.png"];
        UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
        rightItem.frame = CGRectMake(-110, SCREEN_HEIGHT-121, SCREEN_WIDTH/2+180, 60);
        [rightItem setImage:imagee forState:UIControlStateNormal];
        [rightItem addTarget:self action:@selector(shareBgClick) forControlEvents:UIControlEventTouchUpInside];
        rightItem.backgroundColor = CLEARCOLOR;
        [self.view addSubview:rightItem];
        
        UIImage *image = [UIImage imageNamed:@"match_lijibaoming"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-118, SCREEN_WIDTH/2+40, 55);
        [btn setImage:image forState:UIControlStateNormal];
        btn.backgroundColor = CLEARCOLOR;
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,btn.top,SCREEN_WIDTH, 1)];
        lineImg.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineImg];
        [btn addTarget:self action:@selector(baomingAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

    }

}

- (void)showGoldMatch{
    NSNumber *mid = [NSNumber numberWithInteger:self.fBean.mId];
    MatchWorkController *ctrller = [[MatchWorkController alloc] initWithInfoGid:@{@"mid":mid}];
    ctrller.m_showBackBt = YES;
    ctrller.title = @"搜索作品";
    [self.navigationController pushViewController:ctrller animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}


-(void)initRightItem{
    
    UIButton *Item = [UIButton buttonWithType:UIButtonTypeCustom];
    Item.frame = CGRectMake(0, 8, 40, 40);
    [Item setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [Item setImage:[UIImage imageNamed:@"ic_search.png"] forState:UIControlStateNormal];
    [Item setTitleColor:TabbarNTitleColor forState:UIControlStateNormal];
    [Item addTarget:self action:@selector(showGoldMatch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:Item];
    self.navigationItem.rightBarButtonItem =rightBar;
}

-(void)shareBgClick{
    //分享页面
    [[ShareView shareInfo] showShare:YES];
    [[ShareView shareInfo] setController:self];
    [[ShareView shareInfo] setMsg:self.fBean.g_title];
    [[ShareView shareInfo] setImg:[UIImage imageNamed:@"icon-60-phone.png"]];
    [[ShareView shareInfo] setGid:[NSString stringWithFormat:@"%ld",(long)self.fBean.mId]];
//    [[ShareView shareInfo] setPid:[NSString stringWithFormat:@"%ld",(long)self.fBean.mId]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self removeNotification];
}

/**
 *  添加刷新通知
 */
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESHCOUNTDATA object:nil];
}


- (void)initData{
    self.page = 1;
    self.type = MATCHDC_BASE_TAG;
    self.adArray = [NSArray array];
    self.adSArray = [NSArray array];
    self.tArray = [[NSMutableArray alloc] init];
    self.xgArray = [[NSMutableArray alloc] init];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-110)];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    _CSlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 50)];
    _CSlabel.textColor = BACKGROUND_FENSE;
    _CSlabel.font = [UIFont systemFontOfSize:20];
    _CSlabel.text = @"活动正在征集审核通过马上展示";
    _CSlabel.textAlignment = NSTextAlignmentCenter;

    
    [_tableView addSubview:_CSlabel];
    [self.view addSubview:_tableView];
    
}

- (void)initAdView{
    if (self.adView == nil) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lunViewHeight)];
        contentView.backgroundColor = CLEARCOLOR;
        _tableView.tableHeaderView = contentView;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lunViewHeight)];
        bgView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:bgView];

        self.adView = [[AdvertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lunViewHeight) delegate:self withImageArr:self.adSArray];
        [bgView addSubview:self.adView];
    }
}

#pragma mark
#pragma mark ====== AdvertViewDelegate ======
- (void)didSelectIndex:(NSInteger)index{
    
}

#pragma mark
#pragma mark ====== UITableView delegate && datasource ======

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.type) {
        case MATCHDC_BASE_TAG:
        {
      
            return 1;
        }
            break;
        case MATCHDC_BASE_TAG+1:
        {
            if (self.tArray) {
                return self.tArray.count;
            }
            return 0;
        }
            break;
        case MATCHDC_BASE_TAG+2:
        {
            if (self.xgArray) {
                return self.xgArray.count;
            }
            return 0;
        }
            break;
            
        default:
            break;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case MATCHDC_BASE_TAG:
        {
            if (_webView) {
                CGFloat h = _webView.scrollView.contentSize.height;
                return h;
            }
            return 0;

        }
            break;
        case MATCHDC_BASE_TAG+1:
        {
            //每个cell的高度
            HomePageCell *cell = [[HomePageCell alloc] init];
            CGFloat height = [cell returnHeight:_tArray[indexPath.row]];
            return height;
        }
            break;
        case MATCHDC_BASE_TAG+2:
        {
            return MATCHCCELL_HEIGHT;
        }
            break;
            
        default:
            break;
    }
    return 400;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    _headView.backgroundColor = BACKGROUND_COLOR;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2.5, SCREEN_WIDTH-20, 30)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = XT_MAINCOLOR;
    imageView.layer.cornerRadius = 2;
    imageView.clipsToBounds = YES;
    [_headView addSubview:imageView];
    UIImageView *DownImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _headView.bottom,SCREEN_WIDTH, 1)];
    DownImg.backgroundColor = [UIColor lightGrayColor];
    UIImageView *UpImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, _headView.height-1, SCREEN_WIDTH, 1)];
    UpImg.backgroundColor =[UIColor lightGrayColor];
    [_headView addSubview:DownImg];
    [_headView addSubview:UpImg];
    

    float width = (SCREEN_WIDTH-20-8)/3;
    float height = 26;
    
    NSArray *array = [NSArray arrayWithObjects:@"指导说明", @"作品展览", @"相关推荐", nil];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2+i*(width+2), 2, width, height);
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:XT_MAINCOLOR] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(13);
        btn.tag = i+MATCHDC_BASE_TAG;
        [btn addTarget:self action:@selector(changeTip:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:btn];
        if (i ==self.type-MATCHDC_BASE_TAG) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    return _headView;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case MATCHDC_BASE_TAG:
        {
            _CSlabel.hidden = YES;
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MATCHDCCELL];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MATCHDCCELL];
            }
            
            
            if (!_webView) {
                _webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
                _webView.delegate = self;
                _webView.scrollView.scrollEnabled = NO;
                [self loadHtml:self.fBean.g_guide];
            }
            [cell.contentView addSubview:_webView];

            return cell;
        }
            break;
        case MATCHDC_BASE_TAG+1:
        {

            HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:HomePageCellIdentifier1];
            if (!cell) {
                cell = [[HomePageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomePageCellIdentifier1];
            }
            cell.oTView.contrller = self;
            cell.delegate = self;
            [cell setCellInfo:_tArray[indexPath.row]];
        
            
            return cell;
        }
            break;
        case MATCHDC_BASE_TAG+2:
        {
            MatchCCell *cell = [tableView dequeueReusableCellWithIdentifier:MATCHCCELL];
            if (!cell) {
                cell = [[MatchCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MATCHCCELL];

            }
            MatchCCBean *bean = [self.xgArray objectAtIndex:indexPath.row];
            [cell setInfo:bean];
            
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }

}
/**
 *  webView高度
 *
 *  @param webView 赋值
 */

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat h = [webView.scrollView contentSize].height;
    
    CGRect maFrame = webView.frame;
    maFrame.size.height = h;
    webView.frame = maFrame;
    
    [_tableView reloadData];
    
}
/**
 *  webView 内容
 *
 *  @param url 指导说明
 */
- (void)loadHtml:(NSString *)url{
    if ([url hasPrefix:@"http://"]) {
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:req];
    }else{
        NSString *show = [NSString stringWithFormat:@"<p>%@</p>",url];
        [_webView loadHTMLString:show baseURL:nil];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.type) {
        case MATCHDC_BASE_TAG+2:
        {
            //相关推荐

            MatchCCBean *bean = [self.xgArray objectAtIndex:indexPath.row];
            DVersionView *view = [[DVersionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [view loadText:bean.content];
            [view setTitle:bean.g_title];
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window addSubview:view];
            [view showAnimation];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark
#pragma mark ====== 获取数据 ======

- (void)refreshData{
    switch (self.type) {
        case MATCHDC_BASE_TAG+1:
        {
            self.page = 1;
            [self getData];
        }
            break;
            
        default:
        {
            self.page = 1;
            [self getXGData];
        }
            break;
    }
}

- (void)loadMoreData{
    switch (self.type) {
        case MATCHDC_BASE_TAG+1:
        {
            self.page++;
            [self getData];
        }
            break;
            
        default:
        {
            self.page++;
            [self getXGData];
        }
            break;
    }
}
//相关推荐
- (void)getXGData{
    _CSlabel.hidden = YES;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSDictionary *paraDic = [HttpBody getadlist:(int)self.page row:[PAGE_COUNT intValue] gid:(int)self.fBean.mId];
    
    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求获取相关推荐数据结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
            if (self.page == 1) {
                if (_xgArray && _xgArray.count > 0) {
                    [_xgArray removeAllObjects];
                }
            }
            
            if (dataArr && dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i++) {
                    MatchCCBean *bean = [MatchCCBean analyseData:dataArr[i]];
                    bean.isXG = YES;
                    [_xgArray addObject:bean];
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
            if (self.page>1) {
                self.page--;
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if (self.page>1) {
            self.page--;
        }
    }];
}
//请求获取参数作品数据
- (void)getData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    int uid = -1;
    if ([[UserModel shareInfo] isLogin]) {
        uid = [[UserModel shareInfo] uid];
    }
    
    NSDictionary *paraDic = [HttpBody applyListBody:(int)self.page rows:[PAGE_COUNT intValue] fage:-1 eage:-1 uid:uid isMy:-1 gid:(int)self.fBean.mId isaward:-1 awardconfigId:-1 keyword:@""];
    
    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//        NSLog(@"请求获取关注人作品数据结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            
            NSArray *banner = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"banner"]];
            if (banner && [banner isKindOfClass:[NSArray class]] && banner.count>0) {
                NSMutableArray *adArray = [NSMutableArray array];
                NSMutableArray *adImgs = [NSMutableArray array];
                for (NSDictionary *banDict in banner) {
                    MatchCADBean *bean = [MatchCADBean analyseData:banDict];
                    [adArray addObject:bean];
                    [adImgs addObject:bean.img];
                }
                self.adArray = adArray;
                self.adSArray = adImgs;
                
                [_adView reloadDataWithArray:self.adSArray];
                //以上为轮播数据
            }
            
            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
            if (self.page == 1) {
                if (_tArray && _tArray.count > 0) {
                    [_tArray removeAllObjects];
                }
            }
            
            if (dataArr && dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i++) {
                    SaiBean *bean = [SaiBean parseInfo:dataArr[i]];
                    [_tArray addObject:bean];
                    _CSlabel.hidden = YES;
                }
            }else{
                _CSlabel.hidden = NO;
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
            if (self.page>1) {
                self.page--;
            }
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if (self.page>1) {
            self.page--;
        }
    }];
}

- (void)changeTip:(id)sender{
    [self clearBtn];
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    self.type = btn.tag;
    
    CGFloat currentY = _tableView.contentOffset.y;
    if (currentY > lunViewHeight) {
        _tableView.contentOffset = CGPointMake(0,lunViewHeight);
        
    }
    
    switch (btn.tag) {
        case MATCHDC_BASE_TAG:
        {               //参赛指导

            [_tableView setHeaderHidden:YES];
            [_tableView setFooterHidden:YES];
        }
            break;
        case MATCHDC_BASE_TAG+1:
        {
            //显示参赛作品数据

            [_tableView setHeaderHidden:NO];
            [_tableView setFooterHidden:NO];
            [self refreshData];

        
        }
            break;
        case MATCHDC_BASE_TAG+2:
        {
            //相关推荐
            [_tableView setHeaderHidden:NO];
            [_tableView setFooterHidden:NO];
            [self refreshData];
        }
            break;
            
        default:
            break;
    }
    [_tableView reloadData];
}

- (void)clearBtn{
    for (int i = 0; i < 3; i++) {
        UIButton *btn = (UIButton *)[_headView viewWithTag:i+MATCHDC_BASE_TAG];
        btn.selected = NO;
    }
}
//报名点击事件

- (void)baomingAction{
//
    if (![[UserModel shareInfo] isLogin]) {
        //显示登录页面
        LoginViewController *ctrlLog = [[LoginViewController alloc] init];
        ctrlLog.title = @"学习活动比赛平台";
        ctrlLog.m_showBackBt = YES;
        ctrlLog.m_hasNav = NO;
        XTCustomNavigationController* naviCtrller = [[XTCustomNavigationController alloc] initWithRootViewController:ctrlLog];
        [self presentViewController:naviCtrller animated:YES completion:^{
            
        }];
        
    }else{
        BMController *ctrl = [[BMController alloc] init];
        ctrl.title = @"报名";
        ctrl.m_showBackBt = YES;
        ctrl.delegate = self;
        ctrl.fBean = self.fBean;
        [self.navigationController pushViewController:ctrl animated:YES];
        
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
            [self refreshData];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

#pragma mark
#pragma mark ============== BMControllerDelegate =====================

- (void)showCansaiZhiDao{
    self.type = MATCHDC_BASE_TAG;
    [self.tableView reloadData];
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






@end
