//
//  HttpBody.m
//  SaiSai
//
//  Created by weige on 15/8/15.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "HttpBody.h"

@implementation HttpBody

/**
 *  获取验证码
 *
 *  @param phone 手机号码
 *
 *  @return
 */
+(NSDictionary *)getRandCode:(NSString *)phone{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getRandCode" forKey:@"action"];
    [pram setObject:phone forKey:@"phone"];
    return pram;
}

/**
 *  注册请求包体
 *
 *  @param phone    电话
 *  @param nickname 昵称
 *  @param gender   gender description
 *  @param psw      密码
 *  @param openid   openid description
 *
 *  @return 注册请求包体
 */
+ (NSDictionary *)resisterBody:(NSString *)phone nickName:(NSString *)nickname gender:(int)gender psw:(NSString *)psw openid:(NSString *)openid{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"register" forKey:@"action"];
    [pram setObject:phone forKey:@"phone"];
    [pram setObject:nickname forKey:@"nick_name"];
    [pram setObject:@(gender) forKey:@"gender"];
    [pram setObject:psw forKey:@"passwd"];
    [pram setObject:openid forKey:@"openid"];
    return pram;
}

/**
 *  登录包体
 *
 *  @param phone 电话
 *  @param psw   密码
 *
 *  @return 登录包体
 */
+ (NSDictionary *)loginBody:(NSString *)phone psw:(NSString *)psw{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"login" forKey:@"action"];
    [pram setObject:phone forKey:@"phone"];
    [pram setObject:psw forKey:@"passwd"];
    return pram;
}

/**
 *  第三方登录包体
 *
 *  @param openid 第三方登录openid
 *
 *  @return 第三方登录包体
 */
+ (NSDictionary *)unionLoginBody:(NSString *)openid nickName:(NSString *)nickName icon:(NSString *)icon{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"openlogin" forKey:@"action"];
    [pram setObject:openid forKey:@"openid"];
    [pram setObject:nickName forKey:@"nick_name"];
    [pram setObject:icon forKey:@"icon"];
    return pram;
}

/**
 *  修改密码包体
 *
 *  @param uid    用户id
 *  @param oldPsw 旧密码
 *  @param psw    新密码
 *
 *  @return 修改密码包体
 */
+ (NSDictionary *)changePswBody:(int)uid oldPsw:(NSString *)oldPsw psw:(NSString *)psw{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"changePasswd" forKey:@"action"];
    [pram setObject:oldPsw forKey:@"oldpasswd"];
    [pram setObject:psw forKey:@"passwd"];
    return pram;
}

/**
 *  重置密码
 *
 *  @param phone 用户号码
 *  @param psw 密码
 *
 *  @return 重置密码包体
 */
+ (NSDictionary *)resetPswBody:(NSString *)phone psw:(NSString *)psw{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"resetPasswd" forKey:@"action"];
    [pram setObject:phone forKey:@"phone"];
    [pram setObject:psw forKey:@"passwd"];
    return pram;
}

/**
 *  获取年龄分类列表
 *
 *  @return 年龄分类列表包体
 */
+ (NSDictionary *)ageTypeListBody{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getAgeTypeList" forKey:@"action"];
    return pram;
}

/**
 *  获取参赛作品列表
 *
 *  @param page 页码
 *  @param rows 每页数量
 *  @param fage 起始年龄
 *  @param eage 结束年龄
 *  @param uid  用户id
 *  @param isMy 是否是我的作品   0：不是 1：是
 *  @param gid  比赛主题id
 *  @param isaward 是否查询已经获奖的
 *  @param awardconfig_id  获奖配置的id
 *  @param keyword 搜索
 *  @return 参赛作品列表包体
 */
+ (NSDictionary *)applyListBody:(int)page rows:(int)rows fage:(int)fage eage:(int)eage uid:(int)uid isMy:(int)isMy gid:(int)gid isaward:(int)isaward awardconfigId:(int)awardId keyword:(NSString *)keyword{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getApplyList" forKey:@"action"];
    if (page >= 0) {
        [pram setObject:@(page) forKey:@"page"];
    }
    if (rows >= 0) {
        [pram setObject:@(rows) forKey:@"rows"];
    }
    if (uid>=0) {
        [pram setObject:@(uid) forKey:@"uid"];
    }
    if (fage>=0) {
        [pram setObject:@(fage) forKey:@"fage"];
    }
    if (eage>=0) {
        [pram setObject:@(eage) forKey:@"eage"];
    }
    if (isMy == 1) {
        [pram setObject:@(isMy) forKey:@"is_myapply"];
    }
    if (gid>=0) {
        [pram setObject:@(gid) forKey:@"gid"];
    }
    if (awardId >= 0) {
        [pram setObject:@(awardId) forKey:@"awardconfig_id"];
    }
    [pram setObject:keyword forKey:@"keyword"];
//    if (isaward>=0) {
//        [pram setObject:@(isaward) forKey:@"is_award"];
//    }
    return pram;
}
/*
 *  获奖作品查询接口
 */
/**
 *  获奖作品查询
 *
 *  @param page    页数
 *  @param rows    条数
 *  @param uid     当前用户ID
 *  @param gid     比赛ID
 *  @param keyword 关键字查询
 *
 *  @return
 */
+ (NSDictionary *)findApplyListByCondition:(int)page rows:(int)rows fage:(int)fage eage:(int)eage uid:(int)uid isMy:(int)isMy gid:(int)gid isaward:(int)isaward awardconfigId:(int)awardId keyword:(NSString *)keyword{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    
    if (page >= 0) {
        [pram setObject:@(page) forKey:@"page"];
    }
    if (rows >= 0) {
        [pram setObject:@(rows) forKey:@"rows"];
    }
    if (fage>=0) {
        [pram setObject:@(fage) forKey:@"fage"];
    }
    if (eage>=0) {
        [pram setObject:@(eage) forKey:@"eage"];
    }
    if (isMy == 1) {
        [pram setObject:@(isMy) forKey:@"is_myapply"];
    }
    if (awardId >= 0) {
        [pram setObject:@(awardId) forKey:@"awardconfig_id"];
    }

    if (gid>=0) {
        [pram setObject:@(gid) forKey:@"gid"];
    }
    if (uid>=0) {
        [pram setObject:@(uid) forKey:@"uid"];
    }
    [pram setObject:keyword forKey:@"keyword"];
    
    return pram;
    
}

/**
 *  获取参赛主题列表接口
 *
 *  @param page 页码
 *  @param rows 每页数量
 *
 *  @return 获取参赛主题列表接口包体
 */
+ (NSDictionary *)gameListBody:(int)page rows:(int)rows status:(int)status projectid:(int)proId{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getGamesList" forKey:@"action"];
    [pram setObject:@(page) forKey:@"page"];
    [pram setObject:@(rows) forKey:@"rows"];
    [pram setObject:@(proId) forKey:@"project_id"];

    if (status>=0) {
        [pram setObject:@(status) forKey:@"status"];
    }
    return pram;
}





/**
 *  点赞，取消点赞接口
 *
 *  @param uId    用户id
 *  @param pId    作品id
 *  @param status 点赞状态 1 点赞 2 取消点赞
 *
 *  @return 
 */
+ (NSDictionary *)updateFavourWithUId:(int)uId pId:(int)pId status:(int)status{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"updatefavour" forKey:@"action"];
    [pram setObject:@(uId) forKey:@"uid"];
    [pram setObject:@(pId) forKey:@"pid"];
    [pram setObject:@(status) forKey:@"status"];
    return pram;
}

/**
 *  获取评论列表
 *
 *  @param uid  用户id
 *  @param page 页码
 *  @param rows 行数
 *
 *  @return 获取评论列表包体
 */
+ (NSDictionary *)getCommentList:(int)uid page:(int)page rows:(int)rows{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getCommentsList" forKey:@"action"];
    [pram setObject:@(uid) forKey:@"uid"];
    [pram setObject:@(page) forKey:@"page"];
    [pram setObject:@(rows) forKey:@"rows"];
    return pram;
}

/**
 *  获取我的关注列表
 *
 *  @param uId  用户id
 *  @param page 页码
 *  @param rows 每页数量
 *
 *  @return
 */
+ (NSDictionary *)getMyAttendWithUId:(int)uId page:(int)page rows:(int)rows{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getAttentionList" forKey:@"action"];
    [pram setObject:@(page) forKey:@"page"];
    [pram setObject:@(rows) forKey:@"rows"];
    [pram setObject:@(uId) forKey:@"uid"];
    return pram;
}

/**
 *  获取我的粉丝列表
 *
 *  @param uId  用户id
 *  @param page 页码
 *  @param rows 每页数量
 *
 *  @return
 */
+ (NSDictionary *)getMyFansWithUId:(int)uId page:(int)page rows:(int)rows{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getFansList" forKey:@"action"];
    [pram setObject:@(page) forKey:@"page"];
    [pram setObject:@(rows) forKey:@"rows"];
    [pram setObject:@(uId) forKey:@"uid"];
    return pram;
}

/**
 *  添加或者取消关注
 *
 *  @param uId    用户id
 *  @param bId    被关注人id
 *  @param status 1 关注  2取消关注
 *
 *  @return
 */
+(NSDictionary *)attendOrCancelAttendWithUId:(int)uId bId:(int)bId status:(int)status{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"updateAttention" forKey:@"action"];
    [pram setObject:@(uId) forKey:@"uid"];
    [pram setObject:@(bId) forKey:@"bid"];
    [pram setObject:@(status) forKey:@"status"];
    return pram;
}

/**
 *  上传文件
 *
 *  @return 上传文件包体
 */
+ (NSDictionary *)addFiles{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"addfiles" forKey:@"action"];
    return pram;
}

/**
 *  更新个人信息
 *
 *  @return 更新个人信息包体
 */
+ (NSDictionary *)updateUserInfo:(int)uid icon:(NSString *)icon nickName:(NSString *)nickName gender:(int)gender{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"updateUserInfo" forKey:@"action"];
    [pram setObject:@(uid) forKey:@"uid"];
    [pram setObject:icon forKey:@"icon"];
    [pram setObject:nickName forKey:@"nick_name"];
    [pram setObject:@(gender) forKey:@"gender"];
    return pram;
}

/**
 *  评论
 *
 *  @return 评论包体
 */
+ (NSDictionary *)addComments:(int)uid ruid:(int)ruid pid:(int)pid original_uid:(int)original_uid content:(NSString *)content voice_url:(NSString *)voice_url voice_size:(int)voice_size{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"addComments" forKey:@"action"];
    [pram setObject:@(uid) forKey:@"uid"];
    [pram setObject:@(pid) forKey:@"pid"];
    [pram setObject:@(original_uid) forKey:@"original_uid"];
    [pram setObject:content forKey:@"content"];
    if (voice_url!=nil && ![voice_url isEqualToString:@""]) {
        [pram setObject:voice_url forKey:@"voice_url"];
        [pram setObject:@(voice_size) forKey:@"voice_size"];
    }
    if (ruid>0) {
        [pram setObject:@(ruid) forKey:@"ruid"];
    }
    return pram;
}

/**
 *  点击报名获取相关信息接口
 *
 *  @return 点击报名获取相关信息接口包体
 */
+ (NSDictionary *)getApplyInfoByUid:(int)uid gid:(int)gid{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getApplyInfoByUid" forKey:@"action"];
    [pram setObject:@(uid) forKey:@"uid"];
    [pram setObject:@(gid) forKey:@"gid"];
    return pram;
}

/**
 *  搜索用户
 *
 *  @param uid     用户id
 *  @param page    页码
 *  @param rows    每页数量
 *  @param keyword 搜索关键词
 *
 *  @return
 */
+(NSDictionary *)searchMember:(int)uid page:(int)page rows:(int)rows keyword:(NSString *)keyword{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"searchAttentionList" forKey:@"action"];
    [pram setObject:@(uid) forKey:@"uid"];
    [pram setObject:@(page) forKey:@"page"];
    [pram setObject:@(rows) forKey:@"rows"];
    [pram setObject:keyword forKey:@"keyword"];
    return pram;
}

/**
 *  获取我参与的比赛主题
 *
 *  @param uid  用户id
 *  @param page 页码
 *  @param rows 每页数量
 *
 *  @return 我参与的比赛主题包体
 */
+(NSDictionary *)getMyGamesList:(int)uid page:(int)page rows:(int)rows{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getMyGamesList" forKey:@"action"];
    [pram setObject:@(uid) forKey:@"uid"];
    [pram setObject:@(page) forKey:@"page"];
    [pram setObject:@(rows) forKey:@"rows"];
    return pram;
}

/**
 *  获取城市信息
 *
 *  @return 获取城市信息包体
 */
+ (NSDictionary *)getCityInfo{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getCityInfo" forKey:@"action"];
    return pram;
}

/**
 *  获取地区信息
 *
 *  @return 获取地区信息包体
 */
+ (NSDictionary *)getAreaInfo:(int)cid{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getAreaInfo" forKey:@"action"];
    [pram setObject:@(cid) forKey:@"id"];
    return pram;
}

/**
 *  获取主题奖项配置列表接口
 *  @param  gid  主题id
 */
+ (NSDictionary *)getAwardLevel:(int)gId{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"getAwardconfig" forKey:@"action"];
    [pram setObject:@(gId) forKey:@"gid"];
    return pram;
}

/**
 *  举报
 *
 *  @param pid     作品id
 *  @param comment 举报内容
 *
 *  @return 举报包体
 */
+ (NSDictionary *)addreport:(NSString *)pid comment:(NSString *)comment{
    if (pid == nil) {
        pid = @"";
    }
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    [pram setObject:@"addreport" forKey:@"action"];
    [pram setObject:pid forKey:@"pid"];
    [pram setObject:comment forKey:@"content"];
    return pram;
}

/**
 * 获取相关主题列表接口
 *
 *  @param page 页码
 *  @param rows 每页数目
 *  @param gid  主题id
 *
 *  @return 获取相关主题列表接口
 */
+ (NSDictionary *)getadlist:(int)page row:(int)rows gid:(int)gid{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    
    [pram setObject:@"getadlist" forKey:@"action"];
    [pram setObject:@(page) forKey:@"page"];
    [pram setObject:@(rows) forKey:@"rows"];
    [pram setObject:@(gid) forKey:@"gid"];
    
    return pram;
}

/**
 *  休闲活动 按钮接口
 */
+ (NSDictionary *)PrivilegeCheckBox:(int)page rows:(int)rows datavalue:(int)datavalue{
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    
    [pram setObject:@(page) forKey:@"page"];
    [pram setObject:@(rows) forKey:@"rows"];
    [pram setObject:@(datavalue) forKey:@"datavalue"];
    
    return pram;
}
@end
