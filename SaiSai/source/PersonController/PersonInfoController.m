//
//  PersonInfoController.m
//  SaiSai
//
//  Created by weige on 15/9/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "PersonInfoController.h"
#import "SettingCell.h"

#define SETTINGCELL     @"SETTINGCELL"

@interface PersonInfoController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIButton *oneselfBtn;
    UIButton *serviceBtn;
    int         sex;
}

@property (nonatomic, retain) UITableView   *tableView;

@property (nonatomic, retain) PXAlertView   *alertView;

@property (nonatomic, retain) UIImagePickerController *imagePicker;

@property (nonatomic, retain) UIImage       *image;

@end

@implementation PersonInfoController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7, SCREEN_WIDTH, SCREEN_HEIGHT-64)];//225
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SettingCell class] forCellReuseIdentifier:SETTINGCELL];
    [self.view addSubview:_tableView];
}

#pragma mark
#pragma mark ====== UITableView ======

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return SETTINGCELL_HEIGHT1;
    }
    return SETTINGCELL_HEIGHT2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:SETTINGCELL];
    if (!cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SETTINGCELL];
    }
    
    [cell setIndex:(int)indexPath.row];
    if (indexPath.row == 0) {
        [cell setName:@"头像"];
        [cell setHeader:[[UserModel shareInfo] icon] isShow:YES];
        [cell setEditPhone:NO];
    }else if (indexPath.row == 1){
        [cell setName:@"用户昵称"];
        [cell setHeader:@"" isShow:NO];
        [cell setEditPhone:NO];
        [cell setContent:[[UserModel shareInfo] nickName]];
    }else if (2 == indexPath.row){
        NSString *ssex = [[UserModel shareInfo] gender] == 1? @"男":@"女";
        [cell setName:@"性别"];
        [cell setHeader:@"" isShow:NO];
        [cell setEditPhone:NO];
        [cell setContent:ssex];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //显示actionsheet
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片",@"拍照", nil];
            sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [sheet showInView:self.view];
        }
            break;
        case 1:
        {
            //弹出输入框
            UITextField *commentTld = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
            commentTld.layer.borderWidth = 1;
            commentTld.layer.borderColor = [UIColor grayColor].CGColor;
            commentTld.returnKeyType =UIReturnKeyDone;
            commentTld.delegate = self;
            commentTld.textAlignment = NSTextAlignmentCenter;
            commentTld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            commentTld.placeholder = @"请输入昵称";
            [PXAlertView showAlertWithTitle:@"输入昵称" message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:commentTld completion:^(BOOL cancelled) {
                if (!cancelled) {
                    NSString *nick = commentTld.text;
                    nick = [nick stringByReplacingOccurrencesOfString:@" " withString:@""];
                    if (nick == nil || [nick isEqualToString:@""]) {
                        [ProgressHUD showError:@"昵称不能为空!"];
                        return;
                    }
                    [[UserModel shareInfo] setNickName:nick];
                    [self saveUserInfo];
                }
            }];
        }
            break;
        case 2:
        {
            //弹出性别
            sex = [[UserModel shareInfo] gender];
            UIView *wayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
            wayView.backgroundColor = BACKGROUND_COLOR;
            
            oneselfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            oneselfBtn.frame = CGRectMake(40, 10, 60, 20);
            oneselfBtn.tag = 2200;
            [oneselfBtn setTitle:@"男" forState:UIControlStateNormal];
            [oneselfBtn setImage:[UIImage imageNamed:@"sm_detail_unsel"] forState:UIControlStateNormal];
            [oneselfBtn setImage:[UIImage imageNamed:@"sm_detail_sel"] forState:UIControlStateSelected];
            [oneselfBtn setTitleColor:UIColorFromRGB(0x333) forState:UIControlStateNormal];
            oneselfBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10);
            [oneselfBtn addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchUpInside];
            oneselfBtn.exclusiveTouch = YES;
            oneselfBtn.titleLabel.font = FONT(14);
            oneselfBtn.selected = [[UserModel shareInfo] gender] == 1? YES:NO;
            [wayView addSubview:oneselfBtn];
            
            serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            serviceBtn.frame = CGRectMake(130, 10, 90, 20);
            serviceBtn.tag = 2201;
            [serviceBtn setTitle:@"女" forState:UIControlStateNormal];
            [serviceBtn setImage:[UIImage imageNamed:@"sm_detail_unsel"] forState:UIControlStateNormal];
            [serviceBtn setImage:[UIImage imageNamed:@"sm_detail_sel"] forState:UIControlStateSelected];
            [serviceBtn setTitleColor:UIColorFromRGB(0x333) forState:UIControlStateNormal];
            [serviceBtn addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchUpInside];
            serviceBtn.titleLabel.font = FONT(14);
            serviceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10);
            serviceBtn.exclusiveTouch = YES;
            serviceBtn.selected = [[UserModel shareInfo] gender] == 2? YES:NO;
            [wayView addSubview:serviceBtn];
            
            [PXAlertView showAlertWithTitle:@"修改性别" message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:wayView completion:^(BOOL canceled)
             {
                 if (!canceled) {
                     [[UserModel shareInfo] setGender:sex];
                     [self saveUserInfo];
                 }
             }];
        }
            break;
        default:
            break;
    }
}
- (void)valueChanged:(id)sender{
    int tag = (int)((UIButton *)sender).tag;
    if (tag == 2200) {
        sex = 1;
    }else{
        sex = 2;
    }
    oneselfBtn.selected = sex == 1? YES:NO;
    serviceBtn.selected = sex == 2? YES:NO;
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
        NSLog(@"取消");
    }
}

#pragma mark
#pragma mark ====== UIImagePickerControllerDelegate ======

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
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
            self.image = UIGraphicsGetImageFromCurrentImageContext();
            
            // 使当前的context出堆栈
            UIGraphicsEndImageContext();
        }
        
        
        [self changeHeadIcon];
        
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
#pragma mark ====== 接口 ======

- (void)changeHeadIcon{
    
    NSData *data = UIImagePNGRepresentation(self.image);
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager POST:@"http://saisai.iapptry.com/api.php?action=addfiles" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        double time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"headIcon_%f",time];
        [formData appendPartWithFileData:data name:@"file[]" fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation * operation, id response) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"上传图片结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            [ProgressHUD dismiss];
            //设置头像
            NSArray *array = [resDict objectForKey:@"data"];
            [[UserModel shareInfo] setIcon:[array firstObject]];
            [self saveUserInfo];
        }else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)saveUserInfo{
    [ProgressHUD show:LOADING];
    NSDictionary *pram = [HttpBody updateUserInfo:[[UserModel shareInfo] uid] icon:[[UserModel shareInfo] icon] nickName:[[UserModel shareInfo] nickName] gender:[[UserModel shareInfo] gender]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:URLADDRESS parameters:pram success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"更新个人信息结果:%@",resDict);
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            [ProgressHUD dismiss];
            [[UserModel shareInfo] saveInfo];
            [_tableView reloadData];
        }else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

@end
