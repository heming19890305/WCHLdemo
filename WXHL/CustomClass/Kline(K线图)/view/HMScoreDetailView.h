//
//  HMScoreDetailView.h
//  WXHL
//
//  Created by tomorrow on 2018/4/16.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMScoreModel.h"
@class HMScoreDetailFrame;

@protocol SellScoreBtnDelegate<NSObject>
- (void)sellScoreBtn:(HMScoreModel *)cell_model;
@end

@interface HMScoreDetailView : UIView

@property (nonatomic, strong) HMScoreDetailFrame * scoreDetailFrame;

@property (nonatomic, weak) UILabel * createDateLabel;
@property (nonatomic, weak) UILabel * inputMoneyLabel;
@property (nonatomic, weak) UILabel * incomeMoneyLabel;

@property (nonatomic, weak) UILabel * issueDaysLabel;
@property (nonatomic, weak) UILabel * poolRealNumLabel;
@property (nonatomic, weak) UILabel * poolNumLabel;
@property (nonatomic, weak) UILabel * dayIssueWorkpointsLabel;

@property (assign, nonatomic) id<SellScoreBtnDelegate>degegate;
//分割线
@property (nonatomic, strong) UIView * diveLine;

@property (nonatomic, strong) UIButton * sellScore_Btn;


@property (nonatomic, strong) HMScoreModel * model;



@end
