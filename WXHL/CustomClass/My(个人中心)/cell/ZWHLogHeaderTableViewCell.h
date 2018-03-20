//
//  ZWHLogHeaderTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHLogistModel.h"
#import "ZWHGoodsModel.h"

@interface ZWHLogHeaderTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UILabel *stateL;
@property(nonatomic,strong)UILabel *from;
@property(nonatomic,strong)UILabel *number;


@property(nonatomic,strong)UILabel *numL;

@property(nonatomic,strong)ZWHLogistModel *model;
@property(nonatomic,strong)ZWHGoodsModel *goodsmodel;

@end
