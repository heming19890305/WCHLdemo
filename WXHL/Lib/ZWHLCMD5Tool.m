//
//  ZWHLCMD5Tool.m
//  XGB
//
//  Created by Syrena on 2017/10/10.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "ZWHLCMD5Tool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZWHLCMD5Tool
+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
