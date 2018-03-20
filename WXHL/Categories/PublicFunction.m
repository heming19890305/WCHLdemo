//
//  PublicFunction.m
//  Post
//
//  Created by cheng on 15/4/8.
//  Copyright (c) 2015年 cheng. All rights reserved.
//

#import "PublicFunction.h"

@implementation PublicFunction


+ (NSString *)md5:(NSString *)str {
        
    const char *cStr = [str UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [result appendFormat:@"%02x", digest[i]];

    return [result lowercaseString];
}
    



@end

