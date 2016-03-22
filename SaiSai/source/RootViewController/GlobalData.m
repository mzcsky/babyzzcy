//
//  GlobalData.m
//  Hafa
//
//  Created by feng on 14-5-23.
//  Copyright (c) 2014年 南京哈发网络有限公司. All rights reserved.
//

#import "GlobalData.h"

static GlobalData * this;

@implementation GlobalData
@synthesize mRootController;
@synthesize firstLogin,mTempCartArr,thirdType,mEditCart;
+(GlobalData*)shareInstance
{
    if (nil == this) {
        this = [[GlobalData alloc] init];
    }
    return this;
}

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)dealloc
{

}

@end
