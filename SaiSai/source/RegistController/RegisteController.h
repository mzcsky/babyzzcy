//
//  RegisteController.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/2.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "XTViewController.h"

@protocol RegisteControllerDelegate <NSObject>

@optional

/**
 *  @author Xinwei  Ge, 15-12-08 12:23:15
 *
 *  注册成功回调
 *
 *  @param uname 用户名
 *  @param psw   密码
 */
- (void)registerSuccees:(NSString *)uname psw:(NSString *)psw;

@end

@interface RegisteController : XTViewController {
    dispatch_source_t _timer;
}

@property (nonatomic, assign) id<RegisteControllerDelegate> delegate;

@end
