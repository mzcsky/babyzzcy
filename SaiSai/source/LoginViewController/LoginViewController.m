//
//  LoginViewController.m
//  SaiSai
//
//  Created by weige on 15/8/15.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <TencentOpenAPI/TencentOAuth.h>
#import "MyButton.h"
#import "LoginViewController.h"
#import "RegisteController.h"
#import "NSString+MD5.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
#import "ForgetPswController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "DVersionView.h"

@interface LoginViewController ()<UITextFieldDelegate, DVersionViewDelegate, RegisteControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UIScrollView      *scrollView;

@property (nonatomic, retain) UITextField       *mobileField;

@property (nonatomic, retain) UITextField       *pswField;

@property (nonatomic, assign) int               tag;

@property (nonatomic, strong) DVersionView      *dversionView;

@property (nonatomic, retain) NSMutableArray    *muarray;

@end

@implementation LoginViewController{
    UITableView * _tableView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.muarray = [NSMutableArray array];
    [self initScrollView];
    [self initLogoView];
    [self initInputView];
    [self initButtons];
    
}

- (void)initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.backgroundColor = CLEARCOLOR;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 520);
    [self.view addSubview:_scrollView];
}

- (void)initLogoView{
    UIImage *image = [UIImage imageNamed:@"zzcy.png"];
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-image.size.width)/2, 45, image.size.width, image.size.height)];
    [logoView setImage:image];
    [_scrollView addSubview:logoView];
}

- (void)initInputView{
    UIImage *image = [UIImage imageNamed:@"login_input_bg.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 65, 10, 20)];
    UIImage *mobile = [UIImage imageNamed:@"login_mobile.png"];
    UIImage *psw = [UIImage imageNamed:@"login_psw.png"];
    
    UIView *mview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 51, 42)];
    UIImageView *mlview = [[UIImageView alloc] initWithFrame:CGRectMake(-2, 0, 51, 42)];
    mlview.contentMode = UIViewContentModeCenter;
    [mlview setImage:mobile];
    [mview addSubview:mlview];
    _mobileField = [[UITextField alloc] initWithFrame:CGRectMake(35, 135, SCREEN_WIDTH-70, image.size.height)];
    _mobileField.background = image;
    _mobileField.leftView = mview;
    _mobileField.delegate = self;
    _mobileField.placeholder = @"手机号";
    _mobileField.leftViewMode = UITextFieldViewModeAlways;
    _mobileField.clearsOnBeginEditing = NO;
    
    NSMutableArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    if (array && array.count !=0) {
        _mobileField.text = [array lastObject];
    }
    
    [_scrollView addSubview:_mobileField];
    //记录账号 按钮
    UIButton * imageBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBnt.frame = CGRectMake(SCREEN_WIDTH-70-5, 135, 42, 42);
    [imageBnt setImage:[UIImage imageNamed:@"mc_arrowDn.png"] forState:UIControlStateNormal];//正常图片
     [imageBnt setImage:[UIImage imageNamed:@"mc_arrowUp.png"] forState:UIControlStateSelected];//选中图片
    imageBnt.tag = 1111;
    [imageBnt addTarget:self action:@selector(imageBntClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:imageBnt];
    
    //登陆账号 弹出框
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(_mobileField.origin.x+43, _mobileField.bottom, _mobileField.width-43, 200) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.tableFooterView = [[UIView alloc]init];

    
    UIView *pview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 51, 42)];
    UIImageView *plview = [[UIImageView alloc] initWithFrame:CGRectMake(-2, 0, 51, 42)];
    plview.contentMode = UIViewContentModeCenter;
    [plview setImage:psw];
    [pview addSubview:plview];
    _pswField = [[UITextField alloc] initWithFrame:CGRectMake(35, 182, SCREEN_WIDTH-70, image.size.height)];
    _pswField.background = image;
    _pswField.leftView = pview;
    _pswField.delegate = self;
    _pswField.placeholder = @"密码";
    _pswField.secureTextEntry = YES;
    _pswField.leftViewMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_pswField];
}

- (void)initButtons{
    UIImage *loImage = [UIImage imageNamed:@"login_loginBtn.png"];
    UIImage *reImage = [UIImage imageNamed:@"login_registerBtn.png"];
    UIImage *wxImage = [UIImage imageNamed:@"login_weixin.png"];
    UIImage *wbImage = [UIImage imageNamed:@"login_weibo.png"];
    UIImage *qqImage = [UIImage imageNamed:@"login_qq.png"];
    NSArray *array = [NSArray arrayWithObjects:wxImage, wbImage, qqImage, nil];
    NSArray *names = [NSArray arrayWithObjects:@"微信", @"微博", @"QQ", nil];
    loImage = [loImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    reImage = [reImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = CLEARCOLOR;
    [loginBtn setBackgroundImage:loImage forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = FONT(16);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(35, 235, SCREEN_WIDTH-70, loImage.size.height);
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:loginBtn];
    
    UIButton *reBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reBtn.backgroundColor = CLEARCOLOR;
    [reBtn setBackgroundImage:reImage forState:UIControlStateNormal];
    [reBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    reBtn.titleLabel.font = FONT(16);
    [reBtn setTitleColor:[UIColor colorWithRed:139.0/255.0f green:140.0/255.0f blue:142.0/255.0f alpha:1] forState:UIControlStateNormal];
    reBtn.frame = CGRectMake(35, 280, SCREEN_WIDTH-70, loImage.size.height);
    [reBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:reBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(SCREEN_WIDTH-97, 330, 65, 22);
    forgetBtn.backgroundColor = CLEARCOLOR;
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor colorWithRed:129.0/255.0f green:87.0/255.0f blue:91.0/255.0f alpha:1] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = FONT(12);
    [forgetBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:forgetBtn];
    
    UILabel *coLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 390, SCREEN_WIDTH, 20)];
    coLabel.backgroundColor = CLEARCOLOR;
    coLabel.font = FONT(12);
    coLabel.text = @"合作账号登录";
    coLabel.textAlignment = NSTextAlignmentCenter;
    coLabel.textColor = [UIColor colorWithRed:139.0/255.0f green:140.0/255.0f blue:142.0/255.0f alpha:1];
    [_scrollView addSubview:coLabel];
    
    BOOL isShowCO = NO;
    CGFloat width = SCREEN_WIDTH/3;
    for (int i = 0; i < 3; i++) {
        if (i==0 && ![WXApi isWXAppInstalled]) {
            continue;
        }
        if (i==1 && ![WeiboSDK isWeiboAppInstalled]) {
            continue;
        }
        if (i==2 && ![TencentOAuth iphoneQQInstalled]) {
            continue;
        }
        
        isShowCO = YES;
        UIImage *image = [array objectAtIndex:i];
        NSString *name = [names objectAtIndex:i];
        UIButton *button = [[MyButton alloc] initWithFrame:CGRectMake(i*width, 410, width, 88)];
        button.tag = i+100;
        button.backgroundColor = CLEARCOLOR;
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:139.0/255.0f green:140.0/255.0f blue:142.0/255.0f alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(11);
        [button addTarget:self action:@selector(thiredLogin:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    coLabel.hidden = !isShowCO;
     [_scrollView addSubview:_tableView];
}

- (void)loginAction{
    NSString *phone = _mobileField.text;
    NSString *psw = _pswField.text;

    
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    psw = [psw stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phone == nil || [phone isEqualToString:@""]) {
        [ProgressHUD showError:@"手机号不能为空！"];
        return;
    }
    if (psw == nil || [psw isEqualToString:@""]) {
        [ProgressHUD showError:@"密码不能为空！"];
        return;
    }
    psw = [NSString getMD5String:psw];
    
    [ProgressHUD show:LOADING];
    NSDictionary *pram = [HttpBody loginBody:phone psw:psw];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            [ProgressHUD dismiss];
            [[UserModel shareInfo] setUserInfo:[resDict objectForKey:@"data"]];
            
            //账号存储 储存到可变集合中
            NSMutableArray * array = [[[NSUserDefaults standardUserDefaults] objectForKey:KUserName] mutableCopy];
            //如果 集合或者集合个数不等于0
            if (array &&array.count !=0) {
                //进行对比 储存
                NSPredicate * predi = [NSPredicate predicateWithFormat:@"self = %@",_mobileField.text];
                //把结果储存到tempArray集合里
                NSArray * tempArray = [array filteredArrayUsingPredicate:predi];
            //如果没有 将数据加入数组中 进行储存
                if (tempArray.count ==0 ) {
                    [array addObject:_mobileField.text];
                     [[NSUserDefaults standardUserDefaults] setValue:array forKey:KUserName];
                }
                //否则集合就等以可变集合中的数据  进行本地储存
            }else{
                array = [NSMutableArray arrayWithArray:@[_mobileField.text]];
                [[NSUserDefaults standardUserDefaults] setValue:array forKey:KUserName];
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                 NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:HP_REFRESH object:nil];
            }];
        }else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)registerAction{
    RegisteController *ctrller = [[RegisteController alloc] init];
    ctrller.title = @"注册";
    ctrller.delegate = self;
    ctrller.m_showBackBt = YES;
    [self.navigationController pushViewController:ctrller animated:YES];
}

- (void)forgetAction{
    ForgetPswController *ctrller = [[ForgetPswController alloc] init];
    ctrller.title = @"忘记密码";
    ctrller.m_showBackBt = YES;
    [self.navigationController pushViewController:ctrller animated:YES];
}

- (void)thiredLogin:(id)sender{
    UIButton *button = (UIButton *)sender;
    self.tag = (int)button.tag;
    
    if (!_dversionView) {
        _dversionView = [[DVersionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_dversionView loadUrlForLogin:USER_PROTOCAL];
        _dversionView.delegate = self;
        [_dversionView setTitle:@"用户协议"];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_dversionView];
    [_dversionView showAnimation];
}

- (void)thriedPartLogin:(int)index{
    switch (index) {
        case 100:   //微信
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    
                    
                    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                        NSLog(@"SnsInformation is %@",response.data);
                        
                        if ([response.data objectForKey:@"openid"] && snsAccount.userName && snsAccount.iconURL) {
                            [self thirdLoginWithOpenId:[response.data objectForKey:@"openid"] nickName:snsAccount.userName icon:snsAccount.iconURL];
                        }
                    }];
                }
            });
        }
            break;
        case 101:   //微博
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    
                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    
                    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                        NSLog(@"SnsInformation is %@",response.data);
                        if ([response.data objectForKey:@"access_token"] && snsAccount.userName && snsAccount.iconURL) {
                            [self thirdLoginWithOpenId:[response.data objectForKey:@"access_token"] nickName:snsAccount.userName icon:snsAccount.iconURL];
                        }
                    }];
                }});
        }
            break;
        case 102:   //QQ
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                //          获取微博用户名、uid、token等
                if (response.responseCode == UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    NSLog(@"username is %@, uid is %@, token is %@ iconUrl is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    //[self getQQUserInfo];
                    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
                        NSLog(@"SnsInformation is %@",response.data);
                        if ([response.data objectForKey:@"openid"] && snsAccount.userName && snsAccount.iconURL) {
                            [self thirdLoginWithOpenId:[response.data objectForKey:@"openid"] nickName:snsAccount.userName icon:snsAccount.iconURL];
                        }
                    }];
                }
            });
        }
            break;
            
        default:
            break;
    }
}

- (void)getQQUserInfo
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQzone  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == _mobileField) {
        [_pswField becomeFirstResponder];
    }
    return YES;
}

/**
 *  第三方登陆
 *
 *  @param openId
 */
- (void)thirdLoginWithOpenId:(NSString *)openId nickName:(NSString *)nickName icon:(NSString *)icon{
    
    [ProgressHUD show:LOADING];
    NSDictionary *pram = [HttpBody unionLoginBody:openId nickName:nickName icon:icon];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            [ProgressHUD dismiss];
            [[UserModel shareInfo] setUserInfo:[resDict objectForKey:@"data"]];
            [self dismissViewControllerAnimated:YES completion:^{
                NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                [notificationCenter postNotificationName:HP_REFRESH object:nil];
            }];
        }else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)comfirmUserProtocal{
    [self thriedPartLogin:self.tag];
    if (_dversionView) {
        [_dversionView dismissDV];
    }
}

/**
 *  @author Xinwei  Ge, 15-12-08 12:23:15
 *
 *  注册成功回调
 *
 *  @param uname 用户名
 *  @param psw   密码
 */
- (void)registerSuccees:(NSString *)uname psw:(NSString *)psw{
    _mobileField.text = uname;
    _pswField.text = psw;
    [self loginAction];
}

#pragma mark - tableviewDellegate
//返回数组里元素个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     self.muarray = [[[NSUserDefaults standardUserDefaults] objectForKey:KUserName] mutableCopy];
    if (self.muarray) {
        return self.muarray.count;
    }else{
        return 0;
    }
    
}
//高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
//TableViewCell 点击显示在Cell上的内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    cell.textLabel.text =array[indexPath.row];
    return cell;
   
}
//点击收回后
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    _mobileField.text = array[indexPath.row];
    _tableView.hidden = YES;
    UIButton * bnt = [_scrollView viewWithTag:1111];
    bnt.selected = NO;
}


#pragma mark -Actions
//按钮状态
-(void)imageBntClick:(UIButton*)sender{
    _tableView.hidden =sender.selected;
     sender.selected = !sender.selected;
}
#pragma mark - 删除






@end
