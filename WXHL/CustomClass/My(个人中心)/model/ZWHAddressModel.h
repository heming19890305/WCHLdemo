//
//  ZWHAddressModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/28.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHAddressModel : ZSBaseModel
/*address (string): 详细地址 ,
 defaultFlag (string): 是否默认地址 ,
 id (string): 主键 ,
 name (string): 收货人 ,
 phone (string): 手机号 ,
 postCode (string): 邮政编码 ,
 zone (string): 区域ID ,
 zoneName (string): 区域名称*/
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *defaultFlag;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *postCode;
@property(nonatomic,copy)NSString *zone;
@property(nonatomic,copy)NSString *zoneName;

@end
