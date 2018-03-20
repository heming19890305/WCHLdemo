//
//  ZWHComsumModel.h
//  WXHL
//
//  Created by Syrena on 2017/12/1.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHComsumModel : ZSBaseModel
/*address (string): 收货地址 ,
 consumerNo (string): 消费商号 ,
 createDate (string): 创建时间 ,
 goodsName (Array[string]): 商品名称列表 ,
 id (string): 支付记录ID ,
 logisticsName (string): 物流名称 ,
 orderNo (string): 订单号 ,
 payMoney (number): 支付金额*/

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *consumerNo;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *logisticsName;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *payMoney;
@property(nonatomic,strong)NSArray *goodsName;

@end
