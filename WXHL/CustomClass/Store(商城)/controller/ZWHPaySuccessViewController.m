//
//  ZWHPaySuccessViewController.m
//  WXHL
//
//  Created by Syrena on 2017/12/12.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHPaySuccessViewController.h"
#import "ZWHMyOrderViewController.h"
#import "ZWHShopCarViewController.h"

@interface ZWHPaySuccessViewController ()

@end

@implementation ZWHPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单支付成功";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"dingdan_tijiao")];
    [self.view addSubview:img];
    img.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(50))
    .topSpaceToView(self.view, HEIGHT_TO(140))
    .widthIs(WIDTH_TO(65))
    .heightIs(HEIGHT_TO(70));
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab.text = @"支付方式:";
    [self.view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(img, WIDTH_TO(15))
    .topSpaceToView(self.view, HEIGHT_TO(160))
    .autoHeightRatio(0);
    
    [lab setSingleLineAutoResizeWithMaxWidth:200];
    [lab updateLayout];
    
    
    UILabel *pay = [[UILabel alloc]init];
    [pay textFont:17 textColor:[UIColor redColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    NSString *s = [UserManager payway];
    switch ([s integerValue]) {
        case 1:
            pay.text = @"支付宝";
            break;
        case 2:
            pay.text = @"余额";
            break;
        case 3:
            pay.text = @"提货券";
            break;
        default:
            break;
    }
    [self.view addSubview:pay];
    pay.sd_layout
    .leftSpaceToView(lab, WIDTH_TO(6))
    .centerYEqualToView(lab)
    .autoHeightRatio(0);
    
    

    
    UILabel *lab1 = [[UILabel alloc]init];
    [lab1 textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab1.text = @"订单金额:";
    [self.view addSubview:lab1];
    lab1.sd_layout
    .leftSpaceToView(img, WIDTH_TO(15))
    .topSpaceToView(lab, HEIGHT_TO(10))
    .autoHeightRatio(0);
    
    [lab1 setSingleLineAutoResizeWithMaxWidth:200];
    [lab1 updateLayout];
    
    UILabel *money = [[UILabel alloc]init];
    [money textFont:17 textColor:[UIColor redColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    money.text = [UserManager sumoney];
    [self.view addSubview:money];
    money.sd_layout
    .leftSpaceToView(lab1, WIDTH_TO(6))
    .centerYEqualToView(lab1)
    .autoHeightRatio(0);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(todingdan) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = MAINCOLOR;
    [btn setTitle:@"查看订单" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(20))
    .rightSpaceToView(self.view, WIDTH_TO(20))
    .bottomSpaceToView(self.view, HEIGHT_TO(30))
    .heightIs(HEIGHT_TO(50));
    
}

-(void)backClick:(UIButton *)sender {
    
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZWHShopCarViewController class]]) {
            [self.navigationController popToViewController:vc animated:true];
            break;
        }
        
    }
}

-(void)todingdan{
    ZWHMyOrderViewController *vc = [[ZWHMyOrderViewController alloc]init];
    vc.title = @"我的订单";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
