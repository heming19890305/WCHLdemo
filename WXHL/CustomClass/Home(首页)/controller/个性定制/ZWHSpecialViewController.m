//
//  ZWHSpecialViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSpecialViewController.h"
#import "CityPickerVeiw.h"

@interface ZWHSpecialViewController ()

@end

@implementation ZWHSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.frame = CGRectMake(0, 2, SCREEN_WIDTH, SCREEN_HEIGHT - 66 - HEIGHT_TO(150));
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 4;//阴影半径，默认3
    
    [self.view addSubview:view];
    view.sd_layout
    .widthIs(SCREENWIDTH)
    .centerXEqualToView(view)
    .bottomSpaceToView(self.view, 0)
    .heightIs(HEIGHT_TO(150));
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"满意您的需求定制 是我们的服务宗旨！";
    [lab textFont:14 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(view, WIDTH_TO(25))
    .rightSpaceToView(view, WIDTH_TO(25))
    .topSpaceToView(view, HEIGHT_TO(30))
    .autoHeightRatio(0);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = MAINCOLOR;
    [btn setTitle:@"立即定制酒" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(getSpecialClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(view, WIDTH_TO(20))
    .rightSpaceToView(view, WIDTH_TO(20))
    .topSpaceToView(lab, HEIGHT_TO(30))
    .heightIs(HEIGHT_TO(50));
}

#pragma mark - 定制
-(void)getSpecialClicked:(UIButton *)sender{
    [HttpHandler getLocation:@{} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            [ProvinceModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"list":@"CityModel"};
            }];
            [CityModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"list":@"DistrictModel"};
            }];
            [UserManager sharedData].addressArray = [ProvinceModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            CityPickerVeiw * cityView = [[CityPickerVeiw alloc] init];
            [cityView show];
            [cityView setCityBlock:^(NSString *cityname, NSString *citycode) {
                NSLog(@"%@----%@",cityname,citycode);
            }];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
}

@end
