//
//  UserManager.h
//  DJ
//
//  Created by 赵升 on 2017/6/27.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWHMyModel.h"

@interface UserManager : NSObject

+ (instancetype)sharedData;

//个人信息
@property(nonatomic,strong)ZWHMyModel *mymodel;
//地区信息
@property(nonatomic,strong)NSArray *addressArray;

@property(nonatomic,strong)NSArray *dayArray;

@property(nonatomic,strong)NSArray *searchArr;

- (void)logOut;

// ***** 登录字典 *****//
@property (nonatomic, strong) NSDictionary *userDict;

// ***** token值 *****//
@property (nonatomic, strong) NSString *token;

// ***** 密码 *****//
@property (nonatomic, strong) NSString *password;

// ***** 账号 *****//
@property (nonatomic, strong) NSString *zhanghao;

// ***** 名字 *****//
@property (nonatomic, strong) NSString *bankname;

// ***** 名字 *****//
@property (nonatomic, strong) NSString *cardNo;



@property (nonatomic, strong) NSString *sumoney;

@property (nonatomic, strong) NSString *payway;




// ***** 图片服务器地址 *****//
@property(nonatomic,copy)NSString *fileSer;

-(NSMutableDictionary *)clearNullWith:(NSMutableDictionary *)dict;

-(void)cheakUpdate;

+(NSString *)dealWith:(NSArray *)array with:(NSString *)str;
+ (BOOL)checkTelNumber:(NSString *)telNumber;

+ (BOOL)checkPassword:(NSString *)telNumber;


+ (NSString *)fileSer;//图片服务器地址

+(NSString *)token;
+(NSString *)consumerNo;
+(NSString *)name;
+(NSString *)nickName;
+(NSString *)idCard;
+(NSString *)face;
+(NSString *)areaNo;
+(NSString *)phone;
+(NSString *)idStatus;
+(NSString *)account;
+(NSString *)password;
+(NSString *)zhanghao;
+(NSArray *)searchArr;
+(NSString *)bankname;
+(NSString *)cardNo;


+(NSString *)sumoney;
+(NSString *)payway;
+(NSString *)name;



@end
