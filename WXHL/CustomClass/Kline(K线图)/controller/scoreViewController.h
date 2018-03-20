//
//  scoreViewController.h
//  WXHL
//
//  Created by tomorrow on 2018/3/9.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHMyWorkModel.h"
#import "HMScoreView.h"
//#import "HMScoreScrollView.h"


@interface scoreViewController : UIViewController
//已获得工分
@property (nonatomic, copy) NSString * gotScore;
//未获得工分
@property (nonatomic, strong) UILabel * unGotScore;
 //2.4订单笔数数据Label
@property (nonatomic, strong) UILabel * orderDataLabel;
//2.5订单金额数据Label
@property (nonatomic, strong) UILabel * orderAmountDataLabel;
 //3.4分成工分个数数据Label
@property (nonatomic, strong) UILabel * orderBoundsDataLabel;
 //3.5分成金额数据Label
@property (nonatomic, strong) UILabel * boundsDataLabel;

@property (nonatomic, strong) ZWHMyWorkModel * dataModel;
//@property (nonatomic, strong) HMScoreScrollView * headerView;
@property (nonatomic, strong) HMScoreView *headerView;

@end
