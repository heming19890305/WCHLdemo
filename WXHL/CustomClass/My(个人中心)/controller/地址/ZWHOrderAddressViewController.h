//
//  ZWHOrderAddressViewController.h
//  WXHL
//
//  Created by Syrena on 2017/12/27.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"
#import "ZWHAddressModel.h"

typedef void(^returnaddress)(ZWHAddressModel *model);

@interface ZWHOrderAddressViewController : BasicViewController

@property(nonatomic,strong)returnaddress clicked;

@end
