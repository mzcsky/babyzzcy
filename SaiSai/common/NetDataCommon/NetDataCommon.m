//
//  NetDataCommon.m
//  V5Iphone
//
//  Created by zhu on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NetDataCommon.h"


@implementation NetDataCommon

+(id) stringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey
{
    if ([aDic isKindOfClass:[NSNull class]]) {
        return @"";
    }
    id value = [aDic objectForKey:aKey];
    
    if ([value isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    if(![value isKindOfClass:[NSString class]])
    {
        
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        }
        
        
        value = @"";
    }
    
    return value;
}

+(id) stringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey orKey:(NSString*)otherKey
{
    if ([aDic isKindOfClass:[NSNull class]]) {
        return @"";
    }
    id value = [aDic objectForKey:aKey];
    
    if (nil == value) {
        value = [NetDataCommon stringFromDic:aDic forKey:otherKey];
    }
    else
    {
        value = [NetDataCommon stringFromDic:aDic forKey:aKey];
    }
    
    return value;
}

+(NSArray*)arrayWithNetData:(NSArray*)arr
{
    if (arr!=nil && [arr isKindOfClass:[NSArray class]] && [arr count]>0) {
        
        NSMutableArray * tmpArr = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for (int i = 0; i < arr.count; i++) {
            
            NSDictionary * dir = [arr objectAtIndex:i];
            
            NSArray * key = [dir allKeys];
            
            NSMutableArray * object = [[NSMutableArray alloc] initWithCapacity:key.count];
            
            for (int j = 0; j< key.count; j++) {
                if ([[dir objectForKey:[key objectAtIndex:j]] isKindOfClass:[NSNull class]]) {
                    [object addObject:@""];
                }
                else
                {
                    [object addObject:[dir objectForKey:[key objectAtIndex:j]]];
                }
            }
            
            
            NSMutableDictionary * tmpDir = [[NSMutableDictionary alloc] initWithObjects:object forKeys:key];
            
            [tmpArr addObject:tmpDir];
            
        }

        return tmpArr;

    }else{
        
        return nil;

    }

    
}

@end
