//
//  HMScoreTopViewTableViewCell.h
//  WXHL
//
//  Created by tomorrow on 2018/3/15.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMScoreScrollView.h"

@interface HMScoreTopViewTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UIColor * initroColor;

@property (nonatomic, strong) HMScoreScrollView * scoreView;
@end
