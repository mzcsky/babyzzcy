//
//  RegisteController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//
#import "DVersionView.h"
#import "RegisteController.h"
#import "MyButton.h"
#import "NDDataPicker.h"
#import "NSString+MD5.h"
@interface RegisteController () <NDDataPickerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView      *scrollView;

@property (nonatomic, strong) UITextField       *mobileField;

@property (nonatomic, strong) UITextField       *codeField;

@property (nonatomic, strong) UITextField       *pswField;

@property (nonatomic, strong) UITextField       *nickNameField;

@property (nonatomic, strong) UILabel           *sexLab;

@property (nonatomic, strong) NDDataPicker      *dataPicker;

@property (nonatomic, strong) NSArray           *sexDataArr;

@property (nonatomic, assign) int                sexIndex;

@property (nonatomic, strong) UIButton          *getVerCodeBtn;

@property (nonatomic, strong) UIButton          *selBtn;
@property (nonatomic, strong) NSString         *lastYZM;

@property (nonatomic, strong) UIButton         *sexBtn;


@end

@implementation RegisteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sexDataArr = [[NSArray alloc] initWithObjects:@"男",@"女", nil];
    _sexIndex = -1;
    
    [self initScrollView];
    [self initViews];
    [self createRegisteBtn];
    [self createUserProtocolBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.backgroundColor = CLEARCOLOR;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,800);
    [self.view addSubview:_scrollView];
}

- (void)createUserProtocolBtn{
    UIImage *selNor = [UIImage imageNamed:@"sel_nor"];
    UIImage *selSel = [UIImage imageNamed:@"sel_sel"];
    
    _selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selBtn.frame = CGRectMake(15, 300, 40, 40);
    [_selBtn setImage:selNor forState:UIControlStateNormal];
    [_selBtn setImage:selSel forState:UIControlStateSelected];
    [_selBtn addTarget:self action:@selector(selAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_selBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 300, 180, 40)];
    label.backgroundColor = CLEARCOLOR;
    label.font = FONT(14);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = XT_MAINCOLOR;
    label.text = @"用户协议(点击阅读)";
    [_scrollView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(48, 329, 120, 0.5)];
    line.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:line];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(48, 300, 180, 40);
    button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
    [button addTarget:self action:@selector(showUserProtocol1) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
}

- (void)selAction{
    _selBtn.selected = !_selBtn.selected;
}

- (void)showUserProtocol1{
    DVersionView *view = [[DVersionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view loadUrl:USER_PROTOCAL];
    [view setTitle:@"用户协议"];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:view];
    [view showAnimation];
    
}

-(void)createRegisteBtn{
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(15, 240, SCREEN_WIDTH-30, 40);
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.clipsToBounds = YES;
    registBtn.layer.cornerRadius = 8.f;
    [registBtn setBackgroundImage:[UIImage imageWithColor:XT_MAINCOLOR] forState:UIControlStateNormal];
    [registBtn setTitleColor:XT_BLACKCOLOR forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:registBtn];
}

-(void)initViews{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:contentView];
    
    _mobileField = [self createTextFieldWithTop:0 andPlaceHold:@"请输入手机号"];
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_mobileField];
    
    [self createGetCodeBtn];
    
    _codeField = [self createTextFieldWithTop:40 andPlaceHold:@"验证码"];
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:_codeField];
    
    _nickNameField = [self createTextFieldWithTop:80 andPlaceHold:@"昵称"];
    [_scrollView addSubview:_nickNameField];
    
    _sexLab = [self createSexLabel:120 andTitle:@"性别(选填)"];
    [_scrollView addSubview:_sexLab];
    
    _pswField = [self createTextFieldWithTop:160 andPlaceHold:@"请设置密码"];
    _pswField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _pswField.secureTextEntry = YES;
    [_scrollView addSubview:_pswField];
}

-(void)createGetCodeBtn{
    _getVerCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140,0,140,40)];
    [_getVerCodeBtn setTitleColor:XT_MAINCOLOR forState:UIControlStateNormal];
    [_getVerCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _getVerCodeBtn.exclusiveTouch = YES;
    _getVerCodeBtn.titleLabel.font = FONT(13);
    [_getVerCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_getVerCodeBtn];
}

-(UITextField *)createTextFieldWithTop:(CGFloat)top andPlaceHold:(NSString *)holder{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, top, SCREEN_WIDTH, 40)];
    textField.backgroundColor = CLEARCOLOR;
    textField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = FONT(13);
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:holder attributes:@{NSForegroundColorAttributeName: XT_TEXTGRAYCOLOR}];
    textField.delegate = self;
    textField.textColor = XT_BLACKCOLOR;
    
    [self initImgView:top+39.5];
    
    return textField;
}

-(UILabel *)createSexLabel:(CGFloat)topH andTitle:(NSString *)title{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, topH,100, 40)];
    lab.backgroundColor = CLEARCOLOR;
    lab.font = FONT(13);
    lab.text = title;
    lab.textColor = XT_TEXTGRAYCOLOR;
    
    [self initImgView:topH + 39.5];
    
    _sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sexBtn.frame = CGRectMake(SCREEN_WIDTH-100,topH, 90, 40);
    [_sexBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_sexBtn setTitleColor:XT_BLACKCOLOR forState:UIControlStateNormal];
    [_sexBtn setImage:[UIImage imageNamed:@"mc_arrowDn"] forState:UIControlStateNormal];
    [_sexBtn setImage:[UIImage imageNamed:@"mc_arrowUp"] forState:UIControlStateSelected];
    _sexBtn.titleLabel.font = FONT(14);
    [_sexBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_sexBtn];
    
    return lab;
}

-(void)initImgView:(CGFloat)topH{
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, topH, SCREEN_WIDTH, 0.5)];
    lineImg.backgroundColor = LINECOLOR;
    [_scrollView addSubview:lineImg];
}

//选择性别
-(void)sexBtnClick:(UIButton *)sender{
    sender.selected = YES;

    [_mobileField resignFirstResponder];
    [_codeField resignFirstResponder];
    [_nickNameField resignFirstResponder];
    [_pswField resignFirstResponder];
    if (!self.dataPicker) {
        self.dataPicker = [[NDDataPicker alloc] initWithFrame:self.view.bounds];
        self.dataPicker.delegate = self;
    }
    self.dataPicker.datas = _sexDataArr;
    [self.dataPicker reloadData];
    [self.view addSubview:self.dataPicker];
}

#pragma mark
#pragma mark ====== NDDataPickerDelegate ======
/**
 *  内容已选择
 *
 *  @param date 选择的内容   1男 2 女
 */
- (void)dataDidSelected:(NSString *)data index:(int)index{
    [_sexLab setText:data];
    _sexIndex = index;
    self.sexBtn.selected = NO;
    
}
/**
 *  选中取消
 */
- (void)cancelSelect{

    self.sexBtn.selected = NO;

}
/**
 *  获取验证码
 */
-(void)getCodeBtnClick{
    [_codeField resignFirstResponder];
    [_mobileField resignFirstResponder];
    [_pswField resignFirstResponder];
    [_nickNameField resignFirstResponder];
    
    
    if (self.dataPicker) {
        [self.dataPicker removeFromSuperview];
    }
    if (![self validateMobile:_mobileField.text]) {
        return;
    }
    
    NSDictionary *parm = [HttpBody getRandCode:_mobileField.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
        NSLog(@"请求获取验证码结果:%@",jsonDic);
        
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
            [self startTime];
            //点击验证码直接显示在 验证码栏中
            self.lastYZM = [NetDataCommon stringFromDic:jsonDic forKey:@"data"];
//                        _codeField.text = code;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取验证码成功" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)startTime
{
    __block int timeout = 119; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_getVerCodeBtn setTitleColor:XT_MAINCOLOR forState:UIControlStateNormal];
                [_getVerCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _getVerCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout %120;
//            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [_getVerCodeBtn setTitleColor:XT_TEXTGRAYCOLOR forState:UIControlStateNormal];
                [_getVerCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重试",strTime] forState:UIControlStateNormal];
                _getVerCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *  注册
 */
-(void)registeBtnClick{
    [_codeField resignFirstResponder];
    [_mobileField resignFirstResponder];
    [_pswField resignFirstResponder];
    [_nickNameField resignFirstResponder];
    
    if (![self validateMobile:_mobileField.text]) {
        return;
    }
    if (!_codeField.text || [_codeField.text isEqualToString:@""]) {
        if([_codeField.text isEqualToString:@""]){
            [ProgressHUD showError:@"您还未输入验证码"];
        }
                return;
    }
    if (![_codeField.text isEqualToString:self.lastYZM]) {
        [ProgressHUD showError:@"验证码输入有误,请重新输入"];
        return;
    }



    if (!_nickNameField.text || [_nickNameField.text isEqualToString:@""]) {
        [ProgressHUD showError:@"您还未输入昵称"];
        return;
    }

    if (_sexIndex != 1 && _sexIndex != 2) {
        _sexIndex = 1;
    }
    if (![self validatePsw:_pswField.text]) {
        return;
    }
    
    
    
    if (!_selBtn.selected) {
        [ProgressHUD showError:@"同意用户协议才能注册!"];
        return;
    }
    [self registeRequest];
}

-(void)registeRequest{
    
    NSDictionary *pram = [HttpBody resisterBody:_mobileField.text nickName:_nickNameField.text gender:_sexIndex psw:[NSString getMD5String:_pswField.text] openid:@""];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"注册结果:%@",resDict);
        
        if ([[resDict objectForKey:@"status"] integerValue] == 1) {
            [ProgressHUD showSuccess:@"注册成功"];
            if (_delegate && [_delegate respondsToSelector:@selector(registerSuccees:psw:)]) {
                [_delegate registerSuccees:_mobileField.text psw:_pswField.text];
            }
            [self performSelector:@selector(backBtPressed) withObject:nil afterDelay:0.1];
        }
        else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.dataPicker removeFromSuperview];
    return YES;
}


@end
