//
//  SaiBeanAward.m
//  SaiSai
//
//  Created by 宝贝计画 on 16/4/21.
//  Copyright © 2016年 NJNightDayTechnology. All rights reserved.
//

#import "SaiBeanAward.h"
#import "CommentBean.h"
@implementation SaiBeanAward

+(id)parseInfoAward:(NSDictionary *)infoDic{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return [[SaiBeanAward alloc] init];
    }
    SaiBeanAward *Awardbean = [[SaiBeanAward alloc] init];
    
    
    Awardbean.sId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"id"]];
    
    Awardbean.tId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"tid"]];
    Awardbean.gId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"gid"]];
    Awardbean.uId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"uid"]];
    Awardbean.title = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"title"]];
    Awardbean.g_title = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"g_title"]];
    Awardbean.pic_desc = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"pic_desc"]];
    Awardbean.hotNum = [[NetDataCommon stringFromDic:infoDic forKey:@"hot"] intValue];
    Awardbean.commentNum = [[NetDataCommon stringFromDic:infoDic forKey:@"comment"] intValue];
    Awardbean.realname = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"realname"]];
    Awardbean.gender = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"gender"]];
    Awardbean.birthday = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"birthday"]];
    Awardbean.addtime = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"addtime"]];
    Awardbean.headImg = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"img"]];
    //    bean.headImg = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"bigPic_default.jpg"]];

    
    Awardbean.attention = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"attention"]];
    Awardbean.award_level = [[NetDataCommon stringFromDic:infoDic forKey:@"award_level"] intValue];
    Awardbean.is_favor = [[NetDataCommon stringFromDic:infoDic forKey:@"is_favor"] intValue];
    Awardbean.game_status = [[NetDataCommon stringFromDic:infoDic forKey:@"game_status"] integerValue];
    
    Awardbean.applySubArr = [NetDataCommon arrayWithNetData:[infoDic objectForKey:@"apply_sub"]];
    if (Awardbean.applySubArr && Awardbean.applySubArr.count > 0) {
        Awardbean.applySubId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:Awardbean.applySubArr[0] forKey:@"id"]];
        Awardbean.applySubUrl = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:Awardbean.applySubArr[0] forKey:@"pic_url"]];
    }
    
    NSArray *cArr = [NetDataCommon arrayWithNetData:[infoDic objectForKey:@"comments"]];
    Awardbean.commentsArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < cArr.count; i++) {
        CommentBean *cB = [CommentBean parseInfo:cArr[i]];
        [Awardbean.commentsArr addObject:cB];
    }
    
    if (Awardbean.birthday && ![Awardbean.birthday isEqualToString:@""]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        NSDate *birthdayDate = [formatter dateFromString:Awardbean.birthday];
        
        NSDate *nowDate = [NSDate date];
        NSCalendar *cale = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [cale components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:birthdayDate toDate:nowDate options:0];
        
        int year = (int)[comps year];
        int month = (int)[comps month];
        
        Awardbean.age = [NSString stringWithFormat:@"%d岁%d个月",year,month];
        
    }
    
    return Awardbean;
}


@end
