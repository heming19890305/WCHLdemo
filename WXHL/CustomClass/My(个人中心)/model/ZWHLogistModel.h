//
//  ZWHLogistModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHLogistModel : ZSBaseModel
/*list (Array[物流详细信息], optional),
 name (string): 物流公司名称 ,
 postNo (string): 物流单号 ,
 status (string): 物流状态*/
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *postNo;
@property(nonatomic,copy)NSString *status;

@property(nonatomic,strong)NSArray *list;

@end
