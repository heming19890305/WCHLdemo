//
//  HMScoreViewController.h
//  WXHL
//
//  Created by tomorrow on 2018/3/15.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "BasicViewController.h"

@interface HMScoreViewController : BasicViewController
@property (nonatomic, strong) UILabel * gotScore;
@property (nonatomic, strong) UILabel * unGotScore;
@property (nonatomic, strong) UILabel * orderNum;
@property (nonatomic, strong) UILabel * orderAmount;
@property (nonatomic, strong) UILabel * boundsNum;
@property (nonatomic, strong) UILabel * boundsAmount;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,assign)NSInteger index;
@end
