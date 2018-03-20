//
//  ZWHSetBankViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSetBankViewController.h"

#import "ZWHBangBankViewController.h"

@interface ZWHSetBankViewController ()

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *num;

@property(nonatomic,strong)UITextField *pas;

@end

@implementation ZWHSetBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAYBACKCOLOR;
    if ([UserManager cardNo].length>0) {
        [self getMyBankInfo];
    }else{
        [self noneBank];
    }
}

#pragma mark - 获得绑定银行卡信息
-(void)getMyBankInfo{
    [HttpHandler getBindBankCard:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            if (obj[@"data"]) {
                [UserManager sharedData].bankname = obj[@"data"][@"bank"];
                [UserManager sharedData].cardNo = obj[@"data"][@"cardNo"];
                [self haveBank];
            }
        }else{
            ShowErrorWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowErrorWithStatus(ErrorNet);
    }];
}

#pragma mark - 没有银行卡
-(void)noneBank{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(60));
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(setBankCard) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [view addSubview:btn];
    btn.sd_layout
    .leftEqualToView(view)
    .topEqualToView(view)
    .bottomEqualToView(view)
    .rightEqualToView(view);
    
    UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"jiahao")];
    [view addSubview:img];
    img.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(20))
    .widthEqualToHeight()
    .centerYEqualToView(view);
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab];
    lab.text = @"添加银行卡";
    lab.sd_layout
    .leftSpaceToView(img, WIDTH_TO(8))
    .centerYEqualToView(view)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(200));
    
    UIImageView *rig = [[UIImageView alloc]initWithImage:ImageNamed(@"right_t")];
    [view addSubview:rig];
    rig.sd_layout
    .rightSpaceToView(view, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(17.5))
    .widthEqualToHeight()
    .centerYEqualToView(view);

}

#pragma mark - 有银行卡
-(void)haveBank{
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:MAINCOLOR]];
    img.userInteractionEnabled = YES;
    [self.view addSubview:img];
    img.sd_layout
    .widthIs(WIDTH_TO(335))
    .heightIs(HEIGHT_TO(140))
    .topSpaceToView(self.view, HEIGHT_TO(20))
    .centerXEqualToView(self.view);
    
    _name = [[UILabel alloc]init];
    [_name textFont:20 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _name.text = @"";
    _name.text = [UserManager bankname];
    [img addSubview:_name];
    _name.sd_layout
    .leftSpaceToView(img, WIDTH_TO(15))
    .topSpaceToView(img, HEIGHT_TO(30))
    .rightSpaceToView(img, 0)
    .autoHeightRatio(0);
    
    _num = [[UILabel alloc]init];
    [_num textFont:25 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _num.text = @"";
    NSString *str = [UserManager cardNo];
    _num.text = [str stringByReplacingCharactersInRange:NSMakeRange(0, str.length - 4) withString:@"************"];
    [img addSubview:_num];
    _num.sd_layout
    .leftSpaceToView(img, WIDTH_TO(15))
    .topSpaceToView(_name, HEIGHT_TO(30))
    .rightSpaceToView(img, 0)
    .autoHeightRatio(0);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(dissectBank) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:MAINCOLOR forState:0];
    [btn setTitle:@"解绑" forState:0];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = MAINCOLOR.CGColor;
    btn.layer.borderWidth = 1;
    btn.backgroundColor = GRAYBACKCOLOR;
    [self.view addSubview:btn];
    btn.sd_layout
    .leftEqualToView(img)
    .rightEqualToView(img)
    .topSpaceToView(img, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(50));
}

#pragma mark - 解绑
-(void)dissectBank{
    UIAlertController *dissect = [UIAlertController alertControllerWithTitle:@"" message:@"支付密码" preferredStyle:UIAlertControllerStyleAlert];
    
    [dissect addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入支付密码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    UIAlertAction *xc = [UIAlertAction actionWithTitle:@"解绑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",[dissect.textFields lastObject].text);
        [HttpHandler getunBindBankCard:@{@"payPassword":[dissect.textFields lastObject].text,@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                ShowSuccessWithStatus(@"解绑成功");
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cardNo"];
                NOTIFY_POST(@"myinfodata");
                ONEPOP
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [dissect addAction:cancel];
    [dissect addAction:xc];
    
    [self presentViewController:dissect animated:YES completion:nil];
}


#pragma mark - 绑定银行卡
-(void)setBankCard{
    ZWHBangBankViewController *vc = [[ZWHBangBankViewController alloc]init];
    vc.title = @"银行卡";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
