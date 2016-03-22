//
//  OperationView.h
//  SaiSai
//
//  Created by Zhoufang on 15/8/26.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaiBean.h"
@interface OperationView : UIView<UITextFieldDelegate,UMSocialUIDelegate>

@property (nonatomic,assign) CGFloat  seperateWidth;

@property (nonatomic,strong) UIButton *commentBtn;    //评论
@property (nonatomic,strong) UILabel  *commentNumLab; //评论数
@property (nonatomic,strong) UIButton *zanBtn;        //点赞
@property (nonatomic,strong) UIImageView *zanVabg;   //点赞图片
@property (nonatomic,strong) UIButton *alertBtn;      //修改
@property (nonatomic,strong) UIButton *shareBtn;      //分享
@property (nonatomic,strong) UILabel  *hotNumLab;     //热度数

@property (nonatomic,strong) SaiBean  *saiBean;
@property (nonatomic,strong) XTViewController *contrller;

/**
 *  设置评论数
 */
-(void)setCommentValue:(NSString *)commentStr;

/**
 *  设置热度数
 */
-(void)setHotValue:(NSString *)hotStr;

/**
 *  设置是否点赞
 *
 *  @param favor  0 未登录 1 已赞过 2 未赞过
 */
- (void)setIsFavor:(int)favor;

@end
