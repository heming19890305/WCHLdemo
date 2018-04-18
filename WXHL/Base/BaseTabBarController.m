//
//  BaseTabBarController.m
//  KPH
//
//  Created by 赵升 on 2017/5/24.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BasicViewController.h"
#import "ZWHLoginViewController.h"


#import "ZWHHomeViewController.h"
#import "ZWHShopCarViewController.h"
#import "ZWHKlineViewController.h"
#import "ZWHMyCenterViewController.h"
#import "scoreViewController.h"
#import "HMScoreViewController.h"




@interface BaseTabBarController ()<UITabBarControllerDelegate,UITabBarDelegate>


@end

@implementation BaseTabBarController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.tintColor  = [UIColor grayColor];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor  = [UIColor grayColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addEnterpriseChildVC];
    
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, SCREENWIDTH, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,ZWHCOLOR(@"eaeaea").CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setShadowImage:img];
    
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
}




- (void)addEnterpriseChildVC//企业
{
    [self addChildVC:[[ZWHHomeViewController alloc]init] name:@"首页" imageName:@"home_hui" selectedImageName:@"home_lan"];
    
    
    [self addChildVC:[[ZWHKlineViewController alloc]init] name:@"工分" imageName:@"kxian_hui" selectedImageName:@"kxian_lan"];
    
    
    [self addChildVC:[[ZWHShopCarViewController alloc]init] name:@"购物车" imageName:@"shop_hui" selectedImageName:@"shop_lan"];
    
    
    [self addChildVC:[[ZWHMyCenterViewController alloc]init] name:@"我的" imageName:@"me_hui" selectedImageName:@"me_lan"];
    
    
}
- (void)addChildVC:(UIViewController *)viewController name:(NSString *)name imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    viewController.tabBarItem.title = name;
    viewController.tabBarItem.image = ImageNamed(imageName);
    
    UIImage *noImage = ImageNamed(imageName);
    UIImage *imageSet = ImageNamed(selectedImageName);
    
    viewController.tabBarItem.image = [noImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [imageSet imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];

    BaseNavigationViewController *nav = [[ BaseNavigationViewController alloc]initWithRootViewController:viewController];
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(4, -2)];
    
    [self addChildViewController:nav];
    //[self.tabBar setTintColor:MAINCOLOR];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //self.todeselect = NO;
    /*|| [tabBarController.childViewControllers[2].childViewControllers[0] isKindOfClass:[ZWHShopCarViewController class]]*/
    //[tabBarController.childViewControllers[3]
    BaseNavigationViewController *vc = (BaseNavigationViewController *)viewController;
    NSLog(@"%@",tabBarController.childViewControllers);
    if ([vc.childViewControllers[0] isKindOfClass:[ZWHMyCenterViewController class]] || [vc.childViewControllers[0] isKindOfClass:[ZWHShopCarViewController class]] ) {
        NSLog(@"%@",[UserManager token]);
        if ([[UserManager token] length] == 0) {
            [self getLogin];
            return NO;
        }else{
            return YES;
        }
    }else
        return YES;
}

-(void)getLogin{
    ZWHLoginViewController *vc = [[ZWHLoginViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
