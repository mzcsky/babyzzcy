//
//  SettingViewController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/1.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "RecommendToFriendController.h"
#import "DVersionView.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray     *dataArray;

@property (nonatomic,strong) NSString    *cacheData;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =  NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _dataArray = [[NSArray alloc] initWithObjects:@"清除缓存",@"意见建议",@"五星评价",@"关于", nil];
//    _dataArray = [[NSArray alloc] initWithObjects:@"清除缓存", @"关于", @"用户协议", nil];
    _dataArray =[[NSArray alloc] initWithObjects:@"清除缓存",@"用户协议" ,nil];
    [self countCache];
    
    [self initTableView];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self initTFooter];
}

- (void)initTFooter{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-230)]; //77
    footView.backgroundColor = CLEARCOLOR;
    _tableView.tableFooterView = footView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 31, SCREEN_WIDTH, 46)];
    view.backgroundColor = [UIColor whiteColor];
    [footView addSubview:view];
    
    UIButton *recommend = [UIButton buttonWithType:UIButtonTypeCustom];
    recommend.frame = view.frame;
    [recommend addTarget:self action:@selector(recommendClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:recommend];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-105, 46)];
    label.backgroundColor = CLEARCOLOR;
    label.font = FONT(15);
    label.text = @"将重在参与推荐给朋友";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    
    UIImage *image2 = [UIImage imageNamed:@"pc_arrow_r.png"];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-image2.size.width, (46-image2.size.height)/2, image2.size.width, image2.size.height)];
    [arrow setImage:image2];
    [view addSubview:arrow];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(SCREEN_WIDTH/2-150,footView.height-50, 300, 40);
    [exitBtn setBackgroundImage:[UIImage imageWithColor:XT_MAINCOLOR] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出重在参与" forState:UIControlStateNormal];
    [exitBtn setTitleColor:XT_BLACKCOLOR forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.titleLabel.font = FONT(14);
    [footView addSubview:exitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)countCache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    
    _cacheData = [NSString stringWithFormat:@"%.1fM", [self folderSizeAtPath:path]];
}

#pragma mark
#pragma mark ====== UITableView delegate datasource ======

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = SettingViewCellIdentifier;
    SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *name = [_dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        [cell setCellName:name andIsFirstRow:YES andDataStr:_cacheData];
    }
    else{
        [cell setCellName:name andIsFirstRow:NO andDataStr:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self clearData];
        }
            break;
        case 1:
        {
  
            DVersionView *view = [[DVersionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [view loadUrl:USER_PROTOCAL];
            [view setTitle:@"用户协议"];
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window addSubview:view];
            [view showAnimation];
        }
            break;
        case 2:
        {
            DVersionView *view = [[DVersionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [view loadUrl:@"http://saisaiapp.com/"];
            [view setTitle:@"关于"];
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            [window addSubview:view];
            [view showAnimation];
        }
            break;
        case 3:
        {
           
        }
            break;
        default:
            break;
    }
}

/**
 *  清理缓存
 */
-(void)clearData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
    for (NSString *p in files) {
        NSError *error;
        NSString *Path = [path stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
        }
    }
    _cacheData = [NSString stringWithFormat:@"%.1fM", [self folderSizeAtPath:path]];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[ indexpath] withRowAnimation:UITableViewRowAnimationFade];
}

//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/**
 *  推荐
 */
-(void)recommendClick{
    RecommendToFriendController *ctrller = [[RecommendToFriendController alloc] init];
    ctrller.m_showBackBt = YES;
    ctrller.title = @"推荐给朋友";
    [self.navigationController pushViewController:ctrller animated:YES];
}

/**
 *  退出登录
 */
-(void)exitBtnClick{
    [PXAlertView showAlertWithTitle:nil message:@"是否退出登录?" cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled) {
        if (!cancelled) {
            [super backBtPressed];
            [UserModel freeInfo];
            [[GlobalData shareInstance].mRootController setSelectedItem:0];
        }
    }];
}

@end
