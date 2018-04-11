//
//  HMScoreModel.h
//  WXHL
//
//  Created by tomorrow on 2018/3/21.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMScoreModel : NSObject

@property (nonatomic, strong) NSArray * dataArry;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * consumerNo;
@property (nonatomic, copy) NSString * delFlag;
/**分红标记*/
@property (nonatomic, assign) NSInteger dividendsSign;
@property (nonatomic, copy) NSString * createDate;
@property (nonatomic, copy) NSString * businessNo;
/**投入金额*/
@property (nonatomic, assign) double inputMoney;
@property (nonatomic, copy) NSString * statusTxt;
/**收益金额*/
@property (nonatomic, assign) double incomeMoney;
/**累计发放天数*/
@property (nonatomic, assign) double issueDays;
/**当前剩余工分个数*/
@property (nonatomic, assign) double poolRealNum;
/**进入池子的工分个数*/
@property (nonatomic, assign) double poolNum;
@property (nonatomic, copy) NSString * pageNo;
/**每日发放工分个数*/
@property (nonatomic, assign)double dayIssueWorkpoints;
@property (nonatomic, copy) NSString * status;

@end
