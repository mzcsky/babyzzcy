//
//  NSString+MD5.h
//  SaleForIos
//
//  Created by feng on 15-1-31.
//
//

#import <Foundation/Foundation.h>

static NSString *APP_REQUEST_SECRET = @"dsf4&h3dfg&sy8&e7dwt";

@interface NSString (MD5)

+(NSString*)getMD5String:(NSString*)aString;

@end
