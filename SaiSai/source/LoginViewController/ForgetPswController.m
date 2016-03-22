//
//  ForgetPswController.m
//  SaiSai
//
//  Created by gexinwei on 15/9/4.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "ForgetPswController.h"
#import "NSString+MD5.h"

@interface ForgetPswController ()

@property (nonatomic, strong) UITextField       *mobileField;

@property (nonatomic, strong) UITextField       *codeField;

@property (nonatomic, strong) UITextField       *pswField;

@property (nonatomic, strong) UIButton          *getVerCodeBtn;

@end

@implementation ForgetPswController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
    [self createRegisteBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createRegisteBtn{
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(15, 160, SCREEN_WIDTH-30, 40);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.clipsToBounds = YES;
    doneBtn.layer.cornerRadius = 8.f;
    [doneBtn setBackgroundImage:[UIImage imageWithColor:XT_MAINCOLOR] forState:UIControlStateNormal];
    [doneBtn setTitleColor:XT_BLACKCOLOR forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
}

-(void)initViews{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    _mobileField = [self createTextFieldWithTop:0 andPlaceHold:@"手机号"];
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_mobileField];
    
    [self createGetCodeBtn];
    
    _codeField = [self createTextFieldWithTop:40 andPlaceHold:@"验证码"];
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_codeField];
    
    _pswField = [self createTextFieldWithTop:80 andPlaceHold:@"设置密码"];
    _pswField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _pswField.secureTextEntry = YES;
    [self.view addSubview:_pswField];
}

-(void)createGetCodeBtn{
    _getVerCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140,0,140,40)];
    [_getVerCodeBtn setTitleColor:XT_MAINCOLOR forState:UIControlStateNormal];
    [_getVerCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _getVerCodeBtn.exclusiveTouch = YES;
    _getVerCodeBtn.titleLabel.font = FONT(13);
    [_getVerCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getVerCodeBtn];
}

-(UITextField *)createTextFieldWithTop:(CGFloat)top andPlaceHold:(NSString *)holder{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, top, SCREEN_WIDTH, 40)];
    textField.backgroundColor = CLEARCOLOR;
    textField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = FONT(13);
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:holder attributes:@{NSForegroundColorAttributeName: XT_TEXTGRAYCOLOR}];
    textField.delegate = self;
    textField.textColor = XT_BLACKCOLOR;
    
    [self initImgView:top+39.5];
    
    return textField;
}

-(void)initImgView:(CGFloat)topH{
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, topH, SCREEN_WIDTH, 0.5)];
    lineImg.backgroundColor = LINECOLOR;
    [self.view addSubview:lineImg];
}

/**
 *  获取验证码
 */
-(void)getCodeBtnClick{
    [_codeField resignFirstResponder];
    [_mobileField resignFirstResponder];
    [_pswField resignFirstResponder];
    
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
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"获取验证码成功" message:nil delegate:nil
                                                   cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alView show];
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
            int seconds = timeout %120 ;
//            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [_getVerCodeBtn setTitleColor:XT_TEXTGRAYCOLOR forState:UIControlStateNormal];
                [_getVerCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重试",strTime] forState:UIControlStateNormal];
                _getVerCodeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//点击完成
-(void)doneBtnClick{
    [_codeField resignFirstResponder];
    [_mobileField resignFirstResponder];
    [_pswField resignFirstResponder];
    
    if (![self validateMobile:_mobileField.text]) {
        return;
    }
    if (!_codeField.text || [_codeField.text isEqualToString:@""]) {
        [ProgressHUD showError:@"您还未输入验证码"];
        return;
    }
    if (![self validatePsw:_pswField.text]) {
        return;
    }
    [self resetRequest];
}

-(void)resetRequest{
        
    NSDictionary *pram = [HttpBody resetPswBody:_mobileField.text psw:[NSString getMD5String:_pswField.text]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"忘记密码结果:%@",resDict);
        if ([[resDict objectForKey:@"status"] integerValue] == 1) {
            [ProgressHUD showSuccess:@"重置密码成功"];
            [self performSelector:@selector(backBtPressed) withObject:nil afterDelay:0.1];
        }
        else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
}
@end
