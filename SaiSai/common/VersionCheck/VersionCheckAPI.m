//
//  VersionCheckAPI.m
//  YunShop
//
//  Created by weige on 15/7/29.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "VersionCheckAPI.h"
#import "DVersionView.h"

#define VERSION_CHECK_URL   @"http://api.fir.im/apps/latest/"
#define APP_ID              @"562a7df2f2fc4216b0000002"
#define API_TOKEN           @"fcb0b4e710a756f1f75b8ada7d9d3b1b"

#define DOWNLOAD_URL        @"itms-services://?action=download-manifest&url=https://fir.im/plists/:"

@implementation VersionCheckAPI

+ (void)checkVersion{
    //清空版本数据
    
    //检测版本
    [VersionCheckAPI checkVersionByFir];
}

+ (float)currentVersion{
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] floatValue];
}

+ (void)checkVersionByFir{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:API_TOKEN forKey:@"api_token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@",VERSION_CHECK_URL,APP_ID];
    [manager GET:url parameters:pram success:^(AFHTTPRequestOperation * operation, id response) {
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"版本检测结果：%@",resDict);
        if (resDict && [resDict isKindOfClass:[NSDictionary class]]) {
            float version = [[resDict objectForKey:@"version"] floatValue];
            
            if (version>[VersionCheckAPI currentVersion]) {
                NSString *upUrl = [NetDataCommon stringFromDic:resDict forKey:@"update_url"];
                NSString *chlog = [NetDataCommon stringFromDic:resDict forKey:@"changelog"];
                //更新fir版本
                [VersionCheckAPI updataFir:version log:chlog durl:upUrl];
            }
        }else{
        }
    } failure:^(AFHTTPRequestOperation * operation, NSError * response) {
    }];
}

+ (void)updataFir:(float)version log:(NSString *)log durl:(NSString *)durl{
    NSLog(@"updataFir");
    NSString *notice = [NSString stringWithFormat:@"发现新版本V%.2f",version];
    NSString *msg = [NSString stringWithFormat:@"新特性:%@",log];
    [PXAlertView showAlertWithTitle:notice message:msg cancelTitle:@"取消" otherTitle:@"去下载" completion:^(BOOL cancelled) {
        if (!cancelled) {
            if (IOS_VERSION>=7.1 || fabs(IOS_VERSION-7.1) < 0.000001) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/sai-sai/id1017653419?l=zh&ls=1&mt=8"]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/sai-sai/id1017653419?l=zh&ls=1&mt=8"]];
            }
            
//            NSString *sDUrl = durl;
//            DVersionView *view = [[DVersionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            [view loadUrl:sDUrl];
//            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//            [window addSubview:view];
//            [view showAnimation];
        }
    }];
}



@end
