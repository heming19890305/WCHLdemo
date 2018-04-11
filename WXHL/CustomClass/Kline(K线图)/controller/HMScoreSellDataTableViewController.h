//
//  HMScoreSellDataTableViewController.h
//  WXHL
//
//  Created by tomorrow on 2018/4/8.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMScoreSellDataTableViewController : BasicViewController
//0 全部 1代付款 2待发货 3待收货 4待评价
@property(nonatomic,copy)NSString *state;
@end
