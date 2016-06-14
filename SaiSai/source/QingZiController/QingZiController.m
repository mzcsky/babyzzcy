//
//  QingZiController.m
//  SaiSai
//
//  Created by 葛新伟 on 15/12/1.
//  Copyright © 2015年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiController.h"
#import "QingZiCell.h"
#import "ActionAdView.h"
#import "SixBtnCell.h"
#import "ActivityDetailController.h"
#import "ActionAdView.h"
#import "MatchDetailController.h"
#import "NDHMenuView.h"
#import "QingZiSearch.h"
#import "QingZiBean.h"
#import "QingZiShowController.h"
#import "CustomButton.h"
#import "ProductDetailsController.h"
#import "QingImageBean.h"


#define titleScrollHeight 39
#define CellHeight lunViewHeight + 60
@interface QingZiController ()<UITableViewDelegate,UITableViewDataSource,SixBtnCellDelegate,ActionAdViewDelegate, NDHMenuViewDelegate,UIWebViewDelegate >

@property (nonatomic, strong) NDHMenuView * ndMenuView;
@property (nonatomic, strong) NSMutableArray   *menuArray;
@property (nonatomic, assign) NSInteger menuPage ;
@property (nonatomic, assign) NSInteger ndMenuIndex;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArr;

@property (nonatomic, strong) NSArray * adImgArr;
@property (nonatomic, strong) NSArray * adButtonArr;
@property (nonatomic, strong) NSArray * CellImgArr;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) UIScrollView * adScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) NSArray * plistArr;
//页面
@property (nonatomic, strong) UIWebView  *webView;

@end


@implementation QingZiController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
    [rootCtrller setmTabBarViewHidden:NO animation:YES];
    self.TheadView.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];

}




//- (void)viewDidLoad{
//    [super viewDidLoad];
//    [self initData];
//    [self adImgArr];
//    [self adButton];
//    [self initDataTableView];
//    [self getAllMenu];
//    [self CellimageArray];
//    //获取轮播图数据
//  
//}
//- (void)initData{
//    
//    
//}
///**
// *  TableView
// */
//- (void)initDataTableView{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20-49) style:UITableViewStylePlain];
//    _tableView.delegate   = self;
//    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    //    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
//    //    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
//    
//    [self.view addSubview:_tableView];
//    
//    [self plistArr];
//}
///**
// *  cell的组数
// *
// *  @param tableView
// *
// *  @return
// */
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 2;
//}
///**
// *  内容个数
// *
// *  @param tableView
// *  @param section
// *
// *  @return
// */
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return (section==0) ? 2 : _plistArr.count;
//}
///**
// *  内容高度
// *
// *  @param tableView
// *  @param indexPath
// *
// *  @return
// */
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section==0 && indexPath.row==1) {
//        CGFloat btnW = (SCREEN_WIDTH - btnCount*2*kMargic)/btnCount;
//        
//        CGFloat height = kMargic + (btnW+kMargic)*2;
//        
//        return height/2;
//    }else if(indexPath.section==0 && indexPath.row==0){
//        return lunViewHeight;
//    }else{
//        return CellHeight;
//    }
//}
///**
// *  Header高度
// *
// *  @param tableView
// *  @param section
// *
// *  @return
// */
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    if (section==1) {
//        return titleScrollHeight;
//    }
//    return 0;
//}
///**
// *  header内容
// *
// *  @param tableView
// *  @param section
// *
// *  @return
// */
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (_ndMenuView == nil) {
//        
//        if (!_ndMenuView) {
//            _ndMenuView = [[NDHMenuView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 39)];
//            _ndMenuView.backgroundColor = [UIColor whiteColor];
//            _ndMenuView.delegate = self;
//            
//        }
//    }
//    return _ndMenuView;
//}
//
//
//-(void)refreshDatas{
//     _menuPage = 1;
//    [self getAllMenu];
//    
//}
//- (void)menuDidSelected:(int)index{
//    
//    CGFloat currentY = _tableView.contentOffset.y;
//    if (currentY > lunViewHeight) {
//        _tableView.contentOffset = CGPointMake(0,lunViewHeight);
//    }
//    _ndMenuIndex = index;
////    [self GetRefresh];
//}
//
////- (void)GetRefresh{
////    if (!_menuArray || _menuArray.count <= 0) {
////        return;
////    }
////    int datavalue;
////    if (_ndMenuIndex == 0)
////    {
////        datavalue = -1;
////    }else{
////        QingZiBean *bean = _menuArray[_ndMenuIndex-1];
////        datavalue =(int)bean.datavalue;
////    }
////
////    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
////    NSDictionary *paraDic = [HttpBody findProductListByCondition:datavalue];
////    [ProgressHUD show:LOADING];
////    [manager GET:URLADDRESS parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
////        [_tableView headerEndRefreshing];
////        [_tableView footerEndRefreshing];
////        
////        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
////        //        NSLog(@"请求获取主界面参赛作品数据结果:%@",jsonDic);
////        if ([[jsonDic objectForKey:@"resultCode"] integerValue] == 1) {
////            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"list"]];
////
////}
//
//-(void)getAllMenu{
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager GET:URL_Button parameters:nil success:^(AFHTTPRequestOperation * operation, id response) {
//        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//                    NSLog(@"请求滑动按钮数据结果:%@",jsonDic);
//        if ([[jsonDic objectForKey:@"resultCode"] integerValue] == 1) {
//            NSDictionary *dataDic = jsonDic[@"data"];
//            NSArray *dataArray = [[NSArray alloc] initWithArray:[dataDic objectForKey:@"list"]];
//            
//            if (dataArray && dataArray.count > 0) {
//                _menuArray = [[NSMutableArray alloc] init];
//                for (int i = 0; i < dataArray.count; i++) {
//                    QingZiBean *bean = [QingZiBean QZparseInfo:dataArray[i]];
//                    [_menuArray addObject:bean];
//                }
//                NSMutableArray *titleArr = [[NSMutableArray alloc] init];
//                for (QingZiBean *bean in _menuArray) {
//                    [titleArr addObject:bean.content];
//                }
//                [titleArr insertObject:@"全部     " atIndex:0];
//                [_menuArray addObject:[[QingZiBean alloc] init]];
//                [_ndMenuView setTitles:titleArr];
//                [_tableView reloadData];
//            }else{
//                [_tableView headerEndRefreshing];
//                [_tableView footerEndRefreshing];
//                [ProgressHUD showError:@"未获取到滑动按钮结果"];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"failuer");
//        [ProgressHUD showError:CHECKNET];
//        [_tableView headerEndRefreshing];
//        [_tableView footerEndRefreshing];
//    }];
//
//}
//
//
///**
// *  TableViewCell内容
// *
// *  @param tableView
// *  @param indexPath
// *
// *  @return
// */
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.section==0 && indexPath.row==0) {
//        
//        ActionAdView * cell = [ActionAdView valueWithTableView:tableView imgArr:_adImgArr];
//        
//        self.adScrollView = cell.scrollView;
//        self.adScrollView.delegate = self;
//        self.pageControl = cell.pageControl;
//        
//        cell.delegate = self;
//        
//        return cell;
//        
//    }else if(indexPath.section==0 && indexPath.row==1){
//        
//        SixBtnCell * cell = [SixBtnCell valueWithTableView:tableView dataArr:_adButtonArr];
//        cell.delegate = self;
//        
//        return cell;
//  
//    }else{
//        QingZiCell * cell = [QingZiCell valueWithTableView:tableView CellImgArr:_CellImgArr];
//        
//        return cell;
//    }
//}
//
////cell点击事件
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        ProductDetailsController *PDVC = [[ProductDetailsController alloc]init];
//        [self.navigationController pushViewController:PDVC animated:YES];
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    int  currentPage = self.adScrollView.contentOffset.x / SCREEN_WIDTH;
//    if (self.adImgArr.count>0) {
//        if (currentPage==0 || currentPage == (int)(_adImgArr.count-1)) {
//            if (currentPage==0) {
//                currentPage = (int)_adImgArr.count-2;
//            }else{
//                currentPage = 1;
//            }
//        }
//        
//        if (!(currentPage==0 || currentPage == (int)(_adImgArr.count-1))) {
//            currentPage++;
//        }
//        
//        self.pageControl.currentPage = currentPage-2;
//    }
//}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self removeTimer];
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    
//    int  currentPage = self.adScrollView.contentOffset.x / SCREEN_WIDTH;
//    if (self.adImgArr.count>1) {
//        if (currentPage==0 || currentPage == (int)(_adImgArr.count-1)) {
//            if (currentPage==0) {
//                currentPage = (int)_adImgArr.count-2;
//            }else{
//                currentPage = 1;
//            }
//        }
//        [self.adScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*currentPage, 0) animated:NO];
//    }
//    [self addtimer];
//}
//
//- (void)addtimer{
//    if (!self.timer) {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    }
//}
//
//- (void)removeTimer{
//    [self.timer invalidate];
//    self.timer = nil;
//}
//
//- (void)nextImage{
//    
//    int  currentPage = self.adScrollView.contentOffset.x / SCREEN_WIDTH;
//    if (self.adImgArr.count>1) {
//        if (currentPage==0 || currentPage == (int)(_adImgArr.count-1)) {
//            if (currentPage==0) {
//                currentPage = (int)_adImgArr.count-2;
//            }else{
//                currentPage = 1;
//            }
//            [self.adScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*currentPage, 0) animated:NO];
//
//        }
//        if (!(currentPage==0 || currentPage == (int)(_adImgArr.count-1))) {
//            currentPage++;
//            [self.adScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*currentPage, 0) animated:YES];
//        }
//        
//    }
//}
//
//
//#pragma ----mark---TitleScrollDelegate
//- (void)btnClickAtIndex:(NSInteger)index{
//    NSLog(@"--------点击了第 %ld 个按钮",(long)index);
//}
//#pragma ----mark----SixBtnCellDelegate
//
//- (void)pushViewWithIndex:(NSInteger)index andModel:(QingZiBean *)Qmodel{
//    
//    if (index == 0) {
//        
//        QingZiShowController *showVC = [[QingZiShowController alloc] init];
//        showVC.Qmodel = Qmodel;
//        [self.navigationController pushViewController:showVC animated:YES];
//
//    }
//    if (index == 1) {
//        ActivityDetailController * VC = [[ActivityDetailController alloc] init];
//        VC.Qmodel = Qmodel;
//        [self.navigationController pushViewController:VC animated:YES];
//    }
//
//}
//#pragma ----mark----懒加载
//- (NSArray *)adImgArr{
//    if (!_adImgArr) {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//
//        NSMutableArray * dataArr = [NSMutableArray array];
//        [manager GET:KGetRecommendList parameters:@{} success:^(AFHTTPRequestOperation * operation, id response){
//        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//            //解析数据
//            int status = [[resDict objectForKey:@"status"] intValue];
//            if (status == 1) {
//                NSDictionary *data = [resDict objectForKey:@"data"];
//                NSArray *adArray = [data objectForKey:@"recommend"];
//                for (int i = 0; i < adArray.count; i++) {
//                    
//                    if (adArray.count<=1) {
//                        MatchCCBean *bean = [MatchCCBean analyseData:adArray[i]];
//                        [dataArr addObject:bean];
//                    }else{
//                        //循环播放使用
//                        if (i==0) {
//                            MatchCCBean *bean0 = [MatchCCBean analyseData:adArray[adArray.count-1]];
//                            [dataArr addObject:bean0];
//                        }
//                        MatchCCBean *bean = [MatchCCBean analyseData:adArray[i]];
//                        [dataArr addObject:bean];
//                        //循环播放使用
//                        if (i==(adArray.count-1)) {
//                            MatchCCBean *bean1 = [MatchCCBean analyseData:adArray[0]];
//                            [dataArr addObject:bean1];
//                        }
//                    }
//                }
//                [_tableView reloadData];
//                [self addtimer];
//            }
//            _adImgArr = dataArr;
//            ;
//        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
//            NSLog(@"failuer");
//        }];
//    }
//    return _adImgArr;
//}
//
//#pragma ----mark----ActionAdViewDelegate
////点击事件
//- (void)imageViewClickAtIndex:(NSInteger)index{
//    if (!_adImgArr || _adImgArr.count==0) {
//        return;
//    }
//    if (index<0) {
//        index = 0;
//    }
//    if (index>=_adImgArr.count) {
//        index = _adImgArr.count-1;
//    }
//    MatchCCBean *bean = [_adImgArr objectAtIndex:index];
//    
//    MatchDetailController *ctrl = [[MatchDetailController alloc] init];
//    ctrl.adArray = [NSArray arrayWithArray:_adImgArr];
//    ctrl.title = @"详情";
//    ctrl.m_showBackBt = YES;
//    ctrl.fBean = bean;
//    [self.navigationController pushViewController:ctrl animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
//}
////搜索
//- (void)searchBtnClickSender:(UIButton *)sender{
//    if (sender.tag == 0) {
//        
//    }else{
//        QingZiSearch *ctrller = [[QingZiSearch alloc] init];
//        ctrller.m_showBackBt = YES;
//        ctrller.title = @"活动搜索";
//        [self.navigationController pushViewController:ctrller animated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
//    }
//}
//
//#pragma mark -----------获取button数据---------------
//
//- (NSArray *)adButton{
//    if (!_adButtonArr) {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//        
//        NSMutableArray * dataArr = [NSMutableArray array];
//
//        [manager GET:URL_Button parameters:@{} success:^(AFHTTPRequestOperation * operation, id response){
//            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
////            NSLog(@"请求图片数据结果:%@",jsonDic);
//            if ([[jsonDic objectForKey:@"resultCode"] integerValue] == 1) {
//                NSDictionary * dataDic = jsonDic[@"data"];
//                NSArray *adArray = [[NSArray alloc] initWithArray:[dataDic objectForKey:@"list"] ];
//                for (int i = 0; i < adArray.count; i++) {
//                    if (adArray.count<=1) {
//                        QingZiBean *bean = [QingZiBean QZparseInfo:adArray[i]];
//                        [dataArr addObject:bean];
//                    }else{
//                    QingZiBean *bean = [QingZiBean QZparseInfo:adArray[i]];
//                        [dataArr addObject:bean];
//                        }
//                }
//                [_tableView reloadData];
//            }
//            _adButtonArr = dataArr;
//        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
//            NSLog(@"failuer");
//        }];
//    }
//    return _adButtonArr;
//
//}
//
//-(NSArray *)CellimageArray{
//    if (!_CellImgArr) {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//        
//        
//        NSDictionary *paraDic = [HttpBody findProductListByCondition:1 rows:5 userx:111 usery:111 type:-1 logopath:-1];
////        [ProgressHUD show:LOADING];
//
//        NSMutableArray * dataArr = [NSMutableArray array];
//
//        [manager GET:URL_ImgArrUrlN parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
//            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//                        NSLog(@"请求按钮数据结果:%@",jsonDic);
//            if ([[jsonDic objectForKey:@"resultCode"] integerValue] == 1) {
//                NSDictionary * dataDic = jsonDic[@"data"];
//                NSArray *adArray = [[NSArray alloc] initWithArray:[dataDic objectForKey:@"list"] ];
//                for (int i = 0; i < adArray.count; i++) {
//                    if (adArray.count<=1) {
//                        QingImageBean *Imgbean = [QingImageBean ImageBeanparseInfo:adArray[i]];
//                        [dataArr addObject:Imgbean];
//                    }else{
//                        QingImageBean *Imgbean = [QingImageBean ImageBeanparseInfo:adArray[i]];
//                        [dataArr addObject:Imgbean];
//                    }
//                }
//                [_tableView reloadData];
//            }
//            _CellImgArr = dataArr;
//        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
//            NSLog(@"failuer");
//        }];
//    }
//
//    return _CellImgArr;
//}
//@end


//老的加载页面
- (void)viewDidLoad{
    [super viewDidLoad];
    [ProgressHUD show:LOADING];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-69)];
    _webView.backgroundColor = [UIColor whiteColor];
    
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.zzcyer.com"]];
    [_webView loadRequest:request];

    [self.view addSubview:_webView];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"aaaaaaaaaa");
    [ProgressHUD dismiss];
}
@end

