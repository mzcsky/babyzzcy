//
//  Interface.h
//  SaiSai
//
//  Created by weige on 15/8/15.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#ifndef SaiSai_Interface_h
#define SaiSai_Interface_h

#pragma mark ====== 通知 ========
#define HP_REFRESH            @"HP_REFRESH"             //从第一页开始刷
#define HP_REFRESHCOUNTDATA   @"HP_REFRESHCOUNTDATA"    //刷新到当前页

#pragma mark
#pragma mark ====== 分页数据 ======

#define PAGE_COUNT      @"10"


#pragma mark
#pragma mark ====== 网络请求 ======

#define KGetRecommendList          @"http://api.saisaiapp.com/api.php?action=getRecommendList"

#define URLADDRESS          @"http://api.saisaiapp.com/api.php"

#define SHARE_ADDRESS       @"http://api.saisaiapp.com/share.php"

#define UPFILE_ADDRESS      @"http://api.saisaiapp.com/api.php?action=addfiles"

#define APPLY_ADDRESS       @"http://api.saisaiapp.com/api.php?action=addApply"

#define USER_PROTOCAL       @"http://m.saisaiapp.com/nd.jsp?id=13&groupId=0"

#pragma mark
#pragma mark ===== 友盟 key =====

//赛赛 腾讯开放平台
#define TECENT_APPID    @"1104739289"
#define TECENT_APPKEY   @"K9vK8Y9DuGg0QS9P"

//赛赛 微信开放平台
#define WX_APPID        @"wxa25ffd12052155bf"
#define WX_APPSECRET    @"7952e45a5349a00d3891c54007f0b5a9"

//赛赛 微博开放平台
#define WB_APPID        @"2249456858"
#define WB_APPSECRET    @"78cfa89cf72ec1b5ad9c78e0d985aee0"

#define KUserName       @"KUserName"




#endif
