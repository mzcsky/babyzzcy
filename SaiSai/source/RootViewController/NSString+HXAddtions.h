//
//  NSString+HXAddtions.h
//  SaiSai
//
//  Created by Zhoufang on 15/9/9.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HXAddtions)

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;


@end
