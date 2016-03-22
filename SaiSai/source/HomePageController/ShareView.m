//
//  ShareView.m
//  SaiSai
//
//  Created by weige on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "MyButton.h"
#import "ShareView.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

static ShareView    *_shareView;

@implementation ShareView

#pragma mark
#pragma mark ====== 初始化 ======
/**
 *  初始化单例
 *
 *  @return 分享页面单例
 */
+ (ShareView *)shareInfo{
    @synchronized(self){
        if (_shareView == nil) {
            _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }
    }
    return _shareView;
}

/**
 *   释放单例
 */
+ (void)freeInfo{
    if (_shareView) {
        [_shareView clear];
        _shareView = nil;
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _pid = @"";
        _gid = @"";
        [self initView];
    }
    return self;
}

- (void)clear{
    
}

- (void)initView{
    NSMutableArray *nameArray = [NSMutableArray array];
    NSMutableArray *imgArray = [NSMutableArray array];
    _typeArray = [NSMutableArray array];
    [nameArray addObject:@"微博"];
    [imgArray addObject:@"share_weibo.png"];
    [_typeArray addObject:@"weibo"];
    if ([WXApi isWXAppInstalled]) {
        [nameArray addObject:@"微信"];
        [imgArray addObject:@"share_weixin.png"];
        [nameArray addObject:@"朋友圈"];
        [imgArray addObject:@"share_wxfc.png"];
        [_typeArray addObject:@"weixin"];
        [_typeArray addObject:@"weixinfc"];
    }
    if ([TencentOAuth iphoneQQInstalled]) {
        [nameArray addObject:@"QQ"];
        [imgArray addObject:@"share_qq.png"];
        [_typeArray addObject:@"qq"];
    }
    if ([TencentOAuth iphoneQZoneInstalled]) {
        [nameArray addObject:@"QQ空间"];
        [imgArray addObject:@"share_qqkj.png"];
        [_typeArray addObject:@"qqz"];
    }
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _cancleBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_cancleBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancleBtn];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-290)/2, (SCREEN_HEIGHT-375), 270, 355)];
    _contentView.backgroundColor = CLEARCOLOR;
    [self addSubview:_contentView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 250, 335)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 9;
    bgView.clipsToBounds = YES;
    [_contentView addSubview:bgView];
    
    UIImage *image = [UIImage imageNamed:@"share_close.png"];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(270-20, 0, 40, 40);
    [closeBtn setImage:image forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeBtn];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 250, 30)];
    title.backgroundColor = CLEARCOLOR;
    title.text = @"分享";
    title.font = Bold_FONT(15);
    title.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:title];
    
    for (int i = 0; i < nameArray.count; i++) {
        NSString *name = [nameArray objectAtIndex:i];
        NSString *img = [imgArray objectAtIndex:i];
        
        int col = i%4;
        int row = i/4;
        UIImage *image = [UIImage imageNamed:img];
        MyButton *btn = [[MyButton alloc]initWithFrame:CGRectMake(25+col*50, 62+row*75, 50, 75)];
        btn.tag = i+100;
        btn.backgroundColor = CLEARCOLOR;
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:139.0/255.0f green:140.0/255.0f blue:142.0/255.0f alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(11);
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(25, 232, 200, 2)];
    line.backgroundColor = [UIColor colorWithRed:139.0/255.0f green:140.0/255.0f blue:142.0/255.0f alpha:1];
    [bgView addSubview:line];
    
    MyButton *warnBtn = [[MyButton alloc] initWithFrame:CGRectMake(100, 246, 50, 75)];
    warnBtn.backgroundColor = CLEARCOLOR;
    [warnBtn setImage:[UIImage imageNamed:@"share_warning.png"] forState:UIControlStateNormal];
    [warnBtn setTitle:@"举报" forState:UIControlStateNormal];
    [warnBtn setTitleColor:[UIColor colorWithRed:139.0/255.0f green:140.0/255.0f blue:142.0/255.0f alpha:1] forState:UIControlStateNormal];
    warnBtn.titleLabel.font = FONT(11);
    warnBtn.tag = 99;
    [warnBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:warnBtn];
    
    _contentView.center = CGPointMake(SCREEN_WIDTH/2, 3*SCREEN_HEIGHT/2);
}

- (void)hidden{
    [self hiddenShare:YES];
}

#pragma mark
#pragma mark ====== 显示隐藏 ======
/**
 *  显示
 *
 *  @param animation 是否有动画
 */
- (void)showShare:(BOOL)animation{
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = application.keyWindow;
    [window addSubview:self];
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        }];
    }else{
        _contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    }
}

/**
 *  隐藏
 *
 *  @param animation 是否有动画
 */
- (void)hiddenShare:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.center = CGPointMake(SCREEN_WIDTH/2, 3*SCREEN_HEIGHT/2);
        } completion:^(BOOL finished) {
            if (finished) {
                _shareMsg = nil;
                _shareImg = nil;
                _shareWeb = nil;
                _shareMst = nil;
                _pid = @"";
                _gid = @"";
                [self removeFromSuperview];
            }
        }];
    }else{
        _shareMst = nil;
        _shareMsg = nil;
        _shareImg = nil;
        _shareWeb = nil;
        _pid = @"";
        _gid = @"";
        [self removeFromSuperview];
    }
}

#pragma mark
#pragma mark ====== 设置 ======
/**
 *  设置分享文字
 *
 *  @param msg 文字
 */
- (void)setMsg:(NSString *)msg{
    _shareMsg = msg;
}
/**
 *  设置分享标题
 *
 *  @param mst 标题
 */
- (void)setMst:(NSString *)mst{
    _shareMst = mst;
}

/**
 *  设置分享网站
 *
 *  @param web 网站
 */
- (void)setWeb:(NSString *)web{
    _shareWeb = web;
}

/**
 *  设置分享图片
 *
 *  @param img 图片
 */
- (void)setImg:(UIImage *)img{
    _shareImg = img;
    
}

/**
 *  设置主题id
 *
 *  @param pid 主题id
 */
- (void)setPid:(NSString *)pid{
    _pid = pid;
}

/**
 *  设置作品id
 *
 *  @param gid 作品id
 */
- (void)setGid:(NSString *)gid{
    _gid = gid;
}

/**
 *  设置 xtviewcontroller
 *
 *  @param ctrller
 */
-(void)setController:(XTViewController *)ctrller{
    _contrller = ctrller;
}

#pragma mark
#pragma mark ====== action ======

- (void)btnAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 99:    //举报
        {
            if (_pid>0) {
                UITextField *commentTld = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
                commentTld.layer.borderWidth = 1;
                commentTld.layer.borderColor = [UIColor grayColor].CGColor;
                commentTld.returnKeyType =UIReturnKeyDone;
                commentTld.delegate = self;
                commentTld.textAlignment = NSTextAlignmentCenter;
                commentTld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                commentTld.placeholder = @"举报内容...";
                [PXAlertView showAlertWithTitle:@"举报" message:nil cancelTitle:@"取消" otherTitle:@"举报" contentView:commentTld completion:^(BOOL cancelled) {
                    if (!cancelled) {
                        NSString *comm = commentTld.text;
                        comm = [comm stringByReplacingOccurrencesOfString:@" " withString:@""];
                        if (comm == nil || [comm isEqualToString:@""]) {
                            [ProgressHUD showError:@"举报内容不能为空!"];
                            return;
                        }
                        //发送请求
                        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
                        
                        NSDictionary *parm = [HttpBody addreport:_pid comment:comm];
                        [ProgressHUD show:LOADING];
                        
                        [manager GET:URLADDRESS parameters:parm success:^(AFHTTPRequestOperation * operation, id response) {
                            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
                            NSLog(@"请求举报结果:%@",jsonDic);
                            
                            if ([[jsonDic objectForKey:@"status"] integerValue] == 1){
                                [ProgressHUD showSuccess:@"举报成功!"];
                                //刷新数据
                                [self hiddenShare:YES];
                            }
                            else{
                                [ProgressHUD showError:[jsonDic objectForKey:@"msg"]];
                            }
                            
                        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
                            NSLog(@"failuer");
                            [ProgressHUD showError:CHECKNET];
                        }];
                        [[ShareView shareInfo] hidden];
                    }else{
                        [[ShareView shareInfo] hidden];
                    }
                }];
            }else{
                [ProgressHUD showError:@"此处不可以举报!"];
                [[ShareView shareInfo] hidden];
            }
        }
            break;
        default:
        {
            NSString *KEY = [_typeArray objectAtIndex:btn.tag-100];
            if ([KEY isEqualToString:@"weibo"]) {
                [self shareWeiBo];
            }else if ([KEY isEqualToString:@"weixin"]){
                [self shareWeixin];
            }else if ([KEY isEqualToString:@"weixinfc"]){
                [self shareWinxinFc];
            }else if ([KEY isEqualToString:@"qq"]){
                [self shareQQ];
            }else if ([KEY isEqualToString:@"qqz"]){
                [self shareQQZ];
            }
        }
            break;
    }
}


- (void)shareQQZ{
    NSString *shareUrl = [NSString stringWithFormat:@"%@?pid=%@&gid=%@", SHARE_ADDRESS, _pid, _gid];
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareUrl];
    
    [UMSocialQQHandler setQQWithAppId:TECENT_APPID appKey:TECENT_APPKEY url:shareUrl];
    [UMSocialData defaultData].extConfig.qzoneData.title = _shareMst;

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_shareMsg image:_shareImg location:nil urlResource:urlResource presentedController:_contrller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [[ShareView shareInfo] hidden];
}

- (void)shareQQ{
    NSString *shareUrl = [NSString stringWithFormat:@"%@?pid=%@&gid=%@", SHARE_ADDRESS, _pid, _gid];
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareUrl];

    [UMSocialQQHandler setQQWithAppId:TECENT_APPID appKey:TECENT_APPKEY url:shareUrl];
    [UMSocialData defaultData].extConfig.qqData.title = _shareMst;

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_shareMsg image:_shareImg location:nil urlResource:urlResource presentedController:_contrller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [[ShareView shareInfo] hidden];
}

- (void)shareWinxinFc{
    NSString *shareUrl = [NSString stringWithFormat:@"%@?pid=%@&gid=%@", SHARE_ADDRESS, _pid, _gid];
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        shareUrl];

    [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:shareUrl];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareMst;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_shareMsg image:_shareImg location:nil urlResource:urlResource presentedController:_contrller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [[ShareView shareInfo] hidden];
}

- (void)shareWeixin{
    NSString *shareUrl = [NSString stringWithFormat:@"%@?pid=%@&gid=%@", SHARE_ADDRESS, _pid, _gid];
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        shareUrl];
    [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:shareUrl];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareMst;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_shareMsg image:_shareImg location:nil urlResource:urlResource presentedController:_contrller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [[ShareView shareInfo] hidden];
}

- (void)shareWeiBo{
    NSString *shareUrl = [NSString stringWithFormat:@"%@?pid=%@&gid=%@", SHARE_ADDRESS, _pid, _gid];
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        shareUrl];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_shareMsg image:_shareImg location:nil urlResource:urlResource presentedController:_contrller completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            [ProgressHUD showSuccess:@"分享成功!"];
        }
    }];
    [[ShareView shareInfo] hidden];
}

@end
