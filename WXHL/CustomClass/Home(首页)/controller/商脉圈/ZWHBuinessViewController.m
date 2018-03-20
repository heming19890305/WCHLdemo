//
//  ZWHBuinessViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHBuinessViewController.h"
#import "ZWHAllViewController.h"
#import "ZWHMybuniessViewController.h"
#import "ZWHSearchBuniViewController.h"

#import "ProvinceModel.h"
#import "CityModel.h"

@interface ZWHBuinessViewController ()

@end

@implementation ZWHBuinessViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    [self addChildViewControllers];
    [self createRightNavButton];
}

-(void)creatView{
    /*UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"menu")  style:UIBarButtonItemStylePlain target:self action:@selector(showMore)];
    self.navigationItem.rightBarButtonItem = more;*/
    
}


- (void)addChildViewControllers {
    
    [self addAllChildViewController];
    
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *titleWidth = SCREEN_WIDTH/3;
        *selColor = MAINCOLOR;
        *norColor = ZWHCOLOR(@"6f6f6f");
        *titleFont = FontWithSize(16);
    }];
    
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor, BOOL *isUnderLineEqualTitleWidth) {
        
        *isUnderLineEqualTitleWidth = NO;
        *underLineColor = MAINCOLOR;
        *underLineH = 2;
    }];
}

- (void)addAllChildViewController {
    ZWHAllViewController *vc = [[ZWHAllViewController alloc]init];
    vc.title = @"全部商脉圈";
    [self addChildViewController:vc];
    
    ZWHMybuniessViewController *vc1 = [[ZWHMybuniessViewController alloc]init];
    vc1.title = @"我的商脉圈";
    [self addChildViewController:vc1];
    
    ZWHSearchBuniViewController *vc2 = [[ZWHSearchBuniViewController alloc]init];
    vc2.title = @"关系查询";
    [self addChildViewController:vc2];
}

@end
