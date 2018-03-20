//
//  ZWHConsumeTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHComsumModel.h"

@interface ZWHConsumeTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *day;
@property(nonatomic,strong)UILabel *date;
@property(nonatomic,strong)UILabel *money;
@property(nonatomic,strong)UILabel *name;

@property(nonatomic,strong)ZWHComsumModel *model;

@end
