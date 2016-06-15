//
//  UpdatePictureController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "UpdatePictureController.h"
#import "NDDataPicker.h"
#import "UPImageCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "NSString+HXAddtions.h"
#import "NSString+Empty.h"

#define UPIMAGECELL      @"UPIMAGECELL"

#define TEXTVIEWHOLDER   @"描述说明:(最多140字)"

@interface UpdatePictureController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NDDataPickerDelegate,UPImageCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,retain) NSMutableArray    *imageArray;
@property (nonatomic,retain) UIImagePickerController *imagePicker;

@property (nonatomic,strong) UITextView     *desTextView;

@property (nonatomic,strong) NSIndexPath    *indexPath;

@property (nonatomic,strong) UITextField    *nameField;
@property (nonatomic, strong) NSMutableDictionary   *pram;

@property (nonatomic, strong) BMPreData             *pData;
@property (nonatomic, strong) UIImageView * MimageView;

@end

@implementation UpdatePictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImgeArr];
    [self initCollectionView];
    [self initDescriptionView];
}

- (void)setPreData:(BMPreData *)data{
    self.pData = data;
}

- (void)setPPram:(NSMutableDictionary *)pram{
    self.pram = pram;
}

-(void)setImgeArr{
    _imageArray = [[NSMutableArray alloc] init];

    if (!_saiBean) {
        //表示提交作品
    }else{
        //表示修改作品
        if (_saiBean.applySubArr && [_saiBean.applySubArr isKindOfClass:[NSArray class]] && _saiBean.applySubArr.count > 0) {
            
            for (int i = 0; i < _saiBean.applySubArr.count; i++) {
                NSString *url =  [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:_saiBean.applySubArr[i] forKey:@"pic_url"]];
                [_imageArray addObject:url];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initCollectionView{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.minimumInteritemSpacing = 8;
    layOut.itemSize = CGSizeMake(80, 100);
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UPImageCell class] forCellWithReuseIdentifier:UPIMAGECELL];
    [self.view addSubview:_collectionView];
}

-(void)initDescriptionView{
    UIView *desView = [[UIView alloc] initWithFrame:CGRectMake(0, _collectionView.bottom, SCREEN_WIDTH, 160)];
    desView.backgroundColor = [UIColor whiteColor];
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(10,20,150, 25)];
    _nameField.backgroundColor = CLEARCOLOR;
    _nameField.textColor = XT_BLACKCOLOR;
    _nameField.layer.borderWidth = 1.0f;
    _nameField.delegate = self;
    _nameField.returnKeyType = UIReturnKeyDone;
    _nameField.font = FONT(13);
    if (_saiBean) {
        _nameField.text = _saiBean.title;
    }
    _nameField.layer.borderColor = [LINECOLOR CGColor];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"作品名称" attributes:@{NSForegroundColorAttributeName: XT_TEXTGRAYCOLOR}];
    [desView addSubview:_nameField];
    //创作意图修改位置
    _desTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH-20, 80)];
    _desTextView.textColor = XT_TEXTGRAYCOLOR;
    if (_saiBean) {
        _desTextView.text = _saiBean.pic_desc;
    }
    else{
        _desTextView.text = TEXTVIEWHOLDER;
    }
    _desTextView.font = FONT(13);
    _desTextView.layer.borderColor = [LINECOLOR CGColor];
    _desTextView.layer.borderWidth = 1.0f;
    _desTextView.returnKeyType = UIReturnKeyDone;
    _desTextView.delegate = self;
    [desView addSubview:_desTextView];
    [self.view addSubview:desView];
    
    UIButton *cansaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cansaiBtn.backgroundColor = XT_MAINCOLOR;
    cansaiBtn.frame = CGRectMake(110, desView.bottom+20, SCREEN_WIDTH-220, 30);
    cansaiBtn.layer.cornerRadius = 15;
    cansaiBtn.clipsToBounds = YES;
    [cansaiBtn setTitle:@"提    交" forState:UIControlStateNormal];
    [cansaiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cansaiBtn.titleLabel.font = FONT(18);
    [cansaiBtn addTarget:self action:@selector(cansaiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cansaiBtn];
}

-(void)cansaiBtnClick{
    if (_saiBean) {
        [self xiugai];
    }else{
        [self cansai];
    }
}

- (void)xiugai{
    NSMutableDictionary *pram = [[NSMutableDictionary alloc] init];
    [pram setObject:@([[UserModel shareInfo] uid]) forKey:@"uid"];
    [pram setObject:_saiBean.sId forKey:@"id"];
    [pram setObject:_saiBean.gId forKey:@"gid"];
    
    if (_imageArray && _imageArray.count > 0) {
        
        [pram setObject:[NSString jsonStringWithArray:_imageArray] forKey:@"pic_urls"];
        //[NSString jsonStringWithArray:_imageArray]
    }
    
    if (_nameField.text && ![_nameField.text isEqualToString:@""]) {
        [pram setObject:_nameField.text forKey:@"title"];
    }
    //修改创作意图
//    if (_desTextView.text && ![_desTextView.text isEqualToString:TEXTVIEWHOLDER] && ![_desTextView.text isEqualToString:@""]) {
//        [pram setObject:_desTextView.text forKey:@"pic_desc"];
//    }
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager POST:@"http://saisai.iapptry.com/api.php?action=updateApply" parameters:pram success:^(AFHTTPRequestOperation * operation, id response) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"修改参赛作品结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            [ProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:HP_REFRESHCOUNTDATA object:nil];
            [super backBtPressed];
            
        }else{
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)cansai{
    NSString *title = _nameField.text;
//    NSString *des = _desTextView.text;
    if ([title isEmpty]) {
        [ProgressHUD showError:@"作品名称不能为空"];
        return;
    }
        //创作意图修改位置
//    if (!des || [des isEmpty] || [_desTextView.text isEqualToString:TEXTVIEWHOLDER]) {
//        [ProgressHUD showError:@"创作意图不能为空"];
//        return;
//    }
    
    if (_imageArray.count == 0) {
        [ProgressHUD showError:@"参赛作品不能为空"];
        return;
    }
    
    [_pram setObject:title forKey:@"title"];
//    [_pram setObject:des forKey:@"pic_desc"];
    [_pram setObject:[NSString jsonStringWithArray:_imageArray] forKey:@"pic_urls"];
    
    [ProgressHUD show:LOADING];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager POST:APPLY_ADDRESS parameters:_pram success:^(AFHTTPRequestOperation * operation, id response){
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求报名接口结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            [ProgressHUD showSuccess:@"报名成功!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            //数据请求失败
            [ProgressHUD showError:[resDict objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
    }];
}

#pragma mark
#pragma mark ====== UICollectionDelegate Datasource ======

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count+1;
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
   
    if (indexPath.row == self.imageArray.count) {
        if (_pData && _pData.is_single==1) {
            if (_imageArray.count>0) {
                [ProgressHUD showError:@"只能上传一张作品!"];
                return;
            }
        }
        _indexPath = indexPath;
        
        //弹出照片选择
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片",@"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
        
        [_nameField resignFirstResponder];
        [_desTextView resignFirstResponder];
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

//        UIView * backV = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
//        backV.backgroundColor = [UIColor blackColor];
//        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:backV];
//        
//        [[UIApplication sharedApplication].keyWindow.rootViewController.view bringSubviewToFront:backV];
//        
//        
//        UIImage * image = _imageArray[indexPath.row];
//        
//        CGFloat imgH = image.size.height * (SCREEN_WIDTH/image.size.width);
//        _MimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,imgH)];
//        
//        _MimageView.center = backV.center;
//        
//        _MimageView.image = image;
//        
//        [backV addSubview:_MimageView];
//        
//        UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImageView)];
//
//        [backV addGestureRecognizer:singTap];

    }
}
//- (void)removeImageView{
//    
//    
//    [_MimageView.superview removeFromSuperview];
//    
//}
#pragma mark
#pragma mark ===UPImageCell delegate =====
-(void)upImageCellAlert:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    //弹出照片选择
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片",@"拍照", @"删除", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
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
            
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                self.imagePicker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            }
            
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
            //图片压缩
            CGSize size = CGSizeMake(1200, 1200/sa);
            
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
        
        [_collectionView reloadData];
        
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
#pragma mark ===== UITextView delegate ========
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([_desTextView isFirstResponder]) {
        if ([_desTextView.text isEqualToString:TEXTVIEWHOLDER]) {
            _desTextView.text = @"";
            _desTextView.textColor = XT_BLACKCOLOR;
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == _desTextView) {
        if ([_desTextView.text isEqualToString:@""]) {
            _desTextView.text = TEXTVIEWHOLDER;
            _desTextView.textColor = UIColorFromRGB(0xb4b4b4);
        }
    }
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
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"上传图片结果:%@",resDict);
        //解析数据
        int status = [[resDict objectForKey:@"status"] intValue];
        if (status == 1) {
            [ProgressHUD dismiss];
            //修改图片
//            NSArray *array = @[image];
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
