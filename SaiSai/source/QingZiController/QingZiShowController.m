//
//  QingZiShowController.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/20.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "QingZiShowController.h"
#import "QingZiShowCell.h"
#import "ProductDetailsController.h"
#import "WJDropdownMenu.h"


#define CellHeight lunViewHeight+60
@interface QingZiShowController ()<UITableViewDelegate, UITableViewDataSource, QingZiShowCellDelegate,WJMenuDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataValueArr;
@property (nonatomic, strong) NSArray * plistArr;
@property (nonatomic, strong) UIView * NaviBarView;
@property (nonatomic, strong) NSMutableArray * data;

@property (nonatomic, strong) WJDropdownMenu * menu;
@property (nonatomic, strong) WJDropdownMenu * menu2;



@end

@implementation QingZiShowController{
    NSInteger     QZpage;
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    XTTabBarController * rootCtrller = [GlobalData shareInstance].mRootController;
    [rootCtrller setmTabBarViewHidden:YES animation:YES];
    self.TheadView.hidden = NO;
    
}
- (void)initdata{
    QZpage = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self initHeaderView];
    [self initTableView];
    [self plistArr];

//    [self getDataValue];
}


//返回按钮
- (void)initHeaderView{
    
    WJDropdownMenu *menu = [[WJDropdownMenu alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    menu.delegate = self;
    menu.tag = 0;
    self.menu = menu;
    
    menu.caverAnimationTime = 0.2;//  增加了遮盖层动画时间设置   不设置默认是  0.15
    menu.menuTitleFont = 12;      //  设置menuTitle字体大小    不设置默认是  11
    menu.tableTitleFont = 11;     //  设置tableTitle字体大小   不设置默认是  10
    menu.cellHeight = 38;         //  设置tableViewcell高度   不设置默认是  40
    menu.menuArrowStyle = menuArrowStyleSolid; // 旋转箭头的样式(空心箭头 or 实心箭头)
    menu.tableViewMaxHeight = 200; // tableView的最大高度(超过此高度就可以滑动显示)
    menu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];//设置遮罩层颜色
    
    [self createAllMenuData];
    
    UIButton *Navbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Navbtn.frame = CGRectMake(15, 10, 20, 27);
    [Navbtn setImage:[self imageAutomaticName:@"arrowBack@2x.png"] forState:UIControlStateNormal];
    [Navbtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    


    [menu addSubview:Navbtn];
    
    [self.view addSubview:menu];

}

- (void)createAllMenuData{
    NSArray *threeMenuTitleArray =  @[@"分类",@"年龄",@"评价"];
    NSArray *firstArrOne = [NSArray arrayWithObjects:@"精神科",@"耳鼻喉",@"妇科",@"去污科", nil];
    NSArray *firstMenu = [NSArray arrayWithObject:firstArrOne];
    
     NSArray *firstArrTwo = [NSArray arrayWithObjects:@"0岁",@"1岁",@"2岁",@"3岁",@"4岁",@"5岁",@"6岁",@"7岁",@"8岁",@"9岁",@"10岁",@"11岁",@"12岁",nil];
    NSArray *secondMenu = [NSArray arrayWithObjects:firstArrTwo, nil];

    NSArray *firstArrTherr =[NSArray arrayWithObjects:@"前3",@"前5",@"前10",@"前20",@"前40",@"前100",nil];
    NSArray *therrMenu = [NSArray arrayWithObject:firstArrTherr];
    [self.menu createThreeMenuTitleArray:threeMenuTitleArray FirstArr:firstMenu SecondArr:secondMenu threeArr:therrMenu];
    [self.view bringSubviewToFront:_menu];


}



- (void)menuCellDidSelected:(NSInteger)MenuTitleIndex firstIndex:(NSInteger)firstIndex secondIndex:(NSInteger)secondIndex thirdIndex:(NSInteger)thirdIndex{
    

}

/** 代理方法返回 菜单标题:MenuTitle  一级菜单内容:firstContent 二级菜单内容:secondContent  三级菜单内容:thirdContent */
- (void)menuCellDidSelected:(NSString *)MenuTitle firstContent:(NSString *)firstContent secondContent:(NSString *)secondContent thirdContent:(NSString *)thirdContent{


    
    self.data = [NSMutableArray array];
    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 1",secondContent]];
    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 2",secondContent]];
    [self.data addObject:[NSString stringWithFormat:@"%@ 的 detail data 3",secondContent]];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];

    
}

#pragma mark ===============演出展览数据请求==================
//- (void)getDataValue{
//    NSDictionary *pram = [HttpBody PrivilegeCheckBox:(int)QZpage rows:10 datavalue:(int)self.model.datavalue];
//    
//    [ProgressHUD show:LOADING];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager GET:URL_Button parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
//    
//    
//    }];
//}




#pragma mark ===============UITableViewDataSource===============
//设置表格的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//设置每个组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _plistArr.count;
}

//设置单元格显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        PlistModel * Pmodel = [_plistArr objectAtIndex:indexPath.row];
        QingZiShowCell *cell = [QingZiShowCell valueWithTableView:tableView indexPath:indexPath];
        cell.delegate = self;
        cell.Pmodel = Pmodel;
        return cell;

}

#pragma mark =============== UITableViewDelegate代理方法===============
//设置每行Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ProductDetailsController *PDVC = [[ProductDetailsController alloc]init];
        [self.navigationController pushViewController:PDVC animated:YES];

    }
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


//图片自适应方法
- (UIImage *)imageAutomaticName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    // 计算缩放率 - 3.0f是5.5寸屏的屏密度
    double scale = 3.0f / (SCREEN_WIDTH/414.f);
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
}


- (void)btnClick{
    [self.navigationController popViewControllerAnimated:YES];
}








@end
