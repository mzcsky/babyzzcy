//
//  AppDelegate.m
//  SaiSai
//
//  Created by weige on 15/8/15.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "GuidePage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "VersionCheckAPI.h"
#import "QingZiController.h"
#import "APService.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic, retain) XTTabBarController    *tabCtrl;

@end

@implementation AppDelegate

- (void)dealloc{
    [self removeNotification];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //显示状态栏    颜色
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    

    [[PositionTool shareInfo] updataLocation];
    
    [self registerNotification];
    
    [self registeUMShare];
    /**
     *  初始化个人信息
     */
    [UserModel shareInfo];
    
    /**
     *  版本检测
     */
    [VersionCheckAPI checkVersion];
    
    /**
     *  判断是否是新版本，是现实引导页，否不显示引导页，直接加载登陆页面
     */

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString * oldVersion = [defaults objectForKey:@"oldVersion"];
    NSString *version =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    if (![version isEqualToString:oldVersion])
    {
        GuidePage * loadCtrller = [[GuidePage alloc] init];
        self.window.rootViewController = loadCtrller;
    }else{
        [self initMainViewController];
    }
    [defaults setObject:version forKey:@"oldVersion"];
    [defaults synchronize];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
 
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             
                                             
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];

//    [APService setTags:nil alias:@"test1" callbackSelector:@selector(test1) target:self];
    
    [self.window makeKeyAndVisible];
    return YES;
}


//-(void)test1{
//    
//    NSLog(@"====");
//}
-(void)registeUMShare{
    [UMSocialData setAppKey:@"5615258ce0f55aada0003022"];
    
    //打开调试log的开关
    [UMSocialData openLog:NO];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:nil];
    
    [UMSocialQQHandler setQQWithAppId:TECENT_APPID appKey:TECENT_APPKEY url:nil];
    
    [WeiboSDK registerApp:WB_APPID];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession]];
    
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    /**
     *  版本检测
     */
    [VersionCheckAPI checkVersion];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTab) name:SHOW_TAB object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTab) name:HIDDEN_TAB object:nil];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOW_TAB object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HIDDEN_TAB object:nil];
}

- (void)showTab{
    [self.tabCtrl setmTabBarViewHidden:NO animation:YES];
}

- (void)hiddenTab{
    [self.tabCtrl setmTabBarViewHidden:YES animation:YES];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    

}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"===========%@=========",userInfo);
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    
    [APService handleRemoteNotification:userInfo];
    //推送 网页跳转
    NSString * url = userInfo[@"aps"][@"alert"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application
                didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

#pragma mark
#pragma mark ====== 初始化主页面 ======

- (void)initMainViewController{
    if (self.tabCtrl) {
        self.tabCtrl = nil;
    }
    self.tabCtrl = [[XTTabBarController alloc] init];
    self.tabCtrl.delegate = self;
    NSArray * norImage = [[NSArray alloc] initWithObjects:@"tab_home_nor.png",@"tab_math_nor.png",@"tab_xx_nor.png",@"tab_my_nor.png",nil];
    NSArray * selImage = [[NSArray alloc] initWithObjects:@"tab_home_sel.png",@"tab_math_sel.png",@"tab_xx_sel.png",@"tab_my_sel.png",nil];
    NSArray *titleArr = [[NSArray alloc] initWithObjects:@"风采展示",@"比赛测评",@"休闲活动",@"我的", nil];
    [self.tabCtrl stupTabBarViewWithHeigth:49.0 norImage:norImage selImage:selImage titleArr:titleArr];
    
    NSMutableArray * tabCtrllers = [[NSMutableArray alloc] init];
    HomePageController * view1 = [[HomePageController alloc] init];

    view1.title = @"重在参与";
    view1.mIsMainPage = YES ;
    [tabCtrllers addObject:view1];
    
    MatchController * view2= [[MatchController alloc] init];
    view2.title = @"参赛主题";
    [tabCtrllers addObject:view2];
    
    QingZiController *view3 = [[QingZiController alloc] init];
    view3.title = @"休闲活动";
    [tabCtrllers addObject:view3]; 
    
    PersonController * view4= [[PersonController alloc] init];
    view4.title = @"我的";
    [tabCtrllers addObject:view4];
    
    NSMutableArray* naviCtrllers = [[NSMutableArray alloc] initWithCapacity:tabCtrllers.count];
    for (int i = 0; i < tabCtrllers.count; ++i)
    {
        XTViewController * viewctrler = [tabCtrllers objectAtIndex:i];
        
        XTCustomNavigationController* naviCtrller = [[XTCustomNavigationController alloc]
                                                     initWithRootViewController:viewctrler];
        [naviCtrllers addObject:naviCtrller];
        
    }
    self.tabCtrl.viewControllers = naviCtrllers;
    self.tabCtrl.selectedIndex = 0;
    
    [GlobalData shareInstance].mRootController = self.tabCtrl;
    
    self.window.rootViewController = self.tabCtrl;
    
    CATransition *bAnimation = [CATransition animation];
    bAnimation.duration = 1.f ;
    bAnimation.timingFunction = UIViewAnimationCurveEaseInOut;//[CAMediaTimingFunction functionWithName:
    [self.window.layer addAnimation:bAnimation forKey:@"animation"];
    


}

#pragma mark
#pragma mark ====== UITabBarControllerDelegate ======
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *curCtrl = [((XTCustomNavigationController*)viewController).viewControllers firstObject];
    if ([curCtrl isKindOfClass:[MatchController class]] || [curCtrl isKindOfClass:[PersonController class]] || [curCtrl isKindOfClass:[QingZiController class]]) {
        if (![[UserModel shareInfo] isLogin]) {
            //显示登录页面
            [self showLoginController];
            return NO;
        }
    }
    return YES;
}

- (void)showLoginController{
    LoginViewController *ctrl = [[LoginViewController alloc] init];
    ctrl.title = @"学习活动比赛平台";
    ctrl.m_showBackBt = YES;
    ctrl.m_hasNav = NO;
    XTCustomNavigationController* naviCtrller = [[XTCustomNavigationController alloc] initWithRootViewController:ctrl];
    [self.tabCtrl presentViewController:naviCtrller animated:YES completion:^{
        
    }];
    [self.tabCtrl setSelectedViewController:[self.tabCtrl.viewControllers firstObject]];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
