//
//  ZWHMyOrderViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHMyOrderViewController.h"

@interface ZWHMyOrderViewController ()

@property(nonatomic,strong)NSArray *array;

@end

@implementation ZWHMyOrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = @[@"全部",@"待付款",@"待收货",@"已完成"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    [self addChildViewControllers];
    [self createRightNavButton];
    self.selectIndex = _toidx;
}

-(void)creatView{
    /*UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"menu")  style:UIBarButtonItemStylePlain target:self action:@selector(showMore)];
     self.navigationItem.rightBarButtonItem = more;*/
    
}


- (void)addChildViewControllers {
    
    [self addAllChildViewController];
    
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *titleWidth = SCREEN_WIDTH/_array.count;
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
    
    for (NSInteger i=0; i<_array.count; i++) {
        ZWHBaseOrderListViewController *vc = [[ZWHBaseOrderListViewController alloc]init];
        vc.state = ZWHINTTOSTR(i);
        vc.title = _array[i];
        [self addChildViewController:vc];
    }
    
    
    
}


@end
