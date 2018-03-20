//
//  ZWHWalletModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/22.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHWalletModel : ZSBaseModel
/*cashRemain (number): 余额 ,
 consumerNo (string): 消费商号 ,
 coupon (number): 提货券额*/
@property(nonatomic,strong)NSString *cashRemain;
@property(nonatomic,strong)NSString *consumerNo;
@property(nonatomic,strong)NSString *coupon;

@end
