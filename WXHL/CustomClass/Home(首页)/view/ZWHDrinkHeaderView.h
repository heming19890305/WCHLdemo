//
//  ZWHDrinkHeaderView.h
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWHDrinkHeaderView : UIView

@property(nonatomic,strong)UIImageView *icon;

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UILabel *idcard;
@property(nonatomic,strong)UILabel *card;
@property(nonatomic,strong) NSString * cradID;

@property(nonatomic,strong)ZWHMyModel *model;

@end
