//
//  ZWHTextTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHDrinkModel.h"

@interface ZWHTextTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *text;

@property(nonatomic,strong)ZWHDrinkModel *model;

@end
