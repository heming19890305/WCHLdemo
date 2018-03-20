//
//  ZWHAddressTableViewCell.h
//  WLStore
//
//  Created by Syrena on 2017/10/31.
//  Copyright © 2017年 yuanSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHAddressModel.h"
@interface ZWHAddressTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *manL;
@property(nonatomic,strong)UILabel *phoneL;
@property(nonatomic,strong)UILabel *addressL;
@property(nonatomic,strong)UIImageView *rightimage;
@property(nonatomic,strong)UIImageView *bottomimage;

@property(nonatomic,strong)ZWHAddressModel *model;


-(void)showRightImage:(BOOL)bol;

@end
