//
//  ZWHBaseOrderListViewController.h
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"

@interface ZWHBaseOrderListViewController : BasicViewController


//0 全部 1代付款 2待发货 3待收货 4待评价
@property(nonatomic,copy)NSString *state;

@end
