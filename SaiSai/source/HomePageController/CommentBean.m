//
//  CommentBean.m
//  SaiSai
//
//  Created by Zhoufang on 15/8/31.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "CommentBean.h"

@implementation CommentBean

+(CommentBean *)parseInfo:(NSDictionary *)infoDic{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return [[CommentBean alloc] init];
    }
    CommentBean *bean = [[CommentBean alloc] init];
    bean.content = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"content"]];
    bean.fromName = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"fromname"]];
    bean.ruId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"ruid"]];
    bean.toName = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"toname"]];
    bean.uId = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"uid"]];
    bean.voiceUrl = [NSString stringWithFormat:@"%@",[NetDataCommon stringFromDic:infoDic forKey:@"voice_url"]];
    
    if (!bean.toName || [bean.toName isEqualToString:@""]) {
        bean.completeContent = [NSString stringWithFormat:@"%@:%@",bean.fromName,bean.content];
    }
    else{
        bean.completeContent = [NSString stringWithFormat:@"%@回复%@:%@",bean.fromName,bean.toName,bean.content];
    }
    return bean;
}

@end

