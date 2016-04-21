//
//  SaiBeanAward.h
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/21.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaiBeanAward : UIView

@property (nonatomic,strong) NSString *sId;
@property (nonatomic,strong) NSString *tId;                   //分类ID
@property (nonatomic,strong) NSString *gId;                   //比赛ID
@property (nonatomic,strong) NSString *uId;                   //用户ID
@property (nonatomic,strong) NSString *title;                 //作品描述
@property (nonatomic,strong) NSString *pic_desc;              //创作意图
@property (nonatomic,strong) NSString *g_title;                //主题标题
@property (nonatomic,assign) int       hotNum;                //热度/点赞数
@property (nonatomic,assign) int       commentNum;            //评论数
@property (nonatomic,strong) NSString *realname;              //姓名
@property (nonatomic,strong) NSString *gender;                //性别 1：男 2 女
@property (nonatomic,strong) NSString *birthday;              //出生年月日
@property (nonatomic,strong) NSString *age;                   //根据出生日期算年龄
@property (nonatomic,strong) NSString *addtime;               //报名时间
@property (nonatomic,strong) NSString *headImg;               //头像地址

@property (nonatomic,strong) NSString *attention;             //是否关注 0：未关注 1：已关注 2 ：自己的作品
@property (nonatomic,strong) NSString *applySubId;            //申请图片数据 图片od
@property (nonatomic,strong) NSString *applySubUrl;           //申请图片数据 图片地址
@property (nonatomic,strong) NSMutableArray  *commentsArr;    //评论内容

@property (nonatomic,assign) int      award_level;            //获奖等级   1：一等奖2：二等奖3：三等奖

@property (nonatomic,assign) int      is_favor;               //是否点赞字段    0 未登录 1 已赞过 2 未赞过

@property (nonatomic,strong) NSArray *applySubArr;            //申请图片数据

@property (nonatomic, assign) NSInteger game_status;          //比赛状态 1:进行中2：评审中3：审核通过4：奖项发布
@property (nonatomic,assign) BOOL       isShowMore;


+(id)parseInfoAward:(NSDictionary *)infoDic;

@end
