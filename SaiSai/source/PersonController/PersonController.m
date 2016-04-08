//
//  PersonController.m
//  SaiSai
//
//  Created by weige on 15/8/15.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MPMController.h"
#import "UIImageView+WebCache.h"
#import "PersonController.h"
#import "PCCell.h"
#import "PersonInfoController.h"
#import "MyAttendController.h"
#import "MyFansController.h"
#import "SettingViewController.h"
#import "CommentMsgController.h"
#import "MySaiSaiController.h"
#import "SearchFriendController.h"

#define PCCELL      @"PCCELL"

@interface PersonController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView   *tableView;

@property (nonatomic, retain) UIImageView   *headIcon;

@property (nonatomic, retain) UILabel       *nameLabel;

@property (nonatomic, retain) NSArray       *iconArray;

@property (nonatomic, retain) NSArray       *nameArray;

@end

@implementation PersonController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if ([[UserModel shareInfo] isLogin]) {
        //
        self.iconArray = [NSArray arrayWithObjects:@"hp_commentBg.png", @"pc_myworks.png", @"pc_myfocus.png", @"pc_myfance.png", @"pc_addFriends.png", @"pc_mypaticipate.png", nil];
        self.nameArray = [NSArray arrayWithObjects:@"评论消息", @"我的作品展", @"我的关注", @"我的粉丝", @"添加关注好友", @"我的参与(艺术素质测评发展指标)", nil];
        
        [self initTableView];
        [self initTHeader];
        [self initTFooter];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.TheadView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TAB object:nil];
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:[[UserModel shareInfo] icon]]];
    _nameLabel.text = [[UserModel shareInfo] nickName];
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.backgroundColor = CLEARCOLOR;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[PCCell class] forCellReuseIdentifier:PCCELL];
    [self.view addSubview:_tableView];
}

- (void)initTHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headerView.backgroundColor = CLEARCOLOR;
    _tableView.tableHeaderView = headerView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    view.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:view];
    
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 4, 46, 46)];
    _headIcon.layer.cornerRadius = 23;
    _headIcon.clipsToBounds = YES;
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:[[UserModel shareInfo] icon]] placeholderImage:[UIImage imageNamed:@"ic_default_head_image.png"]];
    _headIcon.backgroundColor = BACKGROUND_COLOR;
    [view addSubview:_headIcon];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-105, 54)];
    _nameLabel.backgroundColor = CLEARCOLOR;
    _nameLabel.font = FONT(15);
    _nameLabel.text = [[UserModel shareInfo] nickName];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [view addSubview:_nameLabel];
    
    UIImage *image = [UIImage imageNamed:@"pc_arrow_r.png"];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-image.size.width, (54-image.size.height)/2, image.size.width, image.size.height)];
    [arrow setImage:image];
    [view addSubview:arrow];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = CLEARCOLOR;
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    [btn addTarget:self action:@selector(showPSIC) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
}

- (void)initTFooter{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 77)];
    footView.backgroundColor = CLEARCOLOR;
    _tableView.tableFooterView = footView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 31, SCREEN_WIDTH, 46)];
    view.backgroundColor = [UIColor whiteColor];
    [footView addSubview:view];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = view.frame;
    [settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:settingBtn];
    
    UIImage *image = [UIImage imageNamed:@"pc_setting.png"];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(14, (46-image.size.height)/2, image.size.width, image.size.height)];
    [icon setImage:image];
    [view addSubview:icon];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-105, 46)];
    label.backgroundColor = CLEARCOLOR;
    label.font = FONT(15);
    label.text = @"设置";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    
    UIImage *image2 = [UIImage imageNamed:@"pc_arrow_r.png"];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-image2.size.width, (46-image2.size.height)/2, image2.size.width, image2.size.height)];
    [arrow setImage:image2];
    [view addSubview:arrow];
}

#pragma mark
#pragma mark ====== UITableView delegate datasource ======

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCCell *cell = [tableView dequeueReusableCellWithIdentifier:PCCELL];
    if (!cell) {
        cell = [[PCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PCCELL];
    }
    
    NSString *icon = [self.iconArray objectAtIndex:indexPath.row];
    NSString *name = [self.nameArray objectAtIndex:indexPath.row];
    [cell setIcon:icon];
    [cell setName:name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            CommentMsgController *ctrl = [[CommentMsgController alloc] init];
            ctrl.title = @"评论消息";
            ctrl.m_showBackBt = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
        }
            break;
        case 1:
        {
            MySaiSaiController *ctrl = [[MySaiSaiController alloc] initWithUserId:[[UserModel shareInfo] uid] bOrAid:[[UserModel shareInfo] uid]];
            ctrl.title = @"我的作品展";
            ctrl.m_showBackBt = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];

        }
            break;
        case 2:
        {
            MyAttendController *ctrller = [[MyAttendController alloc] initWithUserId:[[UserModel shareInfo] uid]];
            ctrller.m_showBackBt = YES;
            ctrller.title = @"我的关注";
            [self.navigationController pushViewController:ctrller animated:YES];
            
            XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
            [rootCtrller setmTabBarViewHidden:YES animation:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
            
        }
            break;
        case 3:
        {
            MyFansController *ctrller = [[MyFansController alloc] initWithUserId:[[UserModel shareInfo] uid]];
            ctrller.m_showBackBt = YES;
            ctrller.title = @"我的粉丝";
            
            [self.navigationController pushViewController:ctrller animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
        }
            break;
        case 4:
        {
            SearchFriendController *ctrller = [[SearchFriendController alloc] init];
            ctrller.m_showBackBt = YES;
            ctrller.title = @"添加好友";
            [self.navigationController pushViewController:ctrller animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
        }
            break;
        case 5:
        {
            MPMController *ctrl = [[MPMController alloc] initWithUserId:[[UserModel shareInfo] uid]];
            ctrl.title = @"我的参与(艺术素质测评发展指标)";
            ctrl.m_showBackBt = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
        }
            break;
            
        default:
            break;
    }    
}

- (void)showPSIC{
    PersonInfoController *ctrl = [[PersonInfoController alloc] init];
    ctrl.title = @"个人资料";
    ctrl.m_showBackBt = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}

-(void)settingClick{
    SettingViewController *ctrller = [[SettingViewController alloc] init];
    ctrller.title = @"设置";
    ctrller.m_showBackBt = YES;
    [self.navigationController pushViewController:ctrller animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}

@end
