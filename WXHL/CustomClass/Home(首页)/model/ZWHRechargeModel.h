//
//  ZWHRechargeModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/22.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHRechargeModel : ZSBaseModel
/*consumerNo (string): 消费商号 ,
 createDate (string): 创建时间 ,
 money (number): 充值额度 ,
 moneyType (string): 充值类型*/

/*
 afterMoney (number): 交易后余额 ,
 beforeMoney (number): 交易前余额 ,
 changeType (string): 变化类型 ,
 consumerNo (string): 消费商号 ,
 createDate (string): 创建时间 ,
 id (string): 提货券明细ID ,
 money (number): 变化券额*/

/*提货券充值*/
@property(nonatomic,strong)NSString *afterMoney;
@property(nonatomic,strong)NSString *beforeMoney;
@property(nonatomic,strong)NSString *changeType;
@property(nonatomic,strong)NSString *consumerNo;
@property(nonatomic,strong)NSString *createDate;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *money;

@property(nonatomic,strong)NSString *paymentType;
@property(nonatomic,strong)NSString *changeTypeName;


/*余额充值*/
//@property(nonatomic,strong)NSString *consumerNo;
//@property(nonatomic,strong)NSString *createDate;
//@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *moneyType;

/*cashDate (string): 提现时间 ,
 cashMoney (number): 提现额度 ,
 cashRemain (number): 余额*/
@property(nonatomic,strong)NSString *cashDate;
@property(nonatomic,strong)NSString *cashMoney;
@property(nonatomic,strong)NSString *cashRemain;

@end
