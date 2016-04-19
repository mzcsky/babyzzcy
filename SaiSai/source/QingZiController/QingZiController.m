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


#define titleScrollHeight 50
#define CellHeight lunViewHeight + 60
@interface QingZiController ()<UITableViewDelegate,UITableViewDataSource,SixBtnCellDelegate,ActionAdViewDelegate, NDHMenuViewDelegate >

@property (nonatomic, strong) NDHMenuView * ndMenuView;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataArr;

@property (nonatomic, strong) NSArray * adImgArr;

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, strong) UIScrollView * adScrollView;
@property (nonatomic, strong) UIPageControl * pageControl;


@property (nonatomic, strong) NSArray * plistArr;

@end

@implementation QingZiController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
    [rootCtrller setmTabBarViewHidden:NO animation:YES];
    self.TheadView.hidden = NO;
}


- (NSArray *)plistArr{

    if (!_plistArr) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QingZiPist" ofType:@"plist"];
        NSArray * plitArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        NSMutableArray * tempArr = [NSMutableArray array];
        for (NSDictionary * dic in plitArr) {
            PlistModel * model = [PlistModel valueWithDic:dic];
            
            [tempArr addObject:model];

        }
        
        _plistArr = tempArr;
        [self.tableView reloadData];
    }
    
    return _plistArr;
}
- (void)viewDidLoad{
    [super viewDidLoad];

    //获取轮播图数据
    [self adImgArr];
    
    //添加tabbleView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20-49) style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
//    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.view addSubview:_tableView];
    
    [self plistArr];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section==0) ? 2 : _plistArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==1) {
        CGFloat btnW = (SCREEN_WIDTH - btnCount*2*kMargic)/btnCount;
        
        CGFloat height = kMargic + (btnW+kMargic)*2;
        
        return height;
    }else if(indexPath.section==0 && indexPath.row==0){
        return lunViewHeight;
    }else{
        return CellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==1) {
        return titleScrollHeight;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_ndMenuView == nil) {
        
        //年龄分类
        if (!_ndMenuView) {
            _ndMenuView = [[NDHMenuView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 39)];
            _ndMenuView.backgroundColor = [UIColor redColor];
            _ndMenuView.delegate = self;
            
        }
    }
    return _ndMenuView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0 && indexPath.row==0) {
        
        ActionAdView * cell = [ActionAdView valueWithTableView:tableView imgArr:_adImgArr];
        
        self.adScrollView = cell.scrollView;
        self.adScrollView.delegate = self;
        self.pageControl = cell.pageControl;
        
        cell.delegate = self;
        
        return cell;
        
    }else if(indexPath.section==0 && indexPath.row==1){
        
        SixBtnCell * cell = [SixBtnCell valueWithTableView:tableView];
        cell.delegate = self;
        return cell;
  
    }else{
        PlistModel * model = [_plistArr objectAtIndex:indexPath.row];
        
        QingZiCell * cell = [QingZiCell valueWithTableView:tableView indexPath:indexPath];
        
        cell.model = model;

        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    int  currentPage = self.adScrollView.contentOffset.x / SCREEN_WIDTH;
    if (self.adImgArr.count>0) {
        if (currentPage==0 || currentPage == (int)(_adImgArr.count-1)) {
            if (currentPage==0) {
                currentPage = (int)_adImgArr.count-2;
            }else{
                currentPage = 1;
            }
        }
        
        if (!(currentPage==0 || currentPage == (int)(_adImgArr.count-1))) {
            currentPage++;
        }
        
        self.pageControl.currentPage = currentPage;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int  currentPage = self.adScrollView.contentOffset.x / SCREEN_WIDTH;
    if (self.adImgArr.count>1) {
        if (currentPage==0 || currentPage == (int)(_adImgArr.count-1)) {
            if (currentPage==0) {
                currentPage = (int)_adImgArr.count-2;
            }else{
                currentPage = 1;
            }
        }
        [self.adScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*currentPage, 0) animated:NO];
    }
    [self addtimer];
}

- (void)addtimer{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage{
    
    int  currentPage = self.adScrollView.contentOffset.x / SCREEN_WIDTH;
    if (self.adImgArr.count>1) {
        if (currentPage==0 || currentPage == (int)(_adImgArr.count-1)) {
            if (currentPage==0) {
                currentPage = (int)_adImgArr.count-2;
            }else{
                currentPage = 1;
            }
        }
        [self.adScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*currentPage, 0) animated:NO];
        if (!(currentPage==0 || currentPage == (int)(_adImgArr.count-1))) {
            currentPage++;
            [self.adScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*currentPage, 0) animated:YES];
        }
        
        self.pageControl.currentPage = currentPage;
    }
}


#pragma ----mark---TitleScrollDelegate
- (void)btnClickAtIndex:(NSInteger)index{
    NSLog(@"--------点击了第 %ld 个按钮",(long)index);
}
#pragma ----mark----SixBtnCellDelegate

- (void)pushViewWithIndex:(NSInteger)index andTitle:(NSString *)title{
    ActivityDetailController * VC = [[ActivityDetailController alloc] initWithTitle:title index:index];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma ----mark----懒加载
- (NSArray *)adImgArr{
    if (!_adImgArr) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];

        NSMutableArray * dataArr = [NSMutableArray array];
        [manager GET:KGetRecommendList parameters:@{} success:^(AFHTTPRequestOperation * operation, id response){
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            //解析数据
            int status = [[resDict objectForKey:@"status"] intValue];
            if (status == 1) {
                NSDictionary *data = [resDict objectForKey:@"data"];
                NSArray *adArray = [data objectForKey:@"recommend"];
                for (int i = 0; i < adArray.count; i++) {
                    
                    if (adArray.count<=1) {
                        MatchCCBean *bean = [MatchCCBean analyseData:adArray[i]];
                        [dataArr addObject:bean];
                    }else{
                        //循环播放使用
                        if (i==0) {
                            MatchCCBean *bean0 = [MatchCCBean analyseData:adArray[adArray.count-1]];
                            [dataArr addObject:bean0];
                        }
                        MatchCCBean *bean = [MatchCCBean analyseData:adArray[i]];
                        [dataArr addObject:bean];
                        //循环播放使用
                        if (i==(adArray.count-1)) {
                            MatchCCBean *bean1 = [MatchCCBean analyseData:adArray[0]];
                            [dataArr addObject:bean1];
                        }
                    }
                    
                }
                [_tableView reloadData];
                [self addtimer];
            }
            _adImgArr = dataArr;
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"failuer");
        }];
    }
    return _adImgArr;
}

#pragma ----mark----ActionAdViewDelegate
//点击事件
- (void)imageViewClickAtIndex:(NSInteger)index{
    if (!_adImgArr || _adImgArr.count==0) {
        return;
    }
    if (index<0) {
        index = 0;
    }
    if (index>=_adImgArr.count) {
        index = _adImgArr.count-1;
    }
    MatchCCBean *bean = [_adImgArr objectAtIndex:index];
    
    MatchDetailController *ctrl = [[MatchDetailController alloc] init];
    ctrl.adArray = [NSArray arrayWithArray:_adImgArr];
    ctrl.title = @"详情";
    ctrl.m_showBackBt = YES;
    ctrl.fBean = bean;
    [self.navigationController pushViewController:ctrl animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}

- (void)searchBtnClickSender:(UIButton *)sender{
    if (sender.tag == 0) {
        
    }else{
        QingZiSearch *ctrller = [[QingZiSearch alloc] init];
        ctrller.m_showBackBt = YES;
        ctrller.title = @"活动搜索";
        [self.navigationController pushViewController:ctrller animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
    }
}


@end
