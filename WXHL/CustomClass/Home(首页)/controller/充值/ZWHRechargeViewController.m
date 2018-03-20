//
//  ZWHRechargeViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHRechargeViewController.h"
#import "ZWHBalanceViewController.h"


#import "ZWHWalletModel.h"

@interface ZWHRechargeViewController ()


@property(nonatomic,strong)UILabel *yue;

@property(nonatomic,strong)UILabel *tihuo;

@end

@implementation ZWHRechargeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
    //[self getData];
}


#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
            weakSelf.yue.text = model.cashRemain;
            weakSelf.tihuo.text = model.coupon;
        }else{
            ShowInfoWithStatus(ErrorMessage);
            ONEPOP
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
        ONEPOP
    }];
}

-(void)creatView{
    
    self.view.backgroundColor = ZWHCOLOR(@"f6f6f6");
    
    UIView *leftview = [[UIView alloc]init];
    leftview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftview];
    leftview.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, HEIGHT_TO(10))
    .widthIs(WIDTH_TO(186))
    .heightIs(HEIGHT_TO(150));
    
    UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"cz_yuwe")];
    [leftview addSubview:img];
    img.sd_layout
    .topSpaceToView(leftview, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(50))
    .widthEqualToHeight()
    .centerXEqualToView(leftview);
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    lab.text = @"余额";
    [leftview addSubview:lab];
    lab.sd_layout
    .topSpaceToView(img, HEIGHT_TO(5))
    .autoHeightRatio(0)
    .centerXEqualToView(leftview);
    [lab setSingleLineAutoResizeWithMaxWidth:200];
    [lab updateLayout];
    
    _yue = [[UILabel alloc]init];
    [_yue textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    _yue.text = _model.cashRemain;
    [leftview addSubview:_yue];
    _yue.sd_layout
    .topSpaceToView(lab, HEIGHT_TO(5))
    .autoHeightRatio(0)
    .centerXEqualToView(leftview);
    [_yue setSingleLineAutoResizeWithMaxWidth:200];
    [_yue updateLayout];
    
    
    
    UIView *rightview = [[UIView alloc]init];
    rightview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightview];
    rightview.sd_layout
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, HEIGHT_TO(10))
    .widthIs(WIDTH_TO(188))
    .heightIs(HEIGHT_TO(150));
    
    UIImageView *img1 = [[UIImageView alloc]initWithImage:ImageNamed(@"cz_tixian")];
    [rightview addSubview:img1];
    img1.sd_layout
    .topSpaceToView(rightview, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(50))
    .widthEqualToHeight()
    .centerXEqualToView(rightview);
    
    UILabel *lab1 = [[UILabel alloc]init];
    [lab1 textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    lab1.text = @"提货券";
    [rightview addSubview:lab1];
    lab1.sd_layout
    .topSpaceToView(img1, HEIGHT_TO(5))
    .autoHeightRatio(0)
    .centerXEqualToView(rightview);
    [lab1 setSingleLineAutoResizeWithMaxWidth:200];
    [lab1 updateLayout];
    
    _tihuo = [[UILabel alloc]init];
    [_tihuo textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    _tihuo.text = _model.coupon;
    [rightview addSubview:_tihuo];
    _tihuo.sd_layout
    .topSpaceToView(lab1, HEIGHT_TO(5))
    .autoHeightRatio(0)
    .centerXEqualToView(rightview);
    [_tihuo setSingleLineAutoResizeWithMaxWidth:200];
    [_tihuo updateLayout];
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.backgroundColor = [UIColor clearColor];
    leftbtn.tag = 1;
    [leftview addSubview:leftbtn];
    leftbtn.sd_layout
    .leftEqualToView(leftview)
    .topEqualToView(leftview)
    .rightEqualToView(leftview)
    .bottomEqualToView(leftview);
    [leftbtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.backgroundColor = [UIColor clearColor];
    rightbtn.tag = 2;
    [rightview addSubview:rightbtn];
    rightbtn.sd_layout
    .leftEqualToView(rightview)
    .topEqualToView(rightview)
    .rightEqualToView(rightview)
    .bottomEqualToView(rightview);
    [rightbtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClicked:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
        [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                NSLog(@"%@",obj);
                ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
                ZWHBalanceViewController *vc = [[ZWHBalanceViewController alloc]init];
                vc.state = ZWHINTTOSTR(sender.tag);
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    
}

@end
