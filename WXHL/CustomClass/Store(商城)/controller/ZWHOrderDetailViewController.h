//
//  ZWHOrderDetailViewController.h
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"
#import "ZWHOrderModel.h"

@interface ZWHOrderDetailViewController : BasicViewController

@property (nonatomic,assign) BOOL isAlipayfail;

@property(nonatomic,strong)ZWHOrderModel *model;

@property(nonatomic,strong)ZWHOrderModel *ordermodel;

@end
