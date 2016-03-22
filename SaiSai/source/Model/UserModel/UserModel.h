//
//  UserModel.h
//  PurchaseManager
//
//  Created by weige on 15/4/8.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject{
    NSMutableDictionary    *_userDict;
}

@property (nonatomic, retain) NSString *deviceToken;

@property (nonatomic, assign) BOOL    isLogin;

#pragma mark
#pragma mark ====== 单例初始化 ======
/**
 *  单例初始化
 *
 *  @return 用户信息单例
 *
 *  @since 2015-03-25
 */
+ (UserModel *)shareInfo;

/**
 *  释放用户信息单例
 *
 *  @since 2015-03-25
 */
+ (void)freeInfo;

#pragma mark
#pragma mark ====== 设置 ======
/**
 *  设置用户信息
 *
 *  @param dict 用户信息
 *
 *  @since 2015-03-25
 */
- (void)setUserInfo:(NSDictionary *)dict;

- (void)saveInfo;

#pragma mark
#pragma mark ====== 获取 ======

/**
 *  昵称
 *
 *  @return 昵称
 */
- (NSString *)nickName;

/**
 *  头像
 *
 *  @return 头像
 */
- (NSString *)icon;

/**
 *  手机号
 *
 *  @return 手机号
 */
- (NSString *)phone;

/**
 *  用户id
 *
 *  @return 用户id
 *
 *  @since 2015-04-08
 */
- (int)uid;

/**
 *  获取性别
 *
 *  @return 性别
 */
- (int)gender;

/**
 *  设置头像
 *
 *  @param icon 头像
 */
- (void)setIcon:(NSString *)icon;

/**
 *  设置昵称
 *
 *  @param name 昵称
 */
- (void)setNickName:(NSString *)name;

/**
 *  设置性别
 *
 *  @param gender 性别
 */
- (void)setGender:(int)gender;


@end
