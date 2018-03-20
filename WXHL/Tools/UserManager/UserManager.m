//
//  UserManager.m
//  DJ
//
//  Created by 赵升 on 2017/6/27.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

static id _instance;

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+(instancetype)sharedData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

-(void)setMymodel:(ZWHMyModel *)mymodel{
    _mymodel = mymodel;
}

+(NSString *)cardNo{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"cardNo"];
    if (a != NULL) {
        return a;
    }
    return @"";
}
-(void)setCardNo:(NSString *)cardNo{
    [[NSUserDefaults standardUserDefaults] setObject:cardNo forKey:@"cardNo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUserDict:(NSDictionary *)userDict{
    
    NSString *aliAccount = userDict[@"aliAccount"];
    NSString *account = userDict[@"account"];
    NSString *nickName = userDict[@"nickName"];
    NSString *areaNo = userDict[@"areaNo"];
    NSString *sex = userDict[@"sex"];
    NSString *bankname = userDict[@"bankname"];
    NSString *cardNo = userDict[@"cardNo"];
    NSString *consumerNo = userDict[@"consumerNo"];
    NSString *face = userDict[@"face"];
    NSString *phone = userDict[@"phone"];
    NSString *idCard = userDict[@"idCard"];
    NSString *name = userDict[@"name"];
    
    
    NSString *idStatus = userDict[@"idStatus"];
    
    if (name != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"name"];
    }
    
    if (bankname != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:idStatus forKey:@"bankname"];
    }
    
    if (cardNo != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:idStatus forKey:@"cardNo"];
    }
    
    if (idStatus != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:idStatus forKey:@"idStatus"];
    }
    
    if (phone != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    }
    
    if (aliAccount != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:aliAccount forKey:@"aliAccount"];
    }
    if (account != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"account"];
    }
    if (nickName != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:@"nickName"];
    }
    if (sex != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:sex forKey:@"sex"];
    }
    if (consumerNo != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:consumerNo forKey:@"consumerNo"];
    }
    if (face != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:face forKey:@"face"];
    }
    if (areaNo != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:areaNo forKey:@"areaNo"];
    }
    
    if (idCard != NULL) {
        [[NSUserDefaults standardUserDefaults] setObject:idCard forKey:@"idCard"];
    }
    
    

    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
    
        //设置别名
//    [JPUSHService setAlias:userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"%ld %@  %ld", iResCode, iAlias, seq );
//    } seq:1];
}

-(void)setSumoney:(NSString *)sumoney{
    [[NSUserDefaults standardUserDefaults] setObject:sumoney forKey:@"sumoney"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setPayway:(NSString *)payway{
    [[NSUserDefaults standardUserDefaults] setObject:payway forKey:@"payway"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setSearchArr:(NSArray *)searchArr{
    [[NSUserDefaults standardUserDefaults] setObject:searchArr forKey:@"searchArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setBankname:(NSString *)bankname{
    [[NSUserDefaults standardUserDefaults] setObject:bankname forKey:@"bankname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)name{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)bankname{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"bankname"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSArray *)searchArr{
    NSArray *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchArr"];
    return a;
}

+(NSString *)sumoney{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"sumoney"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)payway{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"payway"];
    if (a != NULL) {
        return a;
    }
    return @"";
}



-(void)setZhanghao:(NSString *)zhanghao{
    [[NSUserDefaults standardUserDefaults] setObject:zhanghao forKey:@"zhanghao"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setFileSer:(NSString *)fileSer{
    [[NSUserDefaults standardUserDefaults] setObject:fileSer forKey:@"file_server"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setToken:(NSString *)token{
    NSLog(@"%@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"userto"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)zhanghao{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"zhanghao"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)password{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)account{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)idStatus{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"idStatus"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)phone{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)token{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"userto"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)fileSer{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"file_server"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+ (NSString *)consumerNo{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"consumerNo"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)idCard{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"idCard"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)nickName{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)face{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"face"];
    if (a != NULL) {
        return a;
    }
    return @"";
}

+(NSString *)areaNo{
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"areaNo"];
    if (a != NULL) {
        return a;
    }
    return @"";
}


-(NSMutableDictionary *)clearNullWith:(NSMutableDictionary *)dict{
    NSArray * keys=[dict allKeys];
    NSMutableDictionary *dictD = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i<keys.count; i++) {
        NSLog(@"%@",[dict objectForKey:keys[i]]);
        NSString *str = [dict objectForKey:keys[i]];
        if ((NSNull *)str == [NSNull null]) {
            [dictD setValue:@"" forKey:keys[i]];
        }else{
            [dictD setValue:[dict objectForKey:keys[i]] forKey:keys[i]];
        }
    }
    return dictD;
}

+(NSString *)dealWith:(NSArray *)array with:(NSString *)str{
    if (array.count > 0) {
        NSString *restr = @"";
        for (NSString *oldstr in array) {
            restr = [NSString stringWithFormat:@"%@%@%@",restr,oldstr,str];
        }
        if (str.length>0) {
            return [restr substringWithRange:NSMakeRange(0, restr.length - str.length)];
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}

-(void)logOut{
    
    //删除别名
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"%ld, %@ %ld", iResCode, iAlias, seq);
//    } seq:1];
    [JPUSHService resetBadge];
    [JPUSHService setAlias:@"" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"%ld,%@,%ld",(long)iResCode,iAlias,(long)seq);
    } seq:0];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userto"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"idCard"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"areaNo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cardNo"];
    
    
}

#pragma mark - 检查更新
/*-(void)cheakUpdate{
    NSLog(@"%@",[self getcurrentVersion]);
    
    [HttpHandler getcheckUpdate:@{@"version":[self getcurrentVersion]} success:^(id obj) {
        if (ReturnValue == 1) {
            NSLog(@"%@",obj);
            if ([obj[@"checkUpdateVersion"] compare:[self getcurrentVersion]] > 0) {
                UIAlertController *switchAlertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最新版本为:%@",obj[@"checkUpdateVersion"] ] message:@"是否更新?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:obj[@"checkUpdateAddress"]]];
                    
                }];
                [switchAlertController addAction:sureAction];
                [switchAlertController addAction:cancelAction];
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                
                [window.rootViewController presentViewController:switchAlertController animated:YES completion:nil];
            }else{
                ShowSuccessWithStatus(@"当前版本为最新版");
            }
            
        }else{
            ShowErrorWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowErrorWithStatus(ErrorNet);
    }];
}*/

-(NSString *)getcurrentVersion{
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDict));
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}

+(BOOL)checkPassword:(NSString *)telNumber{
    if (telNumber.length >= 6 && telNumber.length <=16) {
        return YES;
    }
    return NO;
}



//手机号号
+ (BOOL)checkTelNumber:(NSString *)telNumber{
    //移动号段
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    //联通号段
    NSString *CU_NUM =  @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    //电信号段
    NSString *CT_NUM = @"^((173)|(133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:telNumber];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:telNumber];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:telNumber];
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    } else {
        
        return NO;
    }
    return NO;
}

@end
