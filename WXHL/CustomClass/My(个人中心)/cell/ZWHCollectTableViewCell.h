//
//  ZWHCollectTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHCollectModel.h"

@interface ZWHCollectTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *selectB;
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *intro;
@property(nonatomic,strong)UILabel *newprice;
@property(nonatomic,strong)UILabel *oldprice;
@property(nonatomic,strong)UILabel *norL;

@property(nonatomic,assign)BOOL isedit;


@property(nonatomic,strong)ZWHCollectModel *model;
@end
