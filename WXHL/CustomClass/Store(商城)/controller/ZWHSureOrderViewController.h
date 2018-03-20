//
//  ZWHSureOrderViewController.h
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"

#import "ZWHGoodsModel.h"
#import "ZWHNorGoodModel.h"
#import "ZWHGoodsModel.h"
@interface ZWHSureOrderViewController : BasicViewController

@property(nonatomic,strong)ZWHGoodsModel *model;
@property(nonatomic,strong)ZWHNorGoodModel *normodel;
@property(nonatomic,assign)NSInteger num;
@property(nonatomic,strong)NSArray *dataArray;


@end
