//
//  CityModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/24.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"
#import "DistrictModel.h"

@interface CityModel : ZSBaseModel
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *pCode;
@end
