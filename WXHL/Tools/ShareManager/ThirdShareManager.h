//
//  ThirdShareManager.h
//  KPH
//
//  Created by 赵升 on 2017/7/25.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdShareManager : NSObject

+ (instancetype)shared;

- (void)sharePlatForm:(SSDKPlatformType)formType;

//
-(void)sharePlatForm:(SSDKPlatformType)formType WithTitle:(NSString *)title Images:(id)images url:(NSURL *)url content:(NSString *)content;

@end
