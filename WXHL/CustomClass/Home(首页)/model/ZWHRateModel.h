//
//  ZWHRateModel.h
//  WXHL
//
//  Created by Syrena on 2017/12/1.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHRateModel : ZSBaseModel
/*cashCost (number): 最低收取的费用 ,
 cashMoney (number): 提现额度-用户余额 ,
 taxRatio (number): 提现税百分比*/

@property(nonatomic,copy)NSString *cashCost;
@property(nonatomic,copy)NSString *cashMoney;
@property(nonatomic,copy)NSString *taxRatio;

@end
