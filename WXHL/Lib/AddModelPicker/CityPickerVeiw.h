//
//  CityPickerVeiw.h
//  丢必得
//
//  Created by ZSMAC on 17/9/6.
//  Copyright © 2017年 zhangwenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvinceModel.h"
#import "DistrictModel.h"
#import "DistrictModel.h"

@interface CityPickerVeiw : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)UIView * bageView;
@property(nonatomic,copy) void(^CityBlock)(NSString *cityname,NSString *citycode);
@property(nonatomic,strong)NSString * showSelectedCityNameStr;
@property(nonatomic,strong)NSArray * dataArray;

-(void)show;
@end
