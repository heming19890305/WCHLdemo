//
//  ZSCallManager.h
//  XGB
//
//  Created by ZS on 2017/8/21.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSCallManager : NSObject
+ (instancetype)sharedCall;
// ***** 电话号码 *****//
@property (nonatomic, copy) NSString *phoneNumber;

@end
