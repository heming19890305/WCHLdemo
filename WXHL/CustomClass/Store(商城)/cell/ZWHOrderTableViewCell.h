//
//  ZWHOrderTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHGoodsModel.h"
#import "ZWHNorGoodModel.h"

@interface ZWHOrderTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *icon;

@property(nonatomic,strong)UILabel *name;

@property(nonatomic,strong)UILabel *intro;

@property(nonatomic,strong)UILabel *norL;

@property(nonatomic,strong)UILabel *money;

@property(nonatomic,strong)UILabel *oldprice;

@property(nonatomic,strong)UILabel *num;

@property(nonatomic,strong)ZWHGoodsModel *model;
@property(nonatomic,strong)ZWHNorGoodModel *normodel;

@property(nonatomic,strong)ZWHGoodsModel *ordermodel;

@end
