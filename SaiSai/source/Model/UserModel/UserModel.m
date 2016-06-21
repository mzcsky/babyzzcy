//
//  UserModel.m
//  PurchaseManager
//
//  Created by weige on 15/4/8.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "UserModel.h"
#import <CommonCrypto/CommonDigest.h>



static UserModel    *_userModel;

@implementation UserModel

#pragma mark
#pragma mark ====== 单例初始化 ======
/**
 *  单例初始化
 *
 *  @return 用户信息单例
 *
 *  @since 2015-03-25
 */
+ (UserModel *)shareInfo{
    @synchronized(self){
        if (_userModel == nil) {
            _userModel = [[UserModel alloc] init];
        }
    }
    return _userModel;
}

/**
 *  释放用户信息单例
 *
 *  @since 2015-03-25
 */
+ (void)freeInfo{
    if (_userModel) {
        [_userModel clear];
        _userModel = nil;
    }
}

- (id)init{
    self = [super init];
    if (self) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:USERINFO_DICTIONARY];
        if (dict != nil && dict.allKeys.count>0) {
            [self setUserInfo:dict];
        }
    }
    return self;
}

- (void)clear{
    _userDict = nil;
    self.isLogin = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO_DICTIONARY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark
#pragma mark ====== 设置 ======
/**
 *  设置用户信息
 *
 *  @param dict 用户信息
 *
 *  @since 2015-03-25
 */
- (void)setUserInfo:(NSDictionary *)dict{
    if (dict == nil) {
        self.isLogin = NO;
        return;
    }
    [self clear];
    if (_userDict) {
        _userDict = nil;
    }
    self.isLogin = YES;
    _userDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [[NSUserDefaults standardUserDefaults] setObject:_userDict forKey:USERINFO_DICTIONARY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveInfo{
    [[NSUserDefaults standardUserDefaults] setObject:_userDict forKey:USERINFO_DICTIONARY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark
#pragma mark ====== 获取 ======

/**
 *  昵称
 *
 *  @return 昵称
 */
- (NSString *)nickName{
    return [NetDataCommon stringFromDic:_userDict forKey:@"nick_name"];
}

/**
 *  头像
 *
 *  @return 头像
 */
- (NSString *)icon{
    return [NetDataCommon stringFromDic:_userDict forKey:@"icon"];
}

/**
 *  手机号
 *
 *  @return 手机号
 */
- (NSString *)phone{
    return [NetDataCommon stringFromDic:_userDict forKey:@"phone"];
}

/**
 *  用户id
 *
 *  @return 用户id
 *
 *  @since 2015-04-08
 */
- (int)uid{
    return [[NetDataCommon stringFromDic:_userDict forKey:@"id"] intValue];
}

/**
 *  获取性别
 *
 *  @return 性别
 */
- (int)gender{
    int gender = [[NetDataCommon stringFromDic:_userDict forKey:@"gender"] intValue];
    if (gender != 1 && gender!= 2) {
        gender = 1;
    }
    return gender;
}

/**
 *  设置头像
 *
 *  @param icon 头像
 */
- (void)setIcon:(NSString *)icon{
    if (icon == nil) {
        icon = @"";
    }
    [_userDict setObject:icon forKey:@"icon"];
}

/**
 *  设置昵称
 *
 *  @param name 昵称
 */
- (void)setNickName:(NSString *)name{
    if (name == nil) {
        name = @"";
    }
    [_userDict setObject:name forKey:@"nick_name"];
}

/**
 *  设置性别
 *
 *  @param gender 性别
 */
- (void)setGender:(int)gender{
    if (gender != 1 && gender!= 2) {
        gender = 1;
    }
    [_userDict setObject:@(gender) forKey:@"gender"];
}



@end
