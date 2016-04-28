//
//  BMController.m
//  SaiSai
//
//  Created by weige on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "NSString+HXAddtions.h"
#import "NDDatePicker.h"
#import "NDDataPicker.h"
#import "BMController.h"
#import "ClassificationButton.h"
#import "BMImageCell.h"
#import "BMPreData.h"
#import "UPImageCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "CityController/CityViewController.h"
#import "AreaBean.h"
#import "NSString+Empty.h"
#import "UpdatePictureController.h"
#import "UIView+XT.h"
#import "MyNavButton.h"

#define UPIMAGECELL     @"UPIMAGECELL"

@interface BMController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NDDataPickerDelegate, NDDatePickerDelegate, UPImageCellDelegate, CityViewControllerDelegate>

@property (nonatomic, retain) UIScrollView  *scrollView;


@property (nonatomic, retain) ClassificationButton   *sexBtn;
@property (nonatomic, retain) ClassificationButton   *cityBtn;
@property (nonatomic, retain) ClassificationButton   *areaBtn;
@property (nonatomic, retain) ClassificationButton   *brithBtn;
@property (nonatomic, retain) ClassificationButton   *typeBtn;
@property (nonatomic, retain) ClassificationButton   *levelBtn;
@property (nonatomic, retain) UITextField   *titleField;
@property (nonatomic, retain) UITextField   *desField;
@property (nonatomic, retain) UITextField   *nameField;
@property (nonatomic, retain) UITextField   *postAddress;
@property (nonatomic, retain) UITextField   *phoneField;
@property (nonatomic, retain) UITextField   *codeField;
@property (nonatomic, retain) UITextField   *mailField;
@property (nonatomic, retain) UITextField   *tpoField;
@property (nonatomic, retain) UITextField   *teachField;

@property (nonatomic, retain) UICollectionView          *collectionView;
@property (nonatomic, retain) UIButton                  *getVerCodeBtn;
@property (nonatomic, retain) NSMutableArray            *imageArray;
@property (nonatomic, retain) UIImagePickerController   *imagePicker;

@property (nonatomic, retain) NSMutableArray            *areaArray;
@property (nonatomic, retain) NSMutableArray            *areaNameArray;

@property (nonatomic, retain) NDDataPicker  *dataPicker;
@property (nonatomic, retain) NDDatePicker  *datePicker;

@property (nonatomic, retain) BMPreData     *preData;
@property (nonatomic, assign) NSInteger     curPickerIndex;
@property (nonatomic, retain) NSIndexPath   *indexPath;

@property (nonatomic, retain) CityBean      *cityBean;

@property (nonatomic, assign) NSInteger     typeIndex;
@property (nonatomic, assign) NSInteger     levelIndex;

@property (nonatomic, retain) AreaBean      *areaBean;

@property (nonatomic, retain) MyNavButton   *navBtn;
@property (nonatomic, strong) NSString      *lastYZM;

@end

@implementation BMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initRightItem];
    [self initData];
    [self initScrollView];
    [self getPreData];
}

-(void)initRightItem{
    self.view.backgroundColor = [UIColor whiteColor];
    MyNavButton *rightItem = [MyNavButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 0, 60, 64);
    [rightItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightItem setImage:[UIImage imageNamed:@"cansaizhidao.png"] forState:UIControlStateNormal];
    [rightItem setTitle:@"指导说明" forState:UIControlStateNormal];
    rightItem.titleLabel.font = FONT(12);
    [rightItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)backAction{
    if (_delegate && [_delegate respondsToSelector:@selector(showCansaiZhiDao)]) {
        [_delegate showCansaiZhiDao];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    self.imageArray = [[NSMutableArray alloc] init];
    self.areaArray = [[NSMutableArray alloc] init];
    self.areaNameArray = [[NSMutableArray alloc] init];
}

- (void)getPreData{
    NSDictionary *pram = [HttpBody getApplyInfoByUid:[[UserModel shareInfo] uid] gid:(int)self.fBean.mId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//        NSLog(@"点击报名获取相关信息接口结果:%@",resDict);
        int status = [[resDict objectForKey:@"status"] intValue];
               if (status == 1) {
            [ProgressHUD dismiss];
            NSDictionary *data = [resDict objectForKey:@"data"];
            self.preData = [BMPreData analyseData:data];
            //初始化详情
            [self initDetailView];
        }else if (status == 2){
            [ProgressHUD showError:@"您已经报过名啦~"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)initScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.backgroundColor = CLEARCOLOR;
    [self.view addSubview:_scrollView];
}

-(void)initCollectionView:(int)y{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.minimumInteritemSpacing = 8;
    layOut.itemSize = CGSizeMake(80, 100);
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(113, y, SCREEN_WIDTH, 110) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UPImageCell class] forCellWithReuseIdentifier:UPIMAGECELL];
    [_scrollView addSubview:_collectionView];
}

- (void)initDetailView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 440)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    
    int y = 0;
    
    [self initLine:y];
    [self initTip:16 y:y w:95 name:@"*参赛者姓名:"];
    _nameField = [self createTextField:112 y:y w:SCREEN_WIDTH-128];
    y += 35;
    
    [self initLine:y];
    [self initTip:16 y:y w:45 name:@"*性别:"];
    _sexBtn = [self createBtn:63 y:y w:SCREEN_WIDTH-73 tag:100];
    [_sexBtn setTitle:@"男" forState:UIControlStateNormal];
    y += 35;
    
    [self initLine:y];
    [self initTip:16 y:y w:45 name:@"*城市:"];
    _cityBtn = [self createBtn:63 y:y w:SCREEN_WIDTH-73 tag:101];
    y += 35;
    
    [self initLine:y];
    [self initTip:16 y:y w:45 name:@"*地区:"];
    _areaBtn = [self createBtn:63 y:y w:SCREEN_WIDTH-73 tag:102];
    y += 35;
    
    [self initLine:y];
    [self initTip:16 y:y w:78 name:@"*寄件地址:"];
    _postAddress = [self createTextField:95 y:y w:SCREEN_WIDTH-110];
    y += 35;
    
    [self initLine:y];
    [self initTip:16 y:y w:78 name:@"*出生日期:"];
    _brithBtn = [self createBtn:95 y:y w:SCREEN_WIDTH-105 tag:104];
    y += 35;
    
    [self initLine:y];
    if (self.preData.is_code == 2) {
        [self initTip:16 y:y w:78 name:@"*联系电话:"];
    }else{
        [self initTip:16 y:y w:78 name:@"联系电话:"];
    }
    _phoneField = [self createTextField:95 y:y w:SCREEN_WIDTH-110];
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    y += 35;
    
    [self initLine:y];
    if (self.preData.is_code == 2) {
        [self initTip:16 y:y w:78 name:@"*验证码:"];
    }else{
        [self initTip:16 y:y w:78 name:@"验证码:"];
    }
    _codeField = [self createTextField:95 y:y w:SCREEN_WIDTH-190];
    //创建验证码btn
    [self createCodeBtn:y];
    y += 35;
    
    [self initLine:y];
    [self initTip:16 y:y w:45 name:@"*邮箱:"];
    _mailField = [self createTextField:62 y:y w:SCREEN_WIDTH-67];
    _mailField.keyboardType = UIKeyboardTypeEmailAddress;
    y += 35;
    
    if (self.preData.flag == 1) {
        [self initLine:y];
        if (self.preData.is_org==2) {
            [self initTip:16 y:y w:158 name:@"*参赛组织(学校班级):"];
        }else{
            [self initTip:16 y:y w:158 name:@"参赛组织(学校班级):"];
        }
        _tpoField = [self createTextField:157 y:y w:SCREEN_WIDTH-110];
        y += 35;
    }
    
    
    if (self.preData.flag == 1) {
        [self initLine:y];
        if (self.preData.is_teacher == 2) {
            [self initTip:16 y:y w:78 name:@"*指导老师:"];
        }else{
            [self initTip:16 y:y w:78 name:@"指导老师:"];
        }
        _teachField = [self createTextField:95 y:y w:SCREEN_WIDTH-110];
        y += 35;
    }
    
    [self initLine:y];
    if (self.preData.is_games_type_relative == 2) {
        [self initTip:16 y:y w:78 name:@"*作品类型:"];
    }else{
        [self initTip:16 y:y w:78 name:@"作品类型:"];
    }
    _typeBtn = [self createBtn:95 y:y w:SCREEN_WIDTH-100 tag:105];
    y += 35;
    
    if (self.preData.flag == 2) {
        [self initLine:y];
        if (self.preData.is_level == 2) {
            [self initTip:16 y:y w:45 name:@"*级别:"];
        }else{
            [self initTip:16 y:y w:45 name:@"级别:"];
        }
        _levelBtn = [self createBtn:63 y:y w:SCREEN_WIDTH-73 tag:103];
        y += 35;
    }
    
    [self initLine:y];
    //修改参赛照片
//    if (self.preData.is_img == 2) {
//        [self initTip:16 y:y w:95 name:@"*参赛者照片:"];
//    }else{
//        [self initTip:16 y:y w:95 name:@"参赛者照片:"];
//    }
//    [self initCollectionView:y];
//    y += 110;
    
    [self initLine:y];
    
    UIButton *cansaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cansaiBtn.backgroundColor = XT_MAINCOLOR;
    cansaiBtn.frame = CGRectMake(110, y+30, SCREEN_WIDTH-220, 30);
    cansaiBtn.layer.cornerRadius = 15;
    cansaiBtn.clipsToBounds = YES;
    [cansaiBtn setTitle:@"参    赛" forState:UIControlStateNormal];
    [cansaiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cansaiBtn.titleLabel.font = FONT(18.0f);
    [cansaiBtn addTarget:self action:@selector(cansaiAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:cansaiBtn];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, y+90);
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, y+90);
    
    //有上次提交的作品信息
    [self treateLastAppInfo];
}
//报名后储存信息
- (void)treateLastAppInfo{
    if (self.preData.last_apply_info != nil && [self.preData.last_apply_info isKindOfClass:[LastApplyInfoBean class]]) {
        //之前提交过
        _nameField.text = self.preData.last_apply_info.realname;
        NSString *sex = self.preData.last_apply_info.gender==1? @"男":@"女";
        [_sexBtn setTitle:sex forState:UIControlStateNormal];
        _postAddress.text = self.preData.last_apply_info.address;
        
        NSString *tempBirth = self.preData.last_apply_info.birthday;
        if(tempBirth && ![tempBirth isEqualToString:@"0000-00-00"])
        {
            [_brithBtn setTitle:self.preData.last_apply_info.birthday forState:UIControlStateNormal];
        }
        _phoneField.text = self.preData.last_apply_info.tel;
        _mailField.text = self.preData.last_apply_info.email;
        [_cityBtn setTitle:self.preData.last_apply_info.city_name forState:UIControlStateNormal];
        [_areaBtn setTitle:self.preData.last_apply_info.area_name forState:UIControlStateNormal];
        [_imageArray addObject:self.preData.last_apply_info.img];
        
        self.cityBean = [[CityBean alloc] init];
        self.cityBean.mId = self.preData.last_apply_info.city_id;
        self.cityBean.city_name = self.preData.last_apply_info.city_name;
        
        self.areaBean = [[AreaBean alloc] init];
        self.areaBean.mId = self.preData.last_apply_info.area_id;
        self.areaBean.area_name = self.preData.last_apply_info.area_name;
        
        [_collectionView reloadData];
    }
}

- (void)createCodeBtn:(int)y{
    _getVerCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140,y,125,35)];
    [_getVerCodeBtn setTitleColor:XT_MAINCOLOR forState:UIControlStateNormal];
    [_getVerCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _getVerCodeBtn.exclusiveTouch = YES;
    _getVerCodeBtn.titleLabel.font = FONT(13);
    [_getVerCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_getVerCodeBtn];
}

/**
 *  获取验证码
 */
-(void)getCodeBtnClick{
    [_codeField resignFirstResponder];
    [_phoneField resignFirstResponder];
    
    
    if (![self validateMobile:_phoneField.text]) {
        return;
    }
    
    NSDictionary *parm = [HttpBody getRandCode:_phoneField.text];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
//        NSLog(@"请求获取验证码结果:%@",jsonDic);
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1) {
//            _codeField.text = [NSString stringWithFormat:@"%ld",(long)[[jsonDic objectForKey:@"data"] integerValue]];
            [self startTime];
            //验证码的读取
            self.lastYZM = [NetDataCommon stringFromDic:jsonDic forKey:@"data"];
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"获取验证码成功" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alerView show];
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
//            int seconds = timeout ;
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

- (void)initLine:(int)y{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:line];
}

- (void)initTip:(int)x y:(int)y w:(int)w name:(NSString *)name{
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 35)];
    tip.backgroundColor = CLEARCOLOR;
    tip.font = FONT(15);
    tip.text = name;
    
    tip.textColor = [UIColor blackColor];
    tip.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:tip];
}

- (UITextField *)createTextField:(int)x y:(int)y w:(int)w{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, 35)];
    textField.backgroundColor = CLEARCOLOR;
    textField.font = FONT(15);
    textField.delegate = self;
    textField.textColor = [UIColor lightGrayColor];
    textField.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:textField];
    return textField;
}

- (ClassificationButton *)createBtn:(int)x y:(int)y w:(int)w tag:(int)tag{
    UIImage *image = [UIImage imageNamed:@"mc_arrowDn.png"];
    ClassificationButton *btn = [[ClassificationButton alloc] initWithFrame:CGRectMake(x, y, w, 35)];
    btn.backgroundColor = CLEARCOLOR;
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(15);
    btn.tag = tag;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showDataPicker:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    return btn;
}

- (void)showDataPicker:(id)sender{
    [self resignView];
    [self.dataPicker removeFromSuperview];
    [self.datePicker removeFromSuperview];
    UIButton *btn = (UIButton *)sender;
    self.curPickerIndex = btn.tag;
    switch (btn.tag) {
        case 100:
        {
            //性别
            [self showSexPicker];
        }
            break;
        case 101:
        {
            //城市
            CityViewController *ctrl = [[CityViewController alloc] init];
            ctrl.title = @"城市";
            ctrl.m_showBackBt = YES;
            ctrl.delegate = self;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case 102:
        {
            //地区
            [self showAreaPicker];
        }
            break;
        case 103:
        {
            //级别
            [self showLevelPicker];
        }
            break;
        case 104:
        {
            //出生日期
            [self showDatePicker];
        }
            break;
        case 105:
        {
            //作品类型
            [self showTypePicker];
        }
            break;
            
        default:
            break;
    }
}

- (void)showAreaPicker{
    if (!self.dataPicker) {
        self.dataPicker= [[NDDataPicker alloc] initWithFrame:self.view.bounds];
        self.dataPicker.delegate = self;
    }
    self.dataPicker.datas = self.areaNameArray;
    [self.dataPicker reloadData];
    [self.view addSubview:self.dataPicker];
}

- (void)showSexPicker{
    if (!self.dataPicker) {
        self.dataPicker= [[NDDataPicker alloc] initWithFrame:self.view.bounds];
        self.dataPicker.delegate = self;
    }
    self.dataPicker.datas = [NSArray arrayWithObjects:@"男", @"女", nil];
    [self.dataPicker reloadData];
    [self.view addSubview:self.dataPicker];
}

- (void)showTypePicker{
    if (!self.dataPicker) {
        self.dataPicker= [[NDDataPicker alloc] initWithFrame:self.view.bounds];
        self.dataPicker.delegate = self;
    }
    self.dataPicker.datas = self.preData.games_type_name;
    [self.dataPicker reloadData];
    [self.view addSubview:self.dataPicker];
}

- (void)showLevelPicker{
    if (!self.dataPicker) {
        self.dataPicker= [[NDDataPicker alloc] initWithFrame:self.view.bounds];
        self.dataPicker.delegate = self;
    }
    self.dataPicker.datas = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    [self.dataPicker reloadData];
    [self.view addSubview:self.dataPicker];
}

- (void)showDatePicker{
    if (!self.datePicker) {
        self.datePicker = [[NDDatePicker alloc] initWithFrame:self.view.bounds];
        self.datePicker.delegate = self;
    }
    [self.view addSubview:self.datePicker];
}

#pragma mark
#pragma mark ====== UICollectionDelegate Datasource ======

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UPImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UPIMAGECELL forIndexPath:indexPath];
    if (!cell) {
        cell = [[UPImageCell alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
    }
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (indexPath.row == self.imageArray.count) {
        UIImage *image = [UIImage imageNamed:@"bm_add.png"];
        [cell setImage:image];
        cell.alertBtn.hidden = YES;
    }else{
        cell.alertBtn.hidden = NO;
        [cell setImageURL:_imageArray[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self resignView];
    if (indexPath.row>0) {
        [ProgressHUD showError:@"只能上传一张照片哦~"];
        return;
    }else{
        if (indexPath.row == self.imageArray.count) {
            
            _indexPath = indexPath;
            
            //弹出照片选择
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片",@"拍照", nil];
            sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [sheet showInView:self.view];
        }else{
            
            NSInteger count = self.imageArray.count;
            
            // 1.封装图片数据
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
            for (int i = 0; i<count; i++) {
                MJPhoto *photo = [[MJPhoto alloc] init];
                // photo.image = [UIImage imageNamed:@"guide4_667"];
                
                //            UPImageCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
                //            cell.imageView;
                
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
                imgView.size = CGSizeMake(300, 300);
                
                photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_imageArray[i]]];
                photo.srcImageView = imgView; // 来源于哪个UIImageView
                [photos addObject:photo];
            }
            
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.photos = photos; // 设置所有的图片
            browser.currentPhotoIndex = indexPath.row;
            [browser show];
        }
    }
//    if (self.preData.is_single == 1 && indexPath.row>=1) {
//        [ProgressHUD showError:@"只能上传一张作品哦~"];
//        return;
//    }
//    if (indexPath.row == self.imageArray.count) {
//        
//        _indexPath = indexPath;
//        
//        //弹出照片选择
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片",@"拍照", @"删除", nil];
//        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//        [sheet showInView:self.view];
//    }else{
//        
//        NSInteger count = self.imageArray.count;
//        
//        // 1.封装图片数据
//        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//        for (int i = 0; i<count; i++) {
//            MJPhoto *photo = [[MJPhoto alloc] init];
//            // photo.image = [UIImage imageNamed:@"guide4_667"];
//            
//            //            UPImageCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//            //            cell.imageView;
//            
//            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//            imgView.size = CGSizeMake(300, 300);
//            
//            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_imageArray[i]]];
//            photo.srcImageView = imgView; // 来源于哪个UIImageView
//            [photos addObject:photo];
//        }
//        
//        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//        browser.photos = photos; // 设置所有的图片
//        browser.currentPhotoIndex = indexPath.row;
//        [browser show];
//    }
}

#pragma mark === actionsheet delegate ======
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"选择照片");
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
    else if (buttonIndex == 1){
        NSLog(@"拍照");
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [self presentViewController:self.imagePicker animated:YES completion:^{
                
            }];
        }
        else{
            NSLog(@"不能打开相机");
        }
    }
    else if (buttonIndex == 2){
        if (_indexPath.row == self.imageArray.count) {
            NSLog(@"取消");
        }else{
            NSLog(@"删除");
            [self.imageArray removeObjectAtIndex:_indexPath.row];
            [_collectionView reloadData];
        }
    }else{
        NSLog(@"取消");
    }
}

#pragma mark
#pragma mark ====== UIImagePickerControllerDelegate ======

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        UIImage *newImage;
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!image) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (image) {
            
            CGFloat sa = image.size.width / image.size.height;
            CGSize size = CGSizeMake(600, 600/sa);
            
            UIGraphicsBeginImageContext(size);
            // 绘制改变大小的图片
            
            [image drawInRect:CGRectMake(0,0, size.width, size.height)];
            // 从当前context中创建一个改变大小后的图片
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            // 使当前的context出堆栈
            UIGraphicsEndImageContext();
        }
        
        NSData *newData = UIImageJPEGRepresentation(newImage, 1);
        float length = (float)newData.length;
        float scale = 204800.0/length;
        if (scale<0.01) {
            scale=0.01;
        }
        newData = UIImageJPEGRepresentation(newImage, scale);
        newImage = [[UIImage alloc] initWithData:newData];
        
        if (_indexPath.row == self.imageArray.count) {
            [self upLoadIcon:newImage andIsReplace:NO andIndex:0];
        }
        else{
            [self upLoadIcon:newImage andIsReplace:YES andIndex:_indexPath.row];
        }
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    //    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark
#pragma mark ====== NDDataPickerDelegate ======
/**
 *  内容已选择
 *
 *  @param date 选择的内容
 */
- (void)dataDidSelected:(NSString *)data index:(int)index picker:(NDDataPicker *)picker{
    [self.datePicker removeFromSuperview];
    
    switch (self.curPickerIndex) {
        case 100:
        {
            //性别
            [_sexBtn setTitle:data forState:UIControlStateNormal];
        }
            break;
        case 102:
        {
            //地区
            self.areaBean = [self.areaArray objectAtIndex:index-1];
            [_areaBtn setTitle:data forState:UIControlStateNormal];
        }
            break;
        case 103:
        {
            //级别
            _levelIndex = index-1;
            [_levelBtn setTitle:data forState:UIControlStateNormal];
        }
            break;
        case 105:
        {
            //作品类型
            _typeIndex = index-1;
            [_typeBtn setTitle:data forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark
#pragma mark ====== NDDatePickerDelegate ======
/**
 *  日期已选择
 *
 *  @param date 选择的日期
 */
- (void)dateDidSelected:(NSDate *)date{
    [self.dataPicker removeFromSuperview];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *time = [formatter stringFromDate:date];
    [_brithBtn setTitle:time forState:UIControlStateNormal];
}

- (void)resignView{
    [self rsetScrollFrame];
    [_titleField resignFirstResponder];
    [_desField resignFirstResponder];
    [_nameField resignFirstResponder];
    [_postAddress resignFirstResponder];
    [_phoneField resignFirstResponder];
    [_codeField resignFirstResponder];
    [_mailField resignFirstResponder];
    [_tpoField resignFirstResponder];
    [_teachField resignFirstResponder];
}

#pragma mark
#pragma mark ====== UPImageCellDelegate ======
/**
 *  修改图片
 *
 *  @param indexPath 默认位置
 */
-(void)upImageCellAlert:(NSIndexPath *)indexPath{
    [self resignView];
    _indexPath = indexPath;
    //弹出照片选择
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片",@"拍照", @"删除", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma mark
#pragma mark ====== UITextFieldDelegate ======
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.datePicker removeFromSuperview];
    [self.dataPicker removeFromSuperview];
    
    if (textField==_mailField || textField==_phoneField || textField==_codeField || textField==_tpoField || textField == _teachField) {
        CGRect frame = _scrollView.frame;
        frame.origin.y = -150;
        _scrollView.frame = frame;
    }else{
        CGRect frame = _scrollView.frame;
        frame.origin.y = 0;
        _scrollView.frame = frame;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    [textField resignFirstResponder];
    CGRect frame = _scrollView.frame;
    frame.origin.y = 0;
    _scrollView.frame = frame;
    return YES;
}

- (void)rsetScrollFrame{
    CGRect frame = _scrollView.frame;
    frame.origin.y = 0;
    _scrollView.frame = frame;
}

/**
 *  上传图片
 */
-(void)upLoadIcon:(UIImage *)image andIsReplace:(BOOL)isReplace andIndex:(NSInteger)index{
    NSData *data = UIImagePNGRepresentation(image);
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager POST:UPFILE_ADDRESS parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString *imageName = [NSString stringWithFormat:@"gameIcon_%f.png",[[NSDate date] timeIntervalSince1970]];
        
        [formData appendPartWithFileData:data name:@"file[]" fileName:imageName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation * operation, id response) {
        
//        NSString *string= [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"上传图片结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            [ProgressHUD dismiss];
            //修改图片
            NSArray *array = [resDict objectForKey:@"data"];
            
            if (isReplace) {
                [_imageArray replaceObjectAtIndex:index withObject:[array firstObject]];
            }
            else{
                [self.imageArray addObject:[array firstObject]];
            }
            
            [_collectionView reloadData];
            
        }else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)chooseCity:(CityBean*)bean{
    self.cityBean = bean;
    [_cityBtn setTitle:bean.city_name forState:UIControlStateNormal];
    [self getArea:bean];
}

- (void)getArea:(CityBean *)bean{
    NSDictionary *pram = [HttpBody getAreaInfo:(int)bean.mId];
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
//        NSLog(@"请求获取报名界面参赛主题列表接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            NSArray *array = [resDict objectForKey:@"data"];
            [self.areaArray removeAllObjects];
            [self.areaNameArray removeAllObjects];
            for (NSDictionary *dict in array) {
                AreaBean *bean = [AreaBean analyseData:dict];
                [self.areaArray addObject:bean];
                [self.areaNameArray addObject:bean.area_name];
            }
            [ProgressHUD dismiss];
        }else{
            //数据请求失败
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
    }];
}



- (void)cansaiAction{
    int tid = (int)self.preData.tid;
    int gid = (int)self.preData.mId;
    int uid = [[UserModel shareInfo] uid];
    NSString *realName = _nameField.text;
    NSString *email = _mailField.text;
    int gender = [_sexBtn.titleLabel.text isEqualToString:@"男"]? 1:2;
    NSString *brithday = _brithBtn.titleLabel.text;
    NSString *address = _postAddress.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *birthdayDate = [formatter dateFromString:brithday];
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *cale = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cale components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:birthdayDate toDate:nowDate options:0];
    int age = (int)[comps year];
    
    if ([realName isEmpty] || [email isEmpty] || brithday == nil || [brithday isEmpty] || [address isEmpty]) {
        [ProgressHUD showError:@"必填项不能为空!"];
        return;
    }
    //修改过的地方。  验证码。
    if (self.preData.is_code == 1) {
        _codeField.text = @"";
    }else if (self.preData.is_code == 2) {
        
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
              }
    

    if (!self.cityBean) {
        [ProgressHUD showError:@"城市没选择!"];
        return;
    }
    int cityId = (int)self.cityBean.mId;
    if (!self.areaBean) {
        if (!self.areaArray || self.areaArray.count==0) {
            [ProgressHUD showError:@"地区没有获取到!"];
            return;
        }
    }
    
    NSString *areaName = _areaBtn.titleLabel.text;
    if (areaName == nil || [areaName isEmpty]) {
        [ProgressHUD showError:@"地区没有选择!"];
        return;
    }
    int areaId = (int)self.areaBean.mId;
    
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@(tid) forKey:@"tid"];
    [pram setObject:@(gid) forKey:@"gid"];
    [pram setObject:@(uid) forKey:@"uid"];
    [pram setObject:realName forKey:@"realname"];
    [pram setObject:email forKey:@"email"];
    [pram setObject:@(gender) forKey:@"gender"];
    [pram setObject:brithday forKey:@"birthday"];
    [pram setObject:@(cityId) forKey:@"city_id"];
    [pram setObject:@(areaId) forKey:@"area_id"];
    [pram setObject:address forKey:@"address"];
    [pram setObject:@(age) forKey:@"age"];
    
    if (self.preData.is_img == 2) {
        if (self.imageArray.count == 0) {
            [ProgressHUD showError:@"照片不能为空!"];
            return;
        }
    }
    [pram setObject:[NSString jsonStringWithArray:_imageArray] forKey:@"img"];
    
    
    NSString *tel = _phoneField.text;
    if (tel==nil) {
        tel = @"";
    }
    if (self.preData.is_code == 2) {
        if ([tel isEmpty]) {
            [ProgressHUD showError:@"手机号不能为空!"];
            return;
        }
    }
    [pram setObject:tel forKey:@"tel"];
   

    
//    if (self.preData.is_games_type_relative == 2) {
//        if ([_typeBtn.titleLabel.text isEmpty]) {
//            [ProgressHUD showError:@"类型不能为空"];
//            return;
//        }
//        GameTypeBean *bean = [self.preData.games_type objectAtIndex:_levelIndex];
//        [pram setObject:@(bean.mId) forKey:@"games_type_id"];
//    }
    
//    if (self.preData.is_level == 2) {
//        if ([_levelBtn.titleLabel.text isEmpty]) {
//            [ProgressHUD showError:@"级别不能为空!"];
//            return;
//        }
//        [pram setObject:_levelBtn.titleLabel.text forKey:@"level"];
//    }

    NSString *org = _tpoField.text;

    if (org==nil) {
        org = @"";
    }
    if (self.preData.is_org == 2) {
        if ([org isEmpty]) {
            [ProgressHUD showError:@"参赛组织不能为空!"];
            return;
        }
    }
    [pram setObject:org forKey:@"org"];
    
    
    NSString *teacher = _teachField.text;
    if (teacher==nil) {
        teacher =@"";
    }
    
     if (self.preData.is_teacher == 2) {
        if ([teacher isEmpty]) {
            [ProgressHUD showError:@"指导老师不能为空!"];
            return;
        }
    }
    [pram setObject:teacher forKey:@"teacher"];
    
    NSString *anl = _typeBtn.titleLabel.text;
    if (anl==nil) {
        anl = @"";
    }
    if (self.preData.is_games_type_relative == 2) {
        if ([anl isEmpty]) {
            [ProgressHUD showError:@"类型不能为空!"];
            return;
        }
    }
    [pram setObject:anl forKey:@"games_type_id"];
    
    
    
    if (self.preData.is_upload==1) {
        //显示提交作品页面
        UpdatePictureController *ctrl = [[UpdatePictureController alloc] init];
        ctrl.title = @"选择作品";
        ctrl.m_showBackBt = YES;
        [ctrl setPreData:self.preData];
        [ctrl setPPram:pram];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else{
        [ProgressHUD show:LOADING];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        [manager POST:APPLY_ADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response){
            
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            NSLog(@"请求报名接口结果:%@",resDict);
            //解析数据
            int status = [[resDict objectForKey:@"status"] intValue];
            if (status == 1) {
                [ProgressHUD showSuccess:@"报名成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //数据请求失败
                [ProgressHUD showError:[resDict objectForKey:@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"failuer");
            [ProgressHUD showError:CHECKNET];
        }];
    }
}

@end
