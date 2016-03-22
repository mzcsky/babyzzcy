//
//  GlobalData.h
//  Hafa
//
//  Created by feng on 14-5-23.
//  Copyright (c) 2014年 南京哈发网络有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTTabBarController.h"

typedef enum
{
    eShareType = 0,             //分享类别
    eAlipayPayOrderType,        //支付宝支付类别
    eAlipayRechargeType,        //支付宝充值类别
    eWeixinPayOrderType,        //微信支付类别
    eWeixinRechargeType,        //微信充值类别
    eWeixinLoginType,           //微信登录类别
}ThirdType;

@interface GlobalData : NSObject

@property (nonatomic, assign)XTTabBarController *mRootController;
@property (nonatomic, assign)BOOL firstLogin;
@property (nonatomic, strong)NSMutableArray *mTempCartArr;       //加入购物车的数据
@property (nonatomic, assign)ThirdType thirdType;  //0，分享 1，支付宝支付 2，微信支付 3，微信第三方登录
@property (nonatomic, assign)BOOL mEditCart;
+(GlobalData*)shareInstance;

@end
