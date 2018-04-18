//
//  HMScoreDetailFrame.h
//  WXHL
//
//  Created by tomorrow on 2018/4/16.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMScoreModel.h"

@interface HMScoreDetailFrame : NSObject

/**  自己的frame */
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) HMScoreModel * model;


@property (nonatomic, assign) CGRect createDateFrame;
@property (nonatomic, assign) CGRect inputMoneyFrame;
@property (nonatomic, assign) CGRect incomeMoneyFrame;

@property (nonatomic, assign) CGRect issueDaysFrame;
@property (nonatomic, assign) CGRect poolRealFrame;
@property (nonatomic, assign) CGRect poolNumFrame;
@property (nonatomic, assign) CGRect dayIssueWorkpointsFrame;

/**
 *  自己的高度
 */
@property (nonatomic, assign) CGFloat  cellHeight;

@end
