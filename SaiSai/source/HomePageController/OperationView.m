//
//  OperationView.m
//  SaiSai
//
//  Created by Zhoufang on 15/8/26.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "OperationView.h"
#import "ShareView.h"
#import "UpdatePictureController.h"

@implementation OperationView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //状态按钮分离宽度
        _seperateWidth = (self.width - 245)/4;
        [self initCommentView];
        [self initAttendView];
        [self initAlertView];
        [self initShareView];
        [self initHotView];
    }
    return self;
}
/**
 *  ～～～～～～～～创建评论view
 */
-(void)initCommentView{
//    UIImageView *commentBg = [self setBgImg:0];
//    [self addSubview:commentBg];
////    修改评论字体位置
//    UILabel *commentLab = [self setLabel:@"评论" andRect:CGRectMake(0, 32,49, 15) andTextColor:XT_BLACKCOLOR];
//    [self addSubview:commentLab];
//    UIImageView *valueImg = [self setValueBg:@"hp_commentBg.png" andRect:CGRectMake(commentBg.width/2-12,4, 25, 18)];
//    [commentBg addSubview:valueImg];
//    _commentNumLab = [self setLabel:@"0" andRect:CGRectMake(0, 0, valueImg.width, valueImg.height-3) andTextColor:[UIColor whiteColor]];
//    [valueImg addSubview:_commentNumLab];
//    
//    _commentBtn = [self setOperationBtn:commentBg.frame andTag:0];
//    [self addSubview:_commentBtn];
}

/**
 *  ～～～～～～～～创建点赞view
 */
-(void)initAttendView{
//    UIImageView *attendBg = [self setBgImg:_commentBtn.right +_seperateWidth];
//    [self addSubview:attendBg];
//    UILabel *attendLab = [self setLabel:@"点赞" andRect:CGRectMake(attendBg.left, 32,attendBg.width, 15) andTextColor:XT_BLACKCOLOR];
//    [self addSubview:attendLab];
//    _zanVabg = [self setValueBg:@"hp_attention.png" andRect:CGRectMake(attendBg.width/2-10,4, 19, 18)];
//    [attendBg addSubview:_zanVabg];
//    
//    _zanBtn = [self setOperationBtn:attendBg.frame andTag:1];
//    [self addSubview:_zanBtn];
    UIImageView *attendBg = [self setBgImg:0];
    
    [self addSubview:attendBg];

    UILabel *attendLab = [self setLabel:@"点赞" andRect:CGRectMake(0, 32+30,49, 15) andTextColor:XT_BLACKCOLOR];
    [self addSubview:attendLab];

    
    
    _zanVabg = [self setValueBg:@"hp_attention.png" andRect:CGRectMake(attendBg.width/2-10,4, 19, 18)];
    
    [attendBg addSubview:_zanVabg];
    
    _zanBtn = [self setOperationBtn:attendBg.frame andTag:1];
    [self addSubview:_zanBtn];
}

/**
 *  ～～～～～～～～创建修改view
 */
-(void)initAlertView{
    UIImageView *alertBg = [self setBgImg:_zanBtn.right + _seperateWidth];
//    [self addSubview:alertBg];
    UILabel *attendLab = [self setLabel:@"修改" andRect:CGRectMake(alertBg.left, 32,alertBg.width, 15) andTextColor:XT_BLACKCOLOR];
//    [self addSubview:attendLab];
    UIImageView *valueImg = [self setValueBg:@"hp_alertBg.png" andRect:CGRectMake(alertBg.width/2-7,2, 15, 20)];
//    [alertBg addSubview:valueImg];
    
    _alertBtn = [self setOperationBtn:alertBg.frame andTag:2];
//    [self addSubview:_alertBtn];
}

/**
 *  ～～～～～～～～创建分享view
 */
-(void)initShareView{
    UIImageView *shareBg = [self setBgImg:_alertBtn.right + _seperateWidth];
    [self addSubview:shareBg];
    UILabel *attendLab = [self setLabel:@"分享" andRect:CGRectMake(shareBg.left, 32+30,shareBg.width, 15) andTextColor:XT_BLACKCOLOR];
    [self addSubview:attendLab];
    UIImageView *valueImg = [self setValueBg:@"hp_shareBg.png" andRect:CGRectMake(shareBg.width/2-8,3, 16, 18)];
    [shareBg addSubview:valueImg];
    
    _shareBtn = [self setOperationBtn:shareBg.frame andTag:3];
    [self addSubview:_shareBtn];
}

/**
 *  ～～～～～～～～创建热度view
 */
-(void)initHotView{
    UIImageView *hotBg = [self setBgImg:_shareBtn.right+78 + _seperateWidth];
    [self addSubview:hotBg];
    UILabel *attendLab = [self setLabel:@"热度" andRect:CGRectMake(hotBg.left, 32+30,hotBg.width, 15) andTextColor:XT_BLACKCOLOR];
    [self addSubview:attendLab];
    
    _hotNumLab = [self setLabel:@"0" andRect:CGRectMake(0, 0, hotBg.width, hotBg.height) andTextColor:XT_BLACKCOLOR];
    [hotBg addSubview:_hotNumLab];
}

/**
 *  创建背景
 */
-(UIImageView *)setBgImg:(CGFloat)left{
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(left, 6+30, 49, 24)];
    bgImg.image = [UIImage imageNamed:@"hp_operateBg"];
    return bgImg;
}

/**
 *  创建 文字
 */
-(UILabel *)setLabel:(NSString *)labelStr andRect:(CGRect)rect andTextColor:(UIColor *)textColor{
    UILabel *operationLab = [[UILabel alloc] initWithFrame:rect];
    operationLab.backgroundColor = CLEARCOLOR;
    operationLab.text = labelStr;
    operationLab.font = FONT(10);
    operationLab.textAlignment = NSTextAlignmentCenter;
    operationLab.textColor = textColor;
    return operationLab;
}

/**
 *  创建 图片背景
 */
-(UIImageView *)setValueBg:(NSString *)imageStr andRect:(CGRect)rect{
    UIImageView *valueBg = [[UIImageView alloc] initWithFrame:rect];
    valueBg.image = [[UIImage imageNamed:imageStr] stretchableImageWithLeftCapWidth:8 topCapHeight:5];
    return valueBg;
}

/**
 *  创建 按钮
 */
-(UIButton *)setOperationBtn:(CGRect)frame andTag:(NSInteger)tag{
    UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    operationBtn.frame = frame;
    operationBtn.backgroundColor = CLEARCOLOR;
    operationBtn.tag = tag;
    [operationBtn addTarget:self action:@selector(operationClick:) forControlEvents:UIControlEventTouchUpInside];
    return operationBtn;
}

/**
 *  设置评论数 修改过的地方
 */
-(void)setCommentValue:(NSString *)commentStr{
//    if (!commentStr) {
//        return;
//    }
//    _commentNumLab.text = commentStr;
}

/**
 *  设置热度数
 */
-(void)setHotValue:(NSString *)hotStr{
    if (!hotStr) {
        return;
    }
    _hotNumLab.text = hotStr;
}

/**
 *  设置是否点赞
 *
 *  @param favor  0 未登录 1 已赞过 2 未赞过
 */
- (void)setIsFavor:(int)favor{
    if (favor == 1) {
        [_zanVabg setImage:[UIImage imageNamed:@"hp_attention.png"]];
    }else if (favor == 2){
        [_zanVabg setImage:[UIImage imageNamed:@"hp_unattention.png"]];
    }
}

/**
 *  点击按钮
 */
-(void)operationClick:(id)sender{
    UIButton *tempBtn = (UIButton *)sender;
    if (tempBtn.tag == 3) {     //分享
        NSLog(@"分享");

        [self shareAction];
    }else{
        if (![[UserModel shareInfo] isLogin]) {
            [ProgressHUD showError:@"你还没有登录哦~"];
            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
            [appdelegate showLoginController];
            return;
        }
        //修改过的地方
//        if (tempBtn.tag == 0) {    //评论
//            NSLog(@"评论");
//            [self commentAction];
//        }
        else if (tempBtn.tag == 1)  //点赞
        {
            NSLog(@"点赞 或  取赞");
            [self updateFavour];
        }
//        else if (tempBtn.tag == 2)  //修改
//        {
//            NSLog(@"修改");
//            [self editAction];
//        }
    }
}

- (void)commentAction{
    UITextField *commentTld = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
    commentTld.layer.borderWidth = 1;
    commentTld.layer.borderColor = [UIColor grayColor].CGColor;
    commentTld.returnKeyType =UIReturnKeyDone;
    commentTld.delegate = self;
    commentTld.textAlignment = NSTextAlignmentCenter;
    commentTld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    commentTld.placeholder = @"评论内容...";
    [PXAlertView showAlertWithTitle:@"评论" message:nil cancelTitle:@"取消" otherTitle:@"评论" contentView:commentTld completion:^(BOOL cancelled) {
        if (!cancelled) {
            NSString *comm = commentTld.text;
            comm = [comm stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (comm == nil || [comm isEqualToString:@""]) {
                [ProgressHUD showError:@"评论内容不能为空!"];
                return;
            }
            //发送请求
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
            
            NSDictionary *parm = [HttpBody addComments:[[UserModel shareInfo] uid] ruid:-1 pid:[self.saiBean.sId intValue] original_uid:[self.saiBean.uId intValue] content:comm voice_url:nil voice_size:0];
            [ProgressHUD show:LOADING];
            
            [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
                NSLog(@"请求评论结果:%@",jsonDic);
                
                if ([[jsonDic objectForKey:@"status"] integerValue] == 1){
                    [ProgressHUD dismiss];
                    //刷新数据
                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:HP_REFRESHCOUNTDATA object:nil];
                }
                else{
                    [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
                }
                
            } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                NSLog(@"failuer");
                [ProgressHUD showError:CHECKNET];
            }];
        }
    }];
}

/**
 *  点赞，取消点赞接口
 */
-(void)updateFavour{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    int favor = self.saiBean.is_favor == 1? 2:1;
    
    NSDictionary *parm = [HttpBody updateFavourWithUId:[[UserModel shareInfo] uid] pId:[_saiBean.sId intValue] status:favor];
    [ProgressHUD show:LOADING];
    
    [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        NSLog(@"请求点赞取赞结果:%@",jsonDic);
        
        if ([[jsonDic objectForKey:@"status"] integerValue] == 1){
            [ProgressHUD dismiss];
            //刷新数据
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:HP_REFRESHCOUNTDATA object:nil];
        }
        else{
            [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"failuer");
        [ProgressHUD showError:CHECKNET];
    }];
}

- (void)editAction{
    if ([self.saiBean.uId intValue] != [[UserModel shareInfo] uid]) {
        [ProgressHUD showError:@"你不是作者不能修改哦~"];
        return;
    }
    if (self.saiBean.game_status>3) {
        [ProgressHUD showError:@"比赛已结束，不可修改作品!"];
        return;
    }
    //跳转修改页面
    UpdatePictureController *ctrller = [[UpdatePictureController alloc] init];
    ctrller.m_showBackBt = YES;
    ctrller.title = @"修改作品";
    ctrller.saiBean = self.saiBean;
    [_contrller.navigationController pushViewController:ctrller animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDDEN_TAB object:nil];
}

- (void)shareAction{
    //分享页面
    [[ShareView shareInfo] showShare:YES];
    [[ShareView shareInfo] setGid:self.saiBean.sId];
    [[ShareView shareInfo] setController:_contrller];
    [[ShareView shareInfo] setMsg:self.saiBean.title];
    [[ShareView shareInfo] setImg:[UIImage imageNamed:@"icon-60-phone.png"]];
    [[ShareView shareInfo] setPid:self.saiBean.sId];
    [[ShareView shareInfo] setMst:self.saiBean.g_title];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
