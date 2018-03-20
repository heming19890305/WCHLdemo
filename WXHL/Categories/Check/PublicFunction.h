//
//  PublicFunction.h
//  Post
//
//  Created by cheng on 15/4/8.
//  Copyright (c) 2015年 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface PublicFunction : NSObject

+(NSString *) md5: (NSString *) inPutText ;

@end
