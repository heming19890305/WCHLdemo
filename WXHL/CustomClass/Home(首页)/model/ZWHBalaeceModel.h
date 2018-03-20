//
//  ZWHBalaeceModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/22.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHBalaeceModel : ZSBaseModel
/*afterMoney (number): 余额 ,
 changeType (string): 变化类型 ,
 consumerNo (string): 消费商号 ,
 createDate (string): 支付明细创建时间 ,
 id (string): 余额明细ID ,
 money (number): 变化金额 ,
 orderNo (string): 交易订单号 ,
 paymentType (string): 收支类型*/

/*id:余额明细ID
 consumerNo:消费商号
 changeType：变化类型
 money：变化金额
 afterMoney ： 变化后余额
 paymentType ：收支类型
 orderNo：交易流水号（订单号）
 createDate ：交易时间
 changeTypeName ： 变化类型名称
 scoreNum ： 工分数量
 scorePrice ： 工分单价
 tradeTax ： 交易税
 endingMoney ： 到账金额
 status ： 提现状态（汉字）
 refundTime ： 退款时间
 operater ： 审计员
 bankName ： 到账银行
 bankCard ： 银行卡号
 source ： 提成源
 computeObject ： 计算对象
 rate ： 提成比例*/
@property(nonatomic,strong)NSString *bankName;
@property(nonatomic,strong)NSString *bankCard;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSString *computeObject;
@property(nonatomic,strong)NSString *rate;

@property(nonatomic,strong)NSString *scoreNum;
@property(nonatomic,strong)NSString *changeTypeName;
@property(nonatomic,strong)NSString *scorePrice;
@property(nonatomic,strong)NSString *tradeTax;
@property(nonatomic,strong)NSString *endingMoney;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *refundTime;
@property(nonatomic,strong)NSString *operater;
@property(nonatomic,strong)NSString *afterMoney;
@property(nonatomic,strong)NSString *changeType;
@property(nonatomic,strong)NSString *consumerNo;
@property(nonatomic,strong)NSString *createDate;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *orderNo;
@property(nonatomic,strong)NSString *paymentType;
@property(nonatomic,strong)NSString *content;
@end
