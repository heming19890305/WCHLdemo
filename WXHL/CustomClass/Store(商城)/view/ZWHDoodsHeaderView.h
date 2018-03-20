//
//  ZWHDoodsHeaderView.h
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHGoodsModel.h"

@interface ZWHDoodsHeaderView : UIView

@property(nonatomic,strong)SDCycleScrollView *topScro;

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *newprice;
@property(nonatomic,strong)UILabel *oldprice;
@property(nonatomic,strong)UILabel *work;
@property(nonatomic,strong)UILabel *daynum;
@property(nonatomic,strong)UILabel *sumnum;
@property(nonatomic,strong)UILabel *freight;

@property(nonatomic,strong)ZWHGoodsModel *model;
@property(nonatomic,strong)ZWHGoodsModel *c2fmodel;

@end
