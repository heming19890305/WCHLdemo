//
//  ZWHMyModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/20.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWHMyModel : NSObject
/*"account": "string",
 "aliAccount": "string",
 "areaNo": "string",
 "birthDate": "string",
 "cardNo": "string",
 "consumerNo": "string",
 "face": "string",
 "grade": "string",
 "idCard": "string",
 "name": "string",
 "nickName": "string",
 "phone": "string",
 "sex": "string"*/
@property(nonatomic,copy)NSString *account;
@property(nonatomic,copy)NSString *aliAccount;
@property(nonatomic,copy)NSString *areaNo;
@property(nonatomic,copy)NSString *birthDate;
@property(nonatomic,copy)NSString *cardNo;
@property(nonatomic,copy)NSString *consumerNo;
@property(nonatomic,copy)NSString *face;
@property(nonatomic,copy)NSString *grade;
@property(nonatomic,copy)NSString *idCard;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *idStatus;

@end
