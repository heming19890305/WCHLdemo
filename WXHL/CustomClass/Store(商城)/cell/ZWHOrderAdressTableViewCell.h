//
//  ZWHOrderAdressTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZWHOrderModel.h"
#import "ZWHAddressModel.h"

@interface ZWHOrderAdressTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *phone;
@property(nonatomic,strong)UILabel *address;

@property(nonatomic,strong)UIImageView *rigimg;

@property(nonatomic,strong)ZWHOrderModel *ordermodel;

@property(nonatomic,strong)ZWHAddressModel *addressmodel;

-(void)showright:(BOOL)bol;
@end
