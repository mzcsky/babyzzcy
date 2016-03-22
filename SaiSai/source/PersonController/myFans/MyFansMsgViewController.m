//
//  MyFansMsgViewController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/3/1.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "MyFansMsgViewController.h"
#import "PersonInfoController.h"
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
#import "AttendOrFansBean.h"
#import "SaiBean.h"
#define PCCELL      @"PCCELL"
@interface MyFansMsgViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) UITableView   *tableView;

@property (nonatomic, retain) UIImageView   *headIcon;

@property (nonatomic, retain) UILabel       *nameLabel;

@property (nonatomic, retain) NSArray       *iconArray;

@property (nonatomic, retain) NSArray       *nameArray;

@property (nonatomic, strong) NSString      *bid;

@end



@implementation MyFansMsgViewController
-(id)initWithBean:(AttendOrFansBean *)bean{
    if (self = [super init]) {
        self.userBean = bean;
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    if ([[UserModel shareInfo] isLogin]) {
        
        self.iconArray = [NSArray arrayWithObjects:@"pc_myworks.png", @"pc_myfocus.png", @"pc_myfance.png", @"pc_mypaticipate.png", nil];
        self.nameArray = [NSArray arrayWithObjects:@"参赛作品", @"关注", @"粉丝", @"参与的比赛", nil];
        
        [self initTableView];
        [self initTHeader];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TAB object:nil];
    // [_headIcon sd_setImageWithURL:[NSURL URLWithString:self.userBean.headImg]];
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:self.userBean.icon] placeholderImage:[UIImage imageNamed:@"ic_default_head_image"]];
    
    _nameLabel.text = self.userBean.nickName;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
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
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:self.userBean.icon] placeholderImage:[UIImage imageNamed:@"ic_default_head_image"]];
    _headIcon.backgroundColor = BACKGROUND_COLOR;
    [view addSubview:_headIcon];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-105, 54)];
    _nameLabel.backgroundColor = CLEARCOLOR;
    _nameLabel.font = FONT(15);
    _nameLabel.text =self.userBean.nickName;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor blackColor];
    [view addSubview:_nameLabel];
    
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
            MySaiSaiController *ctrl = [[MySaiSaiController alloc] initWithUserId:[self.userBean.bOrAId intValue] bOrAid:[self.userBean.bOrAId intValue]];
            
            
            
            ctrl.title = @"参赛作品";
            ctrl.m_showBackBt = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
            
        }
            break;
        case 1:
        {
            MyAttendController *ctrller = [[MyAttendController alloc] initWithUserId:[self.userBean.bOrAId intValue]];
            ctrller.m_showBackBt = YES;
            ctrller.title = @"关注";
            [self.navigationController pushViewController:ctrller animated:YES];
            
            XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
            [rootCtrller setmTabBarViewHidden:YES animation:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
            
        }
            break;
        case 2:
        {
            MyFansController *ctrller = [[MyFansController alloc] initWithUserId:[self.userBean.bOrAId intValue]];
            ctrller.m_showBackBt = YES;
            ctrller.title = @"粉丝";
            [self.navigationController pushViewController:ctrller animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
        }
            break;
            
        case 3:
        {
            MPMController *ctrl = [[MPMController alloc] initWithUserId:[self.userBean.bOrAId intValue]];
            ctrl.title = @"参与的比赛";
            ctrl.m_showBackBt = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
        }
            break;
            
        default:
            break;
    }
}


@end


