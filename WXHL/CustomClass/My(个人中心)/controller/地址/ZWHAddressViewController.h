//
//  ZWHAddressViewController.h
//  WLStore
//
//  Created by Syrena on 2017/10/31.
//  Copyright © 2017年 yuanSheng. All rights reserved.
//

#import "BasicViewController.h"
#import "ZWHAddressModel.h"

typedef void(^returnaddress)(ZWHAddressModel *model);


@protocol ZWHAddressViewControllerDelegate<NSObject>


@end

@interface ZWHAddressViewController : BasicViewController

@property(nonatomic,weak)id<ZWHAddressViewControllerDelegate>delegate;

@property(nonatomic,strong)returnaddress clicked;

@end
