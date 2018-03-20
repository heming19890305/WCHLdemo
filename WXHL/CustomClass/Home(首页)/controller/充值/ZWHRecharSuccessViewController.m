//
//  ZWHRecharSuccessViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHRecharSuccessViewController.h"

@interface ZWHRecharSuccessViewController ()

@end

@implementation ZWHRecharSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
}

-(void)creatView{
    UIImageView *img = [[UIImageView alloc]init];
    img.image = ImageNamed(@"cz_dui");
    [self.view addSubview:img];
    img.sd_layout
    .topSpaceToView(self.view, HEIGHT_TO(84))
    .centerXEqualToView(self.view)
    .heightIs(HEIGHT_TO(60))
    .widthEqualToHeight();
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"充值成功";
    [lab textFont:18 textColor:MAINCOLOR backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lab];
    lab.sd_layout
    .topSpaceToView(img, WIDTH_TO(8))
    .centerXEqualToView(self.view)
    .autoHeightRatio(0)
    .widthIs(200);
    
    UILabel *money = [[UILabel alloc]init];
    money.text = @"20000.00";
    [money textFont:60 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:money];
    money.sd_layout
    .topSpaceToView(lab, WIDTH_TO(8))
    .centerXEqualToView(self.view)
    .autoHeightRatio(0)
    .widthIs(SCREENWIDTH);
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"完成" forState:0];
    [back setTitleColor:MAINCOLOR forState:0];
    [back addTarget:self action:@selector(backdismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    back.sd_layout
    .rightSpaceToView(self.view, WIDTH_TO(15))
    .topSpaceToView(self.view, HEIGHT_TO(20))
    .heightIs(40)
    .widthIs(60);
    
    back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

-(void)backdismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
