//
//  ZWHBalanceViewController.h
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"
#import "ZWHWalletModel.h"

@interface ZWHBalanceViewController : BasicViewController

@property(nonatomic,strong)ZWHWalletModel *model;

//1余额 2提货券
@property(nonatomic,copy)NSString *state;

@end
