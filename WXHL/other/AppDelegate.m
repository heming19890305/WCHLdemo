//
//  AppDelegate.m
//  WXHL
//
//  Created by Syrena on 2017/11/6.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "ZWIntroductionViewController.h"
//#import <UMMobClick/MobClick.h>
#import "UMMobClick/MobClick.h"

//#import <UMMobClick/MobClick.h>
//#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
//#import <UMErrorCatch/UMErrorCatch.h>

@interface AppDelegate ()
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;
@end

@implementation AppDelegate

/*[JPUSHService resetBadge];
 [JPUSHService setAlias:@"" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
 NSLog(@"%ld,%@,%ld",(long)iResCode,iAlias,(long)seq);
 } seq:0];*/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    UMConfigInstance.appKey = @"5a322754b27b0a225300021f";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    //[UMConfigure initWithAppkey:@"5a322754b27b0a225300021f" channel:@"App Store"];
    //[UMErrorCatch initErrorCatch];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    [self registerShareSDK];
    //[self setUpJPush];
    /*极光推送*/
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    //JAppKey : 是你在极光推送申请下来的appKey Jchannel : 可以直接设置默认值即可 Publish channel
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:@"" apsForProduction:NO]; //如果是生产环境应该设置为YES
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[BaseTabBarController alloc]init]];
    [_window makeKeyAndVisible];
    
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"DYC"];
    if ([a integerValue]==1) {
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"DYC"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSArray *backgroundImageNames = @[@"welcome_01.jpg", @"welcome_02.jpg", @"welcome_03.jpg",@"welcome_04.jpg"];
        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:backgroundImageNames backgroundImageNames:backgroundImageNames];
        [self.window addSubview:self.introductionView.view];
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didSelectedEnter = ^() {
            weakSelf.introductionView = nil;
        };
    }
    
    return YES;
}


// NOTE: 9.0以后使用新API接口
#pragma mark - 支付宝回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            if ([resultDic[@"resultCode"] isEqualToString:@"6001"]) {
                //ShowSuccessWithStatus(@"取消成功");
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelOrderWayChat" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"qyCancel" object:nil];
            }else if ([resultDic[@"resultCode"] isEqualToString:@"4000"]) {
                //[SVProgressHUD showErrorWithStatus:@"订单支付失败"];
                ShowErrorWithStatus(@"订单支付失败");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"qyCancel" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelOrderWayChat" object:nil];
            }else if ([resultDic[@"resultCode"] isEqualToString:@"6002"]) {
                //[SVProgressHUD showErrorWithStatus:@"网络连接出错"];
                ShowErrorWithStatus(@"网络连接出错");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelOrderWayChat" object:nil];
            }if ([resultDic[@"resultCode"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccessAliPay" object:@"success"];
                //[SVProgressHUD showSuccessWithStatus:@"订单支付成功"];
                //ShowSuccessWithStatus(@"订单支付成功");
            }
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            // 解析 auth code
            NSString *result = resultDic[@"resultCode"];
            if ([resultDic[@"resultCode"] isEqualToString:@"6001"]) {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelOrderWayChat" object:nil];
            }else if ([resultDic[@"resultCode"] isEqualToString:@"4000"]) {
                [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
            }else if ([resultDic[@"resultCode"] isEqualToString:@"6002"]) {
                [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
            }if ([resultDic[@"resultCode"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccessAliPay" object:@"success"];
                [SVProgressHUD showSuccessWithStatus:@"订单支付成功"];
            }
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

- (void)registerShareSDK
{
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http:mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    /* 设置友盟appkey */
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType) {
                                 
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         
                                         [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [ShareSDKConnector connectQQ:[QQApiInterface class]
                                                    tencentOAuthClass:[TencentOAuth class]];
                                         break;
                                     default:
                                         break;
                                 }
                             }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                          
                          switch (platformType)
                          {
                                  
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:WeChatKey appSecret:WeChatSecrect];
                                  break;
                              case SSDKPlatformTypeQQ:
                                  [appInfo SSDKSetupQQByAppId:QQId
                                                       appKey:QQAppKey
                                                     authType:SSDKAuthTypeBoth];
                                  break;
                              default:
                                  break;
                          }
                      }];
}

- (void)setUpJPush{
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:nil appKey:JPushKey channel:@"APP STORE" apsForProduction:YES];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    //    if (application.applicationState == UIApplicationStateActive) {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"
    //                                                            message:alert
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"OK"
    //                                                  otherButtonTitles:nil];
    //        [alertView show];
    //    }
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    Dismiss;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}


@end
