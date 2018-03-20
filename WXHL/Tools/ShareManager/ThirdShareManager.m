//
//  ThirdShareManager.m
//  KPH
//
//  Created by 赵升 on 2017/7/25.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "ThirdShareManager.h"



@implementation ThirdShareManager

static id _instance;

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+(instancetype)shared
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

- (void)sharePlatForm:(SSDKPlatformType)formType{
    NSString *imageString = @"背景-拷贝.png";

    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageString //传入要分享的图片
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:formType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         
         NSLog(@"%ld", error.code);
         
     }];
}

-(void)sharePlatForm:(SSDKPlatformType)formType WithTitle:(NSString *)title Images:(id)images url:(NSURL *)url content:(NSString *)content{
    //创建分享参数
    
    NSData *imageData = UIImageJPEGRepresentation(images, 0.01);
    UIImage *newImage = [UIImage imageWithData:imageData];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:newImage
                                        url:url
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:formType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理..
         
         if (state == 1) {
             ShowSuccessWithStatus(@"分享成功");
             NOTIFY_POST(@"dismissShareViewNotify");
         }else if (state == 2) {
             ShowSuccessWithStatus(@"分享失败");
             NOTIFY_POST(@"dismissShareViewNotify");
         }else if (state == 3) {
             //ShowSuccessWithStatus(@"取消分享");
             Dismiss;
             NOTIFY_POST(@"dismissShareViewNotify");
         }
     }];
}



@end
