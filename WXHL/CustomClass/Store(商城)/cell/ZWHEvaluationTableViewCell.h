//
//  ZWHEvaluationTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHEvaModel.h"

@interface ZWHEvaluationTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *intro;
@property(nonatomic,strong)UIButton *showall;

@property(nonatomic,strong)ZWHEvaModel *model;

@end
