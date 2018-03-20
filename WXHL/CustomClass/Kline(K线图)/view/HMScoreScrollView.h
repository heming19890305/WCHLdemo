//
//  HMScoreScrollView.h
//  WXHL
//
//  Created by tomorrow on 2018/3/14.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "scoreViewController.h"
@class ZWHMyWorkModel;
@interface HMScoreScrollView : UIScrollView
@property(nonatomic, strong) UIView * TopView;
@property(nonatomic, assign) float amount;
@property (nonatomic, strong) ZWHMyWorkModel * dataModel;
@end
