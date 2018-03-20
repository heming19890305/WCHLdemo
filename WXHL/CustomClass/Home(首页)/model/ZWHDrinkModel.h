//
//  ZWHDrinkModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHDrinkModel : ZSBaseModel

/*couponNo (string): 封坛编号 ,
 createDate (string): 封坛日期 ,
 cycle (string): 窖藏周期 ,
 remark (string): 备注 ,
 type (string): 窖藏类型 ,
 url (string): 远程数字窖酒 ,
 weight (string): 窖藏重量*/

@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *cycle;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *weight;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *couponNo;

@end
