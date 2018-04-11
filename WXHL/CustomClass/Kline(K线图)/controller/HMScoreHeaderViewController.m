//
//  HMScoreHeaderViewController.m
//  WXHL
//
//  Created by tomorrow on 2018/4/8.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreHeaderViewController.h"

@interface HMScoreHeaderViewController ()
@property(nonatomic,strong)NSArray *array;
@end

@implementation HMScoreHeaderViewController

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
        HMScoreSellDataTableViewController *vc = [[HMScoreSellDataTableViewController alloc]init];
        vc.state = ZWHINTTOSTR(i);
        vc.title = _array[i];
        [self addChildViewController:vc];
    }
    
    
    
}

@end
