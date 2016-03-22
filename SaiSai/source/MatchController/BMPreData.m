//
//  BMPreData.m
//  SaiSai
//
//  Created by weige on 15/9/3.
//  Copyright (c) 2015年 NJNightDayTechnology. All rights reserved.
//

#import "BMPreData.h"

/*
 data =     {
 "games_info" =         {
 "games_type" =             (
 {
 id = 1;
 name = "\U4e2d\U56fd\U4eba\U7269\U753b";
 },
 {
 id = 2;
 name = "\U4e2d\U56fd\U5c71\U6c34\U753b";
 },
 {
 id = 4;
 name = "\U901f\U5199";
 }
 );
 id = 2;
 "is_code" = 1;
 "is_games_type_relative" = 1;
 "is_level" = 1;
 "is_org" = 1;
 "is_teacher" = 1;
 tid = 1;
 };
 "last_apply_info" =         (
 );
 };
 msg = "\U83b7\U53d6\U4fe1\U606f\U6210\U529f\Uff01";
 status = 1;
 */

@implementation BMPreData

+ (BMPreData *)analyseData:(NSDictionary *)dict{
    
    BMPreData *data = [[BMPreData alloc] init];
    
    NSDictionary *games_info = [dict objectForKey:@"games_info"];
    if (games_info != nil && [games_info isKindOfClass:[NSDictionary class]]) {
        data.flag       = [[NetDataCommon stringFromDic:games_info forKey:@"flag"] integerValue];
        data.mId        = [[NetDataCommon stringFromDic:games_info forKey:@"id"] integerValue];
        data.is_code    = [[NetDataCommon stringFromDic:games_info forKey:@"is_code"] integerValue];
        data.is_games_type_relative = [[NetDataCommon stringFromDic:games_info forKey:@"is_games_type_relative"] integerValue];
        data.is_level   = [[NetDataCommon stringFromDic:games_info forKey:@"is_level"] integerValue];
        data.is_org = [[NetDataCommon stringFromDic:games_info forKey:@"is_org"] integerValue];
        data.is_teacher = [[NetDataCommon stringFromDic:games_info forKey:@"is_teacher"] integerValue];
        data.tid        = [[NetDataCommon stringFromDic:games_info forKey:@"tid"] integerValue];
        data.is_img     = [[NetDataCommon stringFromDic:games_info forKey:@"is_img"] integerValue];
        data.is_upload     = [[NetDataCommon stringFromDic:games_info forKey:@"is_upload"] integerValue];
        data.is_single     = [[NetDataCommon stringFromDic:games_info forKey:@"is_single"] integerValue];
        
        NSArray *array  = [games_info objectForKey:@"games_type"];
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        NSMutableArray *nArray = [[NSMutableArray alloc] init];
        if (array != nil && [array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                GameTypeBean *gBean = [GameTypeBean analyseData:dict];
                [mArray addObject:gBean];
                [nArray addObject:gBean.name];
            }
        }
        data.games_type = mArray;
        data.games_type_name = nArray;
    }
    
    NSDictionary *laiDict = [dict objectForKey:@"last_apply_info"];
    if (laiDict != nil && [laiDict isKindOfClass:[NSDictionary class]]) {
        data.last_apply_info = [LastApplyInfoBean analyseData:laiDict];
    }
    
    return data;
}

@end
