//
//  ZWHOrderModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHOrderModel : ZSBaseModel
/*goodsList (Array[商品信息]): 商品信息 ,
 id (string): 数据ID ,
 logisticsName (string): 物流公司名称 ,
 orderNo (string): 订单号 ,
 postMoney (number): 邮费 ,
 status (integer): 状态 ,
 totalMoney (number): 总金额 ,
 totalScore (number): 总工分*/

@property(nonatomic,strong)NSArray *goodsList;

@property(nonatomic,copy)NSString *tabName;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *logisticsName;
@property(nonatomic,copy)NSString *totalMoney;
@property(nonatomic,copy)NSString *totalScore;
@property(nonatomic,copy)NSString *postMoney;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *logisticstype;

@property(nonatomic,strong)NSArray *goods;

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *contacts;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *goodsMoney;
@property(nonatomic,copy)NSString *payWay;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *scoreMoney;
@property(nonatomic,copy)NSString *scoreNum;
@property(nonatomic,copy)NSString *scorePrice;
@property(nonatomic,copy)NSString *sendWay;
@property(nonatomic,copy)NSString *statusStr;

/*address (string): 收货地址 ,
 contacts (string): 联系人 ,
 createTime (string): 下单时间 ,
 goods (Array[商品信息], optional),
 goodsMoney (number): 商品总额 ,
 id (string): 订单数据ID ,
 orderNo (string): 订单编号 ,
 payWay (string): 支付方式 ,
 phone (string): 联系电话 ,
 postMoney (number): 运费 ,
 scoreMoney (number): 工分市值 ,
 scoreNum (number): 工分个数 ,
 scorePrice (number): 工分单价 ,
 sendWay (string): 配送方式 ,
 status (integer): 订单状态 ,
 statusStr (string): 订单状态名称 ,
 totalMoney (number): 实付款*/

@end
