//
//  HMScoreTableViewCell.h
//  WXHL
//
//  Created by tomorrow on 2018/4/10.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMScoreModel.h"

@protocol SellScoreBtnDelegate<NSObject>
- (void)sellScoreBtn:(HMScoreModel *)cell_model;
@end

@interface HMScoreTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel * createDateLabel;
@property (nonatomic, strong) UILabel * inputMoneyLabel;
@property (nonatomic, strong) UILabel * incomeMoneyLabel;

@property (nonatomic, strong) UILabel * issueDaysLabel;
@property (nonatomic, strong) UILabel * poolRealNumLabel;
@property (nonatomic, strong) UILabel * poolNumLabel;
@property (nonatomic, strong) UILabel * dayIssueWorkpointsLabel;
//全部高度
@property (nonatomic, assign) float cellHeight;
//背景高度
@property (nonatomic, assign) float viewHeight;
//分割线
@property (nonatomic, strong) UIView * diveLine;

@property (nonatomic, strong) UIButton * sellScore_Btn;

@property (nonatomic, strong) HMScoreModel * model;

@property (assign, nonatomic) id<SellScoreBtnDelegate>degegate;

@end
