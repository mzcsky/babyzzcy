//  XTViewController.m
//  Created by zf on 15-7-02.
//  Copyright (c) 2015年 . All rights reserved.

#import "XTViewController.h"
#import "RegexKitLite.h"
@implementation XTViewController
@synthesize m_showBackBt,m_showRefurbishBt,m_showRefurbishing;
@synthesize m_showRightBt;
@synthesize mRightBtnTitle;
@synthesize mLeftBtnTitle;
@synthesize mIsMainPage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS_VERSION >= 7) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        self.m_hasNav = YES;
    }
    return self;
}

#pragma mark--iOS7&iOS6适配--

- (UIStatusBarStyle)preferredStatusBarStyle

{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:FONT(19)];
    [titleLabel setText:self.title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.tag = 1000;
    [self.navigationItem setTitleView:titleLabel];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backBtPressed)];
    _leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:_leftSwipeGestureRecognizer];
}

- (void)updateTitleLabel:(NSString *)text
{
    titleLabel.text = text;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setM_showBackBt:(BOOL)isShow
{
    m_showBackBt = isShow;
    
    if (m_showBackBt)
    {
        [self createBtnBack];
    }
    else {
        [self.navigationItem setHidesBackButton:YES];
    }
}

- (void)setM_showRightBt:(BOOL)showRightBt
{
    m_showRightBt = showRightBt;
    
    if( m_showRightBt )
    {
        [self createRightBtn];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

/**
 *  初始化右侧按钮
 */
- (void)createRightBtn
{
    CGFloat detailwidth = [mRightBtnTitle sizeWithFont:Bold_FONT(15) constrainedToSize:CGSizeMake(100, 31)].width;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, detailwidth, 31)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:mRightBtnTitle forState:UIControlStateNormal];
    rightButton.titleLabel.font = Bold_FONT(15);
    rightButton.titleLabel.frame = rightButton.frame;
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = leftItem;
}

/**
 *  右侧按钮触发事件
 */
- (void)rightBtnPressed
{
    
}

/**
 *  初始化返回按钮
 */
-(void)createBtnBack
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    if (mLeftBtnTitle && ![mLeftBtnTitle isEqualToString:@""] && mLeftBtnTitle != nil) {
        leftButton.frame = CGRectMake(0, 0, 20, 36);
        [leftButton setTitle:mLeftBtnTitle forState:UIControlStateNormal];
        leftButton.titleLabel.font = Bold_FONT(17);
        leftButton.titleLabel.frame = leftButton.frame;
    }
    else
    {
        [leftButton setImage:[UIImage imageNamed:@"arrowBack.png"] forState:UIControlStateNormal];
       // [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    }
    
    leftButton.exclusiveTouch = YES;
    [leftButton addTarget:self action:@selector(backBtPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)createLeftBarItem:(UIImage *)image sel:(SEL)action{
    int height = 44;
    if (IOS_VERSION>=7) {
        height = 64;
    }
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, image.size.width, height);
    leftBtn.exclusiveTouch = YES;
    [leftBtn setImage:image forState:UIControlStateNormal];
    [leftBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)createRightBarItem:(UIImage *)image sel:(SEL)action{
    int height = 44;
    if (IOS_VERSION>=7) {
        height = 64;
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-image.size.width, 0, image.size.width, height);
    [rightBtn setImage:image forState:UIControlStateNormal];
    rightBtn.exclusiveTouch = YES;
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //注册键盘显示与消失的通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除键盘显示与消失的通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  返回事件
 */
-(void)backBtPressed
{
    if (self.m_hasNav) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//网络
-(void) netFinished:(id)aResult reqType:(NSInteger)aReqType
{
    
}
-(void) netFailed:(NSInteger)aReqType
{
    
}


//键盘弹出、落下
- (void) keyboardWasShown:(NSNotification *) notif
{
    
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)validateMobile:(NSString *)mobileNum
{
    if (nil == mobileNum || [mobileNum isEqualToString:@""]) {
        [ProgressHUD showError:@"手机号不能为空"];
        return  NO;
    }
    if (11 != mobileNum.length) {
        [ProgressHUD showError:@"手机格式错误"];
        return NO;
    }
    
    if (![[mobileNum substringToIndex:1] isEqualToString:@"1"]) {
        [ProgressHUD showError:@"手机格式错误"];
        return NO;
    }
    return YES;
}

- (BOOL)validatePsw:(NSString *)password
{
    if (password == nil || password == NULL || [password isKindOfClass:[NSNull class]]) {
        [PXAlertView showAlertWithTitle:@"提示" message:@"密码不能为空"];
        return NO;
    }
  //  判断是否有特殊字符
    BOOL check = [password isMatchedByRegex:@"^[A-Za-z0-9\u4e00-\u9fa5]+$"];
    if (!check) {
        [PXAlertView showAlertWithTitle:@"提示" message:@"密码不能有特殊字符，请重新输入..."];
        return check;
    }
    //判断密码是否太过简单
    if (password.length<6 || password.length>20) {
        [PXAlertView showAlertWithTitle:@"提示" message:@"密码为6-11位，数字+字母"];
        return NO;
    }
    return YES;
}
@end
