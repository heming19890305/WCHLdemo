//
//  ZWHRegisterViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHRegisterViewController.h"

@interface ZWHRegisterViewController ()
{
    /// 验证码获取倒计时定时器
    NSTimer *_codeTimer;
    /// 验证码倒计时时间
    NSUInteger _codeTime;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UITextField *phone;
@property(nonatomic,strong)UITextField *password;
@property(nonatomic,strong)UITextField *repirepas;
@property(nonatomic,strong)UITextField *codeF;
@property(nonatomic,strong)UIButton *codeB;
@property(nonatomic,strong)UIButton *agreeB;
@property (nonatomic, strong) UIButton *confirmB;

@end

@implementation ZWHRegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //去掉透明后导航栏下边的黑边
    //[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    [self creatView];
}


-(void)creatView{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(backToLogin)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    [self.view addSubview:self.tableView];
}


-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(700))];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
        [_headerView addSubview:img];
        img.sd_layout
        .topSpaceToView(_headerView, HEIGHT_TO(30))
        .heightIs(HEIGHT_TO(110))
        .widthIs(WIDTH_TO(100))
        .centerXEqualToView(_headerView);
        
        UILabel *number = [[UILabel alloc]init];
        number.text = @"手机号";
        [number textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [_headerView addSubview:number];
        number.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .topSpaceToView(img, HEIGHT_TO(40))
        .autoHeightRatio(0);
        [number setSingleLineAutoResizeWithMaxWidth:150];
        [number updateLayout];
        
        _phone = [[UITextField alloc]init];
        _phone.textColor = ZWHCOLOR(@"646363");
        _phone.clearButtonMode = UITextFieldViewModeAlways;
        _phone.font = FontWithSize(17);
        _phone.keyboardType = UIKeyboardTypeNumberPad;
        [_headerView addSubview:_phone];
        _phone.sd_layout
        .leftSpaceToView(number, WIDTH_TO(20))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .centerYEqualToView(number)
        .heightIs(HEIGHT_TO(25));
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LINECOLOR;
        [_headerView addSubview:line];
        line.sd_layout
        .leftEqualToView(number)
        .rightEqualToView(_phone)
        .heightIs(1)
        .topSpaceToView(number, HEIGHT_TO(20));
        
        UILabel *pas = [[UILabel alloc]init];
        pas.text = @"密码";
        [pas textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [_headerView addSubview:pas];
        pas.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .topSpaceToView(line, HEIGHT_TO(24))
        .autoHeightRatio(0);
        [pas setSingleLineAutoResizeWithMaxWidth:150];
        [pas updateLayout];
        
        _password = [[UITextField alloc]init];
        _password.textColor = ZWHCOLOR(@"646363");
        _password.keyboardType = UIKeyboardTypeASCIICapable;
        _password.secureTextEntry = YES;
        _password.font = FontWithSize(17);
        [_headerView addSubview:_password];
        _password.sd_layout
        .leftSpaceToView(pas, WIDTH_TO(20))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .centerYEqualToView(pas)
        .heightIs(HEIGHT_TO(25));
        
        
        UIButton *show = [UIButton buttonWithType:UIButtonTypeCustom];
        [show setImage:ImageNamed(@"mima_yc") forState:0];
        [show addTarget:self action:@selector(showpassClicked:) forControlEvents:UIControlEventTouchUpInside];
        show.selected = YES;
        show.tag = 10;
        [_password addSubview:show];
        show.sd_layout
        .centerYEqualToView(_password)
        .heightIs(HEIGHT_TO(40))
        .widthIs(WIDTH_TO(32))
        .rightSpaceToView(_password, WIDTH_TO(8));
        
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = LINECOLOR;
        [_headerView addSubview:line1];
        line1.sd_layout
        .leftEqualToView(pas)
        .rightEqualToView(_password)
        .heightIs(1)
        .topSpaceToView(pas, HEIGHT_TO(20));
        
        UILabel *repas = [[UILabel alloc]init];
        repas.text = @"确认密码";
        [repas textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [_headerView addSubview:repas];
        repas.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .topSpaceToView(line1, HEIGHT_TO(24))
        .autoHeightRatio(0);
        [repas setSingleLineAutoResizeWithMaxWidth:150];
        [repas updateLayout];
        
        _repirepas = [[UITextField alloc]init];
        _repirepas.textColor = ZWHCOLOR(@"646363");
        _repirepas.keyboardType = UIKeyboardTypeASCIICapable;
        _repirepas.secureTextEntry = YES;
        _repirepas.font = FontWithSize(17);
        [_headerView addSubview:_repirepas];
        _repirepas.sd_layout
        .leftSpaceToView(repas, WIDTH_TO(20))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .centerYEqualToView(repas)
        .heightIs(HEIGHT_TO(25));
        
        
        UIButton *show1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [show1 setImage:ImageNamed(@"mima_yc") forState:0];
        [show1 addTarget:self action:@selector(showpassClicked:) forControlEvents:UIControlEventTouchUpInside];
        show1.selected = YES;
        show1.tag = 20;
        [_repirepas addSubview:show1];
        show1.sd_layout
        .centerYEqualToView(_repirepas)
        .heightIs(HEIGHT_TO(40))
        .widthIs(WIDTH_TO(32))
        .rightSpaceToView(_repirepas, WIDTH_TO(8));
        
        
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = LINECOLOR;
        [_headerView addSubview:line2];
        line2.sd_layout
        .leftEqualToView(repas)
        .rightEqualToView(_repirepas)
        .heightIs(1)
        .topSpaceToView(repas, HEIGHT_TO(20));
        
        
        UILabel *code = [[UILabel alloc]init];
        code.text = @"验证码";
        [code textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [_headerView addSubview:code];
        code.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .topSpaceToView(line2, HEIGHT_TO(24))
        .autoHeightRatio(0);
        [code setSingleLineAutoResizeWithMaxWidth:150];
        [code updateLayout];
        
        _codeF = [[UITextField alloc]init];
        _codeF.textColor = ZWHCOLOR(@"646363");
        _codeF.keyboardType = UIKeyboardTypeNumberPad;
        _codeF.font = FontWithSize(17);
        [_headerView addSubview:_codeF];
        _codeF.sd_layout
        .leftSpaceToView(code, WIDTH_TO(20))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .centerYEqualToView(code)
        .heightIs(HEIGHT_TO(25));
        
        
        _codeB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeB addTarget:self action:@selector(sendCodeClicked) forControlEvents:UIControlEventTouchUpInside];
        _codeB.titleLabel.font = FontWithSize(13);
        _codeB.layer.cornerRadius = 5;
        _codeB.layer.masksToBounds = YES;
        [_codeB setTitle:@"获取验证码" forState:0];
        [_codeB setTitleColor:ZWHCOLOR(@"646363") forState:0];
        _codeB.layer.borderWidth = 1;
        _codeB.layer.borderColor = LINECOLOR.CGColor;
        [_codeF addSubview:_codeB];
        _codeB.sd_layout
        .centerYEqualToView(_codeF)
        .heightIs(HEIGHT_TO(30))
        .widthIs(WIDTH_TO(80))
        .rightSpaceToView(_codeF, WIDTH_TO(8));
        
        
        UIView *line3 = [[UIView alloc]init];
        line3.backgroundColor = LINECOLOR;
        [_headerView addSubview:line3];
        line3.sd_layout
        .leftEqualToView(code)
        .rightEqualToView(_codeF)
        .heightIs(1)
        .topSpaceToView(code, HEIGHT_TO(20));
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = MAINCOLOR;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn setTitle:@"注册" forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn addTarget:self action:@selector(registerClicked) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
        self.confirmB = btn;
        self.confirmB.alpha = 0.5;
        [self.confirmB setEnabled:NO];
        btn.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(20))
        .rightSpaceToView(_headerView, WIDTH_TO(20))
        .topSpaceToView(line3, HEIGHT_TO(20))
        .heightIs(HEIGHT_TO(50));
        
        _agreeB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeB setImage:ImageNamed(@"a") forState:0];
        [_agreeB setImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
        [_headerView addSubview:_agreeB];
        [_agreeB addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
        _agreeB.sd_layout
        .leftEqualToView(btn)
        .topSpaceToView(btn, HEIGHT_TO(20))
        .heightIs(HEIGHT_TO(20))
        .widthEqualToHeight();
        
        UILabel *aglab = [[UILabel alloc]init];
        [aglab textFont:12 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        aglab.text = @"我已经阅读并同意相关服务条款";
        [_headerView addSubview:aglab];
        aglab.sd_layout
        .leftSpaceToView(_agreeB, WIDTH_TO(6))
        .centerYEqualToView(_agreeB)
        .autoHeightRatio(0)
        .rightSpaceToView(_headerView, WIDTH_TO(15));
        MJWeakSelf
        [aglab yb_addAttributeTapActionWithStrings:@[@"相关服务条款"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            [HttpHandler getArticleInfo:@{@"code":@"zcxy"} Success:^(id obj) {
                if (ReturnValue == 200) {
                    BasicWebViewController *vc = [[BasicWebViewController alloc]init];
                    vc.htmlStr = obj[@"data"][@"content"];
                    vc.title = @"服务协议";
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    ShowInfoWithStatus(ErrorMessage);
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
            }];
        }];
    }
    return _headerView;
}
#pragma mark - 遵守协议
-(void)selectClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.confirmB setEnabled:sender.selected];
    self.confirmB.alpha = sender.selected ? 1 : 0.5 ;
}


#pragma mark - 发送验证码
/*发送验证码*/
-(void)sendCodeClicked{
    if (![UserManager checkTelNumber:_phone.text]) {
        ShowInfoWithStatus(@"请输入正确的手机号");
        return;
    }
    
    [self.view endEditing:YES];
    // 请求发送验证码
    [self changeCodeBtnState:NO];
    _codeTime = 60;
    
    [self countDown];
    
    [self getRecur];
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_codeTimer forMode:NSRunLoopCommonModes];

}
/*倒计时*/
- (void)countDown {
    if (_codeTime == 0) {
        // 倒计时为0
        [_codeTimer invalidate];
        
        [self changeCodeBtnState:YES];
        [self.codeB setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        // 倒计时不为0
        [self changeCodeBtnState:NO];
        
        NSString *str = [NSString stringWithFormat:@"%@s后重发", @(_codeTime)];
        self.codeB.titleLabel.text = str;
        [self.codeB setTitle:str forState:UIControlStateNormal];
        _codeTime--;
    }
}

/// 改变验证码按钮状态
- (void)changeCodeBtnState:(BOOL)state {
    self.codeB.userInteractionEnabled = state;
    if (self.codeB.userInteractionEnabled) {
        self.codeB.backgroundColor = [UIColor whiteColor];
        self.codeB.layer.borderColor = LINECOLOR.CGColor;
        [self.codeB setTitleColor:ZWHCOLOR(@"646363") forState:0];
    } else {
        self.codeB.backgroundColor = [UIColor redColor];
        self.codeB.layer.borderColor = [UIColor redColor].CGColor;
        [self.codeB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)getRecurFaile{
    [_codeTimer invalidate];
    
    [self changeCodeBtnState:YES];
    [self.codeB setBackgroundColor:[UIColor whiteColor]];
    [self.codeB setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeB setTitleColor:ZWHCOLOR(@"646363") forState:0];
}

-(void)getRecur{
    [HttpHandler getsendSmsValidCode:@{@"phone":_phone.text,@"type":@0} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"发送成功");
        }else{
            [self getRecurFaile];
        }
    } failed:^(id obj) {
        [self getRecurFaile];
    }];
}

#pragma mark - 显示密码
-(void)showpassClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.tag == 10) {
        _password.secureTextEntry = sender.selected;
    }else{
        _repirepas.secureTextEntry = sender.selected;
    }
}

#pragma mark - 去登录
-(void)backToLogin{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 注册
-(void)registerClicked{
    ShowProgress
    NotAllowUser
    if (![UserManager checkTelNumber:_phone.text]) {
        ShowInfoWithStatus(@"请输入正确的手机号");
        return;
    }
    if (![UserManager checkPassword:_password.text]) {
        ShowErrorWithStatus(@"请输入6-16位密码");
        return;
    }
    if (![_password.text isEqualToString:_repirepas.text]) {
        ShowInfoWithStatus(@"两次输入密码不同");
        return;
    }
    if (_codeF.text.length != 6 ) {
        ShowInfoWithStatus(@"请输入正确的验证码");
        return;
    }
    if (!_agreeB.selected) {
        ShowInfoWithStatus(@"请遵守用户协议");
        return;
    }
    [HttpHandler getcheckSmsValidCode:@{@"phone":_phone.text,@"type":@0,@"validCode":_codeF.text} Success:^(id obj) {
        if (ReturnValue == 200) {
            [HttpHandler getregister:@{@"phone":_phone.text,@"newPass":_password.text,@"confirmPass":_repirepas.text,@"validCode":_codeF.text} Success:^(id obj) {
                if (ReturnValue == 200) {
                    ShowSuccessWithStatus(@"注册成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    ShowInfoWithStatus(ErrorMessage);
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
            }];
        }else{
            ShowErrorWithStatus(ErrorMessage)
        }
    } failed:^(id obj) {
        ShowErrorWithStatus(ErrorNet);
    }];
    
}

@end
