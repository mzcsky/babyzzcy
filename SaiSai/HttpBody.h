//
//  HttpBody.h
//  SaiSai
//
//  Created by weige on 15/8/15.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpBody : NSObject

/**
 *  获取验证码
 *
 *  @param phone 手机号码
 *
 *  @return
 */
+(NSDictionary *)getRandCode:(NSString *)phone;

/**
 *  注册请求包体
 *
 *  @param phone    电话
 *  @param nickname 昵称
 *  @param gender   <#gender description#>
 *  @param psw      密码
 *  @param openid   <#openid description#>
 *
 *  @return 注册请求包体
 */
+ (NSDictionary *)resisterBody:(NSString *)phone nickName:(NSString *)nickname gender:(int)gender psw:(NSString *)psw openid:(NSString *)openid;


/**
 *  登录包体
 *
 *  @param phone 电话
 *  @param psw   密码
 *
 *  @return 登录包体
 */
+ (NSDictionary *)loginBody:(NSString *)phone psw:(NSString *)psw;

/**
 *  第三方登录包体
 *
 *  @param openid 第三方登录openid
 *
 *  @return 第三方登录包体
 */
+ (NSDictionary *)unionLoginBody:(NSString *)openid nickName:(NSString *)nickName icon:(NSString *)icon;

/**
 *  修改密码包体
 *
 *  @param uid    用户id
 *  @param oldPsw 旧密码
 *  @param psw    新密码
 *
 *  @return 修改密码包体
 */
+ (NSDictionary *)changePswBody:(int)uid oldPsw:(NSString *)oldPsw psw:(NSString *)psw;

/**
 *  重置密码
 *
 *  @param phone 用户号码
 *  @param psw 密码
 *
 *  @return 重置密码包体
 */
+ (NSDictionary *)resetPswBody:(NSString *)phone psw:(NSString *)psw;

/**
 *  获取年龄分类列表
 *
 *  @return 年龄分类列表包体
 */
+ (NSDictionary *)ageTypeListBody;

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
 *  @return 参赛作品列表包体
 */
+ (NSDictionary *)applyListBody:(int)page rows:(int)rows fage:(int)fage eage:(int)eage uid:(int)uid isMy:(int)isMy gid:(int)gid isaward:(int)isaward awardconfigId:(int)awardId keyword:(NSString *)keyword;

/**
 *  获取参赛主题列表接口
 *
 *  @param page 页码
 *  @param rows 每页数量
 *
 *  @return 获取参赛主题列表接口包体
 */
+ (NSDictionary *)gameListBody:(int)page rows:(int)rows status:(int)status projectid:(int)proId;

/**
 *  点赞，取消点赞接口
 *
 *  @param uId    用户id
 *  @param pId    作品id
 *  @param status 点赞状态 1 点赞 2 取消点赞
 *
 *  @return
 */
+ (NSDictionary *)updateFavourWithUId:(int)uId pId:(int)pId status:(int)status;

/**
 *  获取评论列表
 *
 *  @param uid  用户id
 *  @param page 页码
 *  @param rows 行数
 *
 *  @return 获取评论列表包体
 */
+ (NSDictionary *)getCommentList:(int)uid page:(int)page rows:(int)rows;

/**
 *  获取我的关注列表
 *
 *  @param uId  用户id
 *  @param page 页码
 *  @param rows 每页数量
 *
 *  @return
 */
+ (NSDictionary *)getMyAttendWithUId:(int)uId page:(int)page rows:(int)rows;

/**
 *  获取我的粉丝列表
 *
 *  @param uId  用户id
 *  @param page 页码
 *  @param rows 每页数量
 *
 *  @return
 */
+ (NSDictionary *)getMyFansWithUId:(int)uId page:(int)page rows:(int)rows;

/**
 *  添加或者取消关注
 *
 *  @param uId    用户id
 *  @param bId    被关注人id
 *  @param status 1 关注  2取消关注
 *
 *  @return
 */
+(NSDictionary *)attendOrCancelAttendWithUId:(int)uId bId:(int)bId status:(int)status;

/**
 *  上传文件
 *
 *  @return 上传文件包体
 */
+ (NSDictionary *)addFiles;

/**
 *  更新个人信息
 *
 *  @return 更新个人信息包体
 */
+ (NSDictionary *)updateUserInfo:(int)uid icon:(NSString *)icon nickName:(NSString *)nickName gender:(int)gender;

/**
 *  评论
 *
 *  @return 评论包体
 */
+ (NSDictionary *)addComments:(int)uid ruid:(int)ruid pid:(int)pid original_uid:(int)original_uid content:(NSString *)content voice_url:(NSString *)voice_url voice_size:(int)voice_size;

/**
 *  点击报名获取相关信息接口
 *
 *  @return 点击报名获取相关信息接口包体
 */
+ (NSDictionary *)getApplyInfoByUid:(int)uid gid:(int)gid;

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
+(NSDictionary *)searchMember:(int)uid page:(int)page rows:(int)rows keyword:(NSString *)keyword;

/**
 *  获取我参与的比赛主题
 *
 *  @param uid  用户id
 *  @param page 页码
 *  @param rows 每页数量
 *
 *  @return 我参与的比赛主题包体
 */
+(NSDictionary *)getMyGamesList:(int)uid page:(int)page rows:(int)rows;

/**
 *  获取城市信息
 *
 *  @return 获取城市信息包体
 */
+ (NSDictionary *)getCityInfo;

/**
 *  获取地区信息
 *
 *  @return 获取地区信息包体
 */
+ (NSDictionary *)getAreaInfo:(int)cid;

/**
 *  获取主题奖项配置列表接口
 *  @param  gid  主题id
 */
+ (NSDictionary *)getAwardLevel:(int)gId;

/**
 *  举报
 *
 *  @param pid     作品id
 *  @param comment 举报内容
 *
 *  @return 举报包体
 */
+ (NSDictionary *)addreport:(NSString *)pid comment:(NSString *)comment;

/**
 * 获取相关主题列表接口
 *
 *  @param page 页码
 *  @param rows 每页数目
 *  @param gid  主题id
 *
 *  @return 获取相关主题列表接口
 */
+ (NSDictionary *)getadlist:(int)page row:(int)rows gid:(int)gid;
+ (NSDictionary *)applyListBody:(int)page rows:(int)rows fage:(int)fage eage:(int)eage uid:(int)uid isMy:(int)isMy gid:(int)gid isaward:(int)isaward  keyword:(NSString *)keyword;
@end
