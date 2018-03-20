//
//  ZWHMyWorkModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/20.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWHMyWorkModel : NSObject
/*scoreMarket (number): 工分余额 ,
 scoreNumber (number): 工分余额 ,
 scorePrice (number): 工分余额 ,
 userBalance (number): 余额*/
@property(nonatomic,copy)NSString *scoreMarket;
@property(nonatomic,copy)NSString *scoreNumber;
@property(nonatomic,copy)NSString *scorePrice;
@property(nonatomic,copy)NSString *userBalance;

@end
