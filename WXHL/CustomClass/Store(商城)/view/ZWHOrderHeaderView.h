//
//  ZWHOrderHeaderView.h
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHOrderModel.h"

@interface ZWHOrderHeaderView : UIView

@property(nonatomic,strong)UILabel *statename;

@property(nonatomic,strong)UILabel *time;

@property(nonatomic,strong)UIImageView *img;


@property(nonatomic,copy)NSString *state;


@property(nonatomic,strong)ZWHOrderModel *model;
@end
