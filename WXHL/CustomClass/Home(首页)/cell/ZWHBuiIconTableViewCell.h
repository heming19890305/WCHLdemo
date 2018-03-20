//
//  ZWHBuiIconTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHBuinessModel.h"

@interface ZWHBuiIconTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *name;

@property(nonatomic,strong)ZWHBuinessModel *model;
@property(nonatomic,strong)NSArray *textArray;

@end
