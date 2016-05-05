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
#import "JTCalendar.h"


#define CellHeight lunViewHeight+60
@interface QingZiShowController ()<UITableViewDelegate, UITableViewDataSource, QingZiShowCellDelegate,WJMenuDelegate,JTCalendarDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataValueArr;
@property (nonatomic, strong) NSArray * plistArr;
@property (nonatomic, strong) UIView * NaviBarView;
@property (nonatomic, strong) NSMutableArray * data;

@property (nonatomic, strong) WJDropdownMenu * menu;

@property (nonatomic,assign) CGFloat lastContentOffset;

/**
 *  下拉菜单所在的view
 */
@property (nonatomic,strong) UIView * downView;
@property (nonatomic,strong) NSArray * downBtnArr;

/**
 *  日历所在的背景view
 */
@property (nonatomic,strong) UIView * calendarBacView;

@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (strong, nonatomic) NSLayoutConstraint *calendarContentViewHeight;

@end


@implementation QingZiShowController{
    NSInteger     QZpage;
    
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
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

    //添加下拉按钮所在视图
    [self.view addSubview:self.downView];
//    [self getDataValue];
}

- (UIView *)downView{

    if (!_downView) {
        _downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.menu.bottom, SCREEN_WIDTH, 30)];
        _downView.backgroundColor = [UIColor blackColor];
        _downView.alpha = 0.3;
        
        //设置三个按钮
        NSString * dateStr = [[self dateFormatter] stringFromDate:[NSDate date]];
        NSArray * titleArr = @[@"距离",dateStr,@"天数"];
        
        NSMutableArray * tempArr = [NSMutableArray array];
        for (int i = 0; i < titleArr.count; i ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGFloat btnW = SCREEN_WIDTH/titleArr.count;
            CGFloat btnH = _downView.height;
            CGFloat btnX = btnW*i;
            button.frame = CGRectMake(btnX, 0, btnW, btnH);
            
            //设置属性
            UIImage * downImg = [UIImage imageNamed:@"mc_arrowDn"];
            UIImage * upImg = [UIImage imageNamed:@"mc_arrowUp"];
            
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button setImage:downImg forState:UIControlStateNormal];
            [button setImage:upImg forState:UIControlStateSelected];
            button.titleLabel.font = FONT(14);
            button.titleLabel.textColor = [UIColor lightGrayColor];
            
            button.tag = i;
            
            CGSize textSize = textSizeFont(titleArr[i], FONT(14), MAXFLOAT, MAXFLOAT);
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, textSize.width+2, 0, -textSize.width-2)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -downImg.size.width, 0, downImg.size.width)];
            
            //点击事件
            [button addTarget:self action:@selector(downViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_downView addSubview:button];
            
            [tempArr addObject:button];
        }
        self.downBtnArr = tempArr;
    }
    return _downView;
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
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _lastContentOffset = scrollView.contentOffset.y;
    if (_calendarBacView) {
        [self canlendarViewDisAppearWithAnimate:YES];
        
        for (UIButton * btn in self.downBtnArr) {
            if (btn.tag==1) {
                btn.selected = NO;
            }
        }
    }
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (_lastContentOffset < scrollView.contentOffset.y) {
        NSLog(@"向上滚动");
    }else{
        NSLog(@"向下滚动");
    }
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




#pragma ---mark---下拉菜单所用

/**
 *  下拉按钮点击事件
 *
 *  @param sender 点击按钮tag 0:距离 1:日期 2:天数
 */
- (void)downViewBtnClick:(UIButton *)sender{

    sender.selected = !sender.selected;
    
    if (sender.selected) {//将另外两个按钮点击状态设为NO
        for (UIButton * btn in self.downBtnArr) {
            
            if (btn.tag != sender.tag) {
                btn.selected = NO;
            }
        }
    }
    
    //实现各个按钮点击事件
    if (sender.tag==0) {//距离
        
    }else if (sender.tag==1){//日历
    
        if (sender.selected) {
           
            [self calendarBacView];
            [self calendarViewAppear];
            
        }else{
            
            [self canlendarViewDisAppearWithAnimate:YES];
        }
    }else if (sender.tag==2){//天数
    
    }
}
/**
 *  日历出现动画
 */
- (void)calendarViewAppear{

    [UIView animateWithDuration:0.2 animations:^{
        
        _calendarMenuView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
        _calendarContentView.frame = CGRectMake(0, _calendarMenuView.bottom, self.view.frame.size.width, self.view.frame.size.width*3/4);
        
        CGFloat canlendarH = _calendarMenuView.height+_calendarContentView.height;
        self.calendarBacView.frame = CGRectMake(0, _downView.bottom, SCREEN_WIDTH, canlendarH);
        
        CGFloat currentY = canlendarH+_downView.height;
        
        [self.tableView setContentOffset:CGPointMake(0, -currentY) animated:YES];
        
    }];
}
/**
 *  日历消失动画
 */
- (void)canlendarViewDisAppearWithAnimate:(BOOL)animate{

    CGFloat time = (animate) ? 0.2 : 0;
    [UIView animateWithDuration:time animations:^{
        
        [_calendarMenuView removeFromSuperview];
        [_calendarContentView removeFromSuperview];
        
        self.calendarBacView.frame = CGRectMake(0, _downView.bottom, SCREEN_WIDTH, 0);
        
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    } completion:^(BOOL finished) {
        [self removeCalendarView];
        
    }];
}
/**
 *  删除日历
 */
- (void)removeCalendarView{
    
    [_calendarBacView removeFromSuperview];
    _calendarBacView = nil;
    
}
/**
 *  设置日期格式
 */
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

- (UIView *)calendarBacView{

    if (!_calendarBacView) {
        _calendarBacView = [[UIView alloc] initWithFrame:CGRectMake(0, self.downView.bottom, SCREEN_WIDTH, 0)];
        _calendarBacView.backgroundColor = [UIColor colorWithRed:253./255.0 green:213/255.0 blue:233/255.0 alpha:1];
        
        
        [self.view addSubview:_calendarBacView];
        
        _calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _calendarMenuView.backgroundColor = [UIColor colorWithRed:253./255.0 green:213/255.0 blue:233/255.0 alpha:1];

        [_calendarBacView addSubview:_calendarMenuView];
        
        _calendarContentView  = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 0)];
        _calendarContentView.backgroundColor = [UIColor colorWithRed:253./255.0 green:213/255.0 blue:233/255.0 alpha:1];
        [_calendarBacView addSubview:_calendarContentView];
        
        _calendarManager = [JTCalendarManager new];
        _calendarManager.delegate = self;
        
        // Generate random events sort by date using a dateformatter for the demonstration
        [self createRandomEvents];
        
        // Create a min and max date for limit the calendar, optional
        [self createMinAndMaxDate];
        
        [_calendarManager setMenuView:_calendarMenuView];
        [_calendarManager setContentView:_calendarContentView];
        [_calendarManager setDate:_todayDate];

    }
    
    return _calendarBacView;
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}
#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor clearColor];
        dayView.dotView.textColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor clearColor];
        dayView.dotView.textColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor clearColor];
        dayView.dotView.textColor = [UIColor lightGrayColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor clearColor];
        dayView.dotView.textColor = [UIColor blackColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma ----mark----界面将要消失时
- (void)viewWillDisappear:(BOOL)animated{

    if (_calendarBacView) {
        [self canlendarViewDisAppearWithAnimate:NO];
        
        for (UIButton * btn in self.downBtnArr) {
            if (btn.tag==1) {
                btn.selected = NO;
            }
        }
    }
}

@end
