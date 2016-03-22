//
//  ShareView.h
//  SaiSai
//
//  Created by weige on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"

@interface ShareView : UIView<UITextFieldDelegate, UMSocialUIDelegate>{
    
    UIView      *_contentView;
    UIButton    *_cancleBtn;
    
    NSString *_shareMsg;
    NSString *_shareWeb;
    UIImage  *_shareImg;
    NSString *_shareMst;
    
    NSString *_pid;
    NSString *_gid;
    
    NSMutableArray *_typeArray;
    
    XTViewController *_contrller;
}

#pragma mark
#pragma mark ====== 初始化 ======
/**
 *  初始化单例
 *
 *  @return 分享页面单例
 */
+ (ShareView *)shareInfo;

/**
 *   释放单例
 */
+ (void)freeInfo;

#pragma mark
#pragma mark ====== 显示隐藏 ======
/**
 *  显示
 *
 *  @param animation 是否有动画
 */
- (void)showShare:(BOOL)animation;

/**
 *  隐藏
 *
 *  @param animation 是否有动画
 */
- (void)hiddenShare:(BOOL)animation;

/**
 *  设置 xtviewcontroller
 *
 *  @param ctrller
 */
-(void)setController:(XTViewController *)ctrller;

#pragma mark
#pragma mark ====== 设置 ======
/**
 *  设置主题id
 *
 *  @param pid 主题id
 */
- (void)setPid:(NSString *)pid;

/**
 *  设置作品id
 *
 *  @param gid 作品id
 */
- (void)setGid:(NSString *)gid;

/**
 *  设置分享文字
 *
 *  @param msg 文字
 */
- (void)setMsg:(NSString *)msg;
/**
 *  设置分享标题
 *
 *  @param mst 标题
 */
- (void)setMst:(NSString *)mst;
/**
 *  设置分享网站
 *
 *  @param web 网站
 */
- (void)setWeb:(NSString *)web;

/**
 *  设置分享图片
 *
 *  @param img 图片
 */
- (void)setImg:(UIImage *)img;


@end
