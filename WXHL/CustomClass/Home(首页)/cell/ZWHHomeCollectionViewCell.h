//
//  ZWHHomeCollectionViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHGoodsModel.h"

@interface ZWHHomeCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UILabel *money;
@property(nonatomic,strong)UILabel *intro;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIButton *btn;


@property(nonatomic,strong)ZWHGoodsModel *model;

@end
