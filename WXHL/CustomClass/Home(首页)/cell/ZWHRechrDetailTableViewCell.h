//
//  ZWHRechrDetailTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHWorkModel.h"
#import "ZWHBalaeceModel.h"
#import "ZWHRechargeModel.h"

@interface ZWHRechrDetailTableViewCell : UITableViewCell


//0余额充值 1提货券充值 2余额 3工分 4提现
@property(nonatomic,copy)NSString *state;

@property(nonatomic,strong)UILabel *type;
@property(nonatomic,strong)UILabel *yue;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *money;

@property(nonatomic,strong)ZSBaseModel *model;


@end
