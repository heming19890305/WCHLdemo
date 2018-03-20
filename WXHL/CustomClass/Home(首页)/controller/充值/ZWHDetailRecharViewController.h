//
//  ZWHDetailRecharViewController.h
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"

@interface ZWHDetailRecharViewController : BasicViewController

//0充值 1提现 2余额 3工分 4提货券
@property(nonatomic,copy)NSString *state;

//数据源
@property(nonatomic,strong)ZSBaseModel *model;

@end
