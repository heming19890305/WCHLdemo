//
//  ZSCallManager.m
//  XGB
//
//  Created by ZS on 2017/8/21.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "ZSCallManager.h"

@implementation ZSCallManager

static id _call;

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _call = [super allocWithZone:zone];
    });
    return _call;
}

+(instancetype)sharedCall
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _call = [[self alloc]init];
    });
    return _call;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _call;
}

-(void)setPhoneNumber:(NSString *)phoneNumber{
    _phoneNumber = phoneNumber;
    
    NSString *message = [NSString stringWithFormat:@"是否拨打电话%@？",_phoneNumber];
    UIAlertController *switchAlertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSString *telStr = [NSString stringWithFormat:@"tel://%@", _phoneNumber];
        NSURL *url = [NSURL URLWithString:telStr];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"号码不可用\n或您的备设不支持拨号功能" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];
    [switchAlertController addAction:sureAction];
    [switchAlertController addAction:cancelAction];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window.rootViewController presentViewController:switchAlertController animated:YES completion:nil];
    
}



@end
