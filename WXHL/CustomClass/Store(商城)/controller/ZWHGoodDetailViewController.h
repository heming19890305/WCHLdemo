//
//  ZWHGoodDetailViewController.h
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"
#import "ZWHGoodsModel.h"

@interface ZWHGoodDetailViewController : BasicViewController

@property(nonatomic,strong)ZWHGoodsModel *model;

@property(nonatomic,copy)NSString *goodId;

//0：商品，1：窖酒，2：微超，3：个性定制
@property(nonatomic,copy)NSString *state;

@end
