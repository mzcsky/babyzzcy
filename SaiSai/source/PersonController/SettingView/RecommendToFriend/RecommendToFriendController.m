//
//  RecommendToFriendController.m
//  SaiSai
//
//  Created by Zhoufang on 15/9/7.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "RecommendToFriendController.h"
#import "MyButton.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface RecommendToFriendController ()

@property (nonatomic,strong)UIView *bgView;

@end

@implementation RecommendToFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createBgView];
    
    [self initButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createBgView{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 300)];
    _bgView.backgroundColor = [UIColor colorWithRed:237.f/255 green:239.f/255 blue:240.f/255 alpha:1.f];
    [self.view addSubview:_bgView];
    
    UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgView.width/2-60, 10, 120, 120)];
    barView.image = [UIImage imageNamed:@"download_img.png"];
    [_bgView addSubview:barView];
    
    UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, _bgView.width, 20)];
    barLabel.backgroundColor = CLEARCOLOR;
    barLabel.text = @"扫描二维码即可下载";
    barLabel.font = FONT(13);
    barLabel.textAlignment = NSTextAlignmentCenter;
    barLabel.textColor = XT_BLACKCOLOR;
    [_bgView addSubview:barLabel];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 165+9, _bgView.width/2-30, 1)];
    lineImg.backgroundColor = XT_TEXTGRAYCOLOR;
    [_bgView addSubview:lineImg];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(lineImg.right, 165, 60, 20)];
    tipLab.backgroundColor = CLEARCOLOR;
    tipLab.text = @"点击分享";
    tipLab.font = FONT(13);
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = XT_BLACKCOLOR;
    [_bgView addSubview:tipLab];
    
    UIImageView *lineImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(tipLab.right, 165+9, _bgView.width/2-30, 1)];
    lineImg2.backgroundColor = XT_TEXTGRAYCOLOR;
    [_bgView addSubview:lineImg2];
}

- (void)initButtons{
    UIImage *weiboImage = [UIImage imageNamed:@"s_sina"];
    UIImage *wxImage = [UIImage imageNamed:@"s_wx"];
    UIImage *wxqImage = [UIImage imageNamed:@"s_wxq"];
    UIImage *lianjieImg = [UIImage imageNamed:@"s_lianjie"];
    NSArray *array = [NSArray arrayWithObjects:weiboImage, wxImage, wxqImage,lianjieImg, nil];
    NSArray *names = [NSArray arrayWithObjects:@"新浪微博",@"微信",@"微信朋友圈", @"复制链接", nil];

    CGFloat width = _bgView.width/4;
    for (int i = 0; i < 4; i++) {
        UIImage *image = [array objectAtIndex:i];
        NSString *name = [names objectAtIndex:i];
        UIButton *button = [[MyButton alloc] initWithFrame:CGRectMake(i*width, 190, width, 88)];
        button.tag = i+100;
        button.backgroundColor = CLEARCOLOR;
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:139.0/255.0f green:140.0/255.0f blue:142.0/255.0f alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(11);
        [button addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:button];
    }
}

- (void)shareClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@""];
    
    switch (button.tag) {
        case 100:   //微博
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"https://itunes.apple.com/us/app/sai-sai/id1017653419?l=zh&ls=1&mt=8" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
            break;
        case 101:   //微信
        {
            [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:@""];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"https://itunes.apple.com/us/app/sai-sai/id1017653419?l=zh&ls=1&mt=8" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];

        }
            break;
        case 102:   //微信朋友圈
        {
            [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:@""];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"https://itunes.apple.com/us/app/sai-sai/id1017653419?l=zh&ls=1&mt=8" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];

        }
            break;
        case 103:   //复制链接
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"红红火火";
            [ProgressHUD showSuccess:@"复制成功!"];
        }
            break;
            
        default:
            break;
    }
}


@end
