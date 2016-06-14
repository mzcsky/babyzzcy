//
//  SearchWorkController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/22.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "SearchWorkController.h"
#import "HomePageCell.h"
#import "AgeBean.h"
#import "AttendOrFansBean.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface SearchWorkController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,HomePageCellDelegate>
@property (nonatomic,strong) NDHMenuView      *ndMenuView;
@property (nonatomic,strong) UITableView      *tableView;
@end


@implementation SearchWorkController{
    UITableView       *_SWtableView;
    NSMutableArray    *_SWdataArray;
    UISearchBar       *_SWsearchBar;
    int               _SWpage;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SWrefreshDatas) name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SWrefreshCountData) name:HP_REFRESHCOUNTDATA object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HP_REFRESHCOUNTDATA object:nil];
}
- (void)dealloc{
    [self removeNotification];
}


- (void)initTableView{
    _SWtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    _SWtableView.backgroundColor = [UIColor whiteColor];
    _SWtableView.dataSource = self;
    _SWtableView.delegate = self;
    _SWtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_SWtableView];
    
    _SWsearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _SWsearchBar.backgroundColor = CLEARCOLOR;
    _SWsearchBar.delegate = self;
    [self.view addSubview:_SWsearchBar];

        [_SWtableView addFooterWithTarget:self action:@selector(SWloadMore)];


}

/**
 *  刷新数据
 */
-(void)SWrefreshDatas{
    _SWpage = 1;
    [self searchFriendsWithCurPage:1 count:[PAGE_COUNT intValue]];
}

/**
 *  加载更多
 */
-(void)SWloadMore{
    if ([_SWsearchBar.text isEqualToString:@""]) {
        return;
    }
    _SWpage++;
    [self searchFriendsWithCurPage:_SWpage count:[PAGE_COUNT intValue]];
}

/**
 *  刷新到当前页
 */
-(void)SWrefreshCountData{
    int count = _SWpage * [PAGE_COUNT intValue];
    [self searchFriendsWithCurPage:1 count:count];
}

/**
 *  网络调用失败 页数－1
 */
-(void)SWreducePage{
    _SWpage--;
    if (_SWpage <= 0) {
        _SWpage = 1;
    
    }
}
/**
 *  搜索作品请求
 *
 *  @param page
 *  @param count
 */
-(void)searchFriendsWithCurPage:(int)page count:(int)count{
    NSString *searchStr = _SWsearchBar.text;
    if (!searchStr && [searchStr isEqualToString:@""]) {
        return;
    }

    int uId = -1;
    if ([[UserModel shareInfo] isLogin]) {
        uId = [[UserModel shareInfo] uid];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
 
    NSDictionary *paraDic = [HttpBody findApplyListByCondition:page rows:count fage:-1 eage:-1 uid:uId isMy:-1 gid:-1 isaward:-1 awardconfigId:-1 keyword:searchStr];
    
    [ProgressHUD show:LOADING];
    
    [manager GET:URL_AwardUrl_innermesh parameters:paraDic success:^(AFHTTPRequestOperation * operation, id response){
        [_SWtableView footerEndRefreshing];
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"===========请求搜索作品数据结果========:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            NSArray *dataArr = [[NSArray alloc] initWithArray:[[jsonDic objectForKey:@"data"] objectForKey:@"data"]];
            if (page == 1) {
                if (_SWdataArray && _SWdataArray.count > 0) {
                    [_SWdataArray removeAllObjects];
                    _SWdataArray = nil;
                }
                _SWdataArray = [[NSMutableArray alloc] init];
            }
            
            if (dataArr && dataArr.count > 0) {
                for (int i = 0; i < dataArr.count; i++) {
                    
                    SaiBean *bean = [SaiBean parseInfo:dataArr[i]];
                    
                    if (bean.applySubArr && [bean.applySubArr isKindOfClass:[NSArray class]]
                        && bean.applySubArr.count > 0) {
                    
                        [_SWdataArray addObject:bean];
                    }
                }
            }
            if (dataArr.count < [PAGE_COUNT intValue]) {
                _SWtableView.footerHidden =YES;
            }
            else{
                _SWtableView.footerHidden = NO;
            }
            [_SWtableView reloadData];
            
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
            [self SWreducePage];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
        
        [_SWtableView footerEndRefreshing];
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
    SaiBean *commentBean = (SaiBean *)_SWdataArray[indexPath.row];
    [cell setCellInfo:commentBean];
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _SWdataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCell *cell = [[HomePageCell alloc] init];
    SaiBean *saibean = (SaiBean *)_SWdataArray[indexPath.row];
    CGFloat height = [cell returnHeight:saibean];
    
    return height;
}

#pragma mark
#pragma mark ===================== UIScrollView delegate ==================
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_SWsearchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *str = _SWsearchBar.text;
    if (!str && [str isEqualToString:@""]) {
        return;
    }
    [_SWsearchBar resignFirstResponder];
    // 调用接口
    [self SWrefreshDatas];
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
    [self SWrefreshDatas];
    
    
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
            [self SWrefreshCountData];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}


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
