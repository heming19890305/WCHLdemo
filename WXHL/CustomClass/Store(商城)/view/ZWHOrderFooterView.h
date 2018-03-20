//
//  ZWHOrderFooterView.h
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHOrderModel.h"

@interface ZWHOrderFooterView : UIView

@property(nonatomic,strong)UIButton *leftBtn;

@property(nonatomic,strong)UIButton *centerBtn;

@property(nonatomic,strong)UIButton *rightBtn;

@property(nonatomic,strong)UILabel *sumMoney;

@property(nonatomic,strong)UILabel *freightMoney;

@property(nonatomic,strong)UILabel *payMoney;

@property(nonatomic,strong)ZWHOrderModel *model;

@end
