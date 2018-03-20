//
//  VersionControl.h
//  HaveToStudy
//
//  Created by 赵升 on 2017/4/27.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionControl : NSObject

+ (instancetype)sharedControl;

- (BOOL)isCurrentVersion;

@end
