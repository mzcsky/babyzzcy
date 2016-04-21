//
//  SaiBean.m
//  SaiSai
//
//  Created by Zhoufang on 15/8/25.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "SaiBean.h"
#import "CommentBean.h"

@implementation SaiBean

+(id)parseInfo:(NSDictionary *)infoDic{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return [[SaiBean alloc] init];
    }
    SaiBean *bean = [[SaiBean alloc] init];
    
    
    bean.sId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"id"]];
    
    bean.tId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"tid"]];
    bean.gId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"gid"]];
    bean.uId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"uid"]];
    bean.title = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"title"]];
    bean.g_title = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"g_title"]];
    bean.pic_desc = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"pic_desc"]];
    bean.hotNum = [[NetDataCommon stringFromDic:infoDic forKey:@"hot"] intValue];
    bean.commentNum = [[NetDataCommon stringFromDic:infoDic forKey:@"comment"] intValue];
    bean.realname = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"realname"]];
    bean.gender = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"gender"]];
    bean.birthday = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"birthday"]];
    bean.addtime = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"addtime"]];
    bean.headImg = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"img"]];
//    bean.headImg = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"bigPic_default.jpg"]];
    
    bean.attention = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"attention"]];
    bean.award_level = [[NetDataCommon stringFromDic:infoDic forKey:@"award_level"] intValue];
    bean.is_favor = [[NetDataCommon stringFromDic:infoDic forKey:@"is_favor"] intValue];
    bean.game_status = [[NetDataCommon stringFromDic:infoDic forKey:@"game_status"] integerValue];
    
    bean.applySubArr = [NetDataCommon arrayWithNetData:[infoDic objectForKey:@"apply_sub"]];
    if (bean.applySubArr && bean.applySubArr.count > 0) {
        bean.applySubId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:bean.applySubArr[0] forKey:@"id"]];
        bean.applySubUrl = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:bean.applySubArr[0] forKey:@"pic_url"]];
    }    
    
    NSArray *cArr = [NetDataCommon arrayWithNetData:[infoDic objectForKey:@"comments"]];
    bean.commentsArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < cArr.count; i++) {
        CommentBean *cB = [CommentBean parseInfo:cArr[i]];
        [bean.commentsArr addObject:cB];
    }
    
    if (bean.birthday && ![bean.birthday isEqualToString:@""]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSDate *birthdayDate = [formatter dateFromString:bean.birthday];
        
        NSDate *nowDate = [NSDate date];
        NSCalendar *cale = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [cale components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:birthdayDate toDate:nowDate options:0];
        
        int year = (int)[comps year];
        int month = (int)[comps month];

        bean.age = [NSString stringWithFormat:@"%d岁%d个月",year,month];
        
    }
    
    return bean;
}

@end
