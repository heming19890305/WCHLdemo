//
//  ZWHWorkModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/22.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHWorkModel : ZSBaseModel
/*changeNum (number): 变动数量 ,
 changeType (string): 变化类型 ,
 consumerNo (string): 消费商号 ,
 createDate (string): 创建时间 ,
 id (string): 工分明细ID ,
 newScore (number): 变动后工分数量 ,
 oldScoreNum (number): 变动前工分数量 ,
 unitPrice (number): 工分单价*/

@property(nonatomic,copy)NSString *id;

@property(nonatomic,copy)NSString *tradeNo;
@property(nonatomic,copy)NSString *changeNum;
@property(nonatomic,copy)NSString *changeType;
@property(nonatomic,copy)NSString *consumerNo;
@property(nonatomic,copy)NSString *createDate;


@property(nonatomic,copy)NSString *sconew;

@property(nonatomic,copy)NSString *oldScoreNum;
@property(nonatomic,copy)NSString *unitPrice;
@property(nonatomic,copy)NSString *changeTypeName;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *paymentType;


@end
