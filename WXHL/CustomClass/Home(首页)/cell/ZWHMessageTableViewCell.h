//
//  ZWHMessageTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHMessageModel.h"

@interface ZWHMessageTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *type;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *intro;
@property(nonatomic,strong)UILabel *time;
@property(nonatomic,strong)UIImageView *red;

@property(nonatomic,strong)ZWHMessageModel *model;

@end
