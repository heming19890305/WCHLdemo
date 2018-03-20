//
//  ZWHDrinkTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHDrinkModel.h"

@interface ZWHDrinkTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UIImageView *right;

@property(nonatomic,strong)ZWHDrinkModel *model;


@end
