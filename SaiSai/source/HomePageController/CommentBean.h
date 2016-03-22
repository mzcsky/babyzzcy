//
//  CommentBean.h
//  SaiSai
//
//  Created by Zhoufang on 15/8/31.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentBean : NSObject

@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *fromName;
@property (nonatomic,strong) NSString *ruId;
@property (nonatomic,strong) NSString *toName;
@property (nonatomic,strong) NSString *uId;
@property (nonatomic,strong) NSString *voiceUrl;
@property (nonatomic,strong) NSString *completeContent;

+(CommentBean *)parseInfo:(NSDictionary *)infoDic;
@end
