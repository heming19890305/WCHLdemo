//
//  ZWHEditAddressViewController.h
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"
#import "ZWHAddressModel.h"

@interface ZWHEditAddressViewController : BasicViewController
@property(nonatomic,strong)ZWHAddressModel *model;

//0新建 1编辑;
@property(nonatomic,copy)NSString *state;

@end
