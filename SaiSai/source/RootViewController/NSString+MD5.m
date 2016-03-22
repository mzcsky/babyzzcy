//
//  NSString+MD5.m
//  SaleForIos
//
//  Created by feng on 15-1-31.
//
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

/**
 *  MD5加密
 *
 *  @param aString 需要加密的str
 *
 *  @return 加密好的string
 */
+(NSString*)getMD5String:(NSString*)aString
{
//    NSString *toStr = [NSString stringWithFormat:@"%@%@",aString,APP_REQUEST_SECRET];
    NSString *toStr = [NSString stringWithFormat:@"%@",aString];
    
    const char *cStr = [toStr UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    
    return [[[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]] substringWithRange:NSMakeRange(0,32)] lowercaseString];
    
}
@end
