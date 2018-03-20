//
//  ZWHLogisticsViewController.h
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"
#import "ZWHGoodsModel.h"

@interface ZWHLogisticsViewController : BasicViewController

@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,strong)ZWHGoodsModel *goodsmodel;

@end
