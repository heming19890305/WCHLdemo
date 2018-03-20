//
//  ZWHChoosePayWayView.h
//  WXHL
//
//  Created by Syrena on 2017/12/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^payWayClicked)(NSInteger payidx);

@interface ZWHChoosePayWayView : UIView

@property(nonatomic,strong)payWayClicked returnway;

@end
