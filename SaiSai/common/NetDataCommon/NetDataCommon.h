//
//  NetDataCommon.h
//  V5Iphone
//
//  Created by zhu on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetDataCommon : NSObject {
    
}

+(id) stringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey;



+(NSArray*)arrayWithNetData:(NSArray*)arr;

+(id) stringFromDic:(NSDictionary*)aDic forKey:(NSString*)aKey orKey:(NSString*)otherKey;


@end
