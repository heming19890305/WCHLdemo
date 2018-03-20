//
//  VersionControl.m
//  HaveToStudy
//
//  Created by 赵升 on 2017/4/27.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "VersionControl.h"

@interface VersionControl()<NSURLConnectionDelegate>
// ***** 当前版本 *****//
@property (nonatomic, copy) NSString *currentVersion;
// ***** 上线版本 *****//
@property (nonatomic, copy) NSString *storeVersion;
@end


@implementation VersionControl


static id _handle;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handle = [super allocWithZone:zone];
    });
    return _handle;
}

+ (instancetype)sharedControl
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handle = [[self alloc]init];
    });
    return _handle;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _handle;
}

- (BOOL)isCurrentVersion{
    
    NSString *url = @"https://itunes.apple.com/cn/lookup?id=1202735493";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 3;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data) {
        NSDictionary *resultDict = [data objectFromJSONData];
        NSArray *infoContent = [resultDict objectForKey:@"results"];
        if (infoContent.count != 0) {
            NSString *version = [[infoContent objectAtIndex:0]objectForKey:@"version"];
            NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            if ([currentVersion isEqualToString:version]) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}







@end
