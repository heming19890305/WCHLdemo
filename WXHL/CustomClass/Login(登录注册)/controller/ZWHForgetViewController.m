//
//  ZWHForgetViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHForgetViewController.h"

@interface ZWHForgetViewController ()
{
    /// 验证码获取倒计时定时器
    NSTimer *_codeTimer;
    /// 验证码倒计时时间
    NSUInteger _codeTime;
}
@property(nonatomic,strong)UITextField *phone;
@property(nonatomic,strong)UITextField *password;
@property(nonatomic,strong)UITextField *repirepas;
@property(nonatomic,strong)UITextField *codeF;
@property(nonatomic,strong)UIButton *codeB;
@property(nonatomic,strong)UIButton *agreeB;

@end

@implementation ZWHForgetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:GRAYBACKCOLOR];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAYBACKCOLOR;
    [self creatView];
}

-(void)creatView{
    UILabel *number = [[UILabel alloc]init];
    number.text = @"手机号";
    [number textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:number];
    number.sd_layout
    .leftSpaceToView(self.view , WIDTH_TO(15))
    .topSpaceToView(self.view , HEIGHT_TO(20))
    .autoHeightRatio(0);
    [number setSingleLineAutoResizeWithMaxWidth:150];
    [number updateLayout];
    
    _phone = [[UITextField alloc]init];
    _phone.textColor = ZWHCOLOR(@"646363");
    _phone.clearButtonMode = UITextFieldViewModeAlways;
    _phone.font = FontWithSize(17);
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.placeholder = @"请输入手机号";
    [self.view  addSubview:_phone];
    _phone.sd_layout
    .leftSpaceToView(number, WIDTH_TO(20))
    .rightSpaceToView(self.view , WIDTH_TO(15))
    .centerYEqualToView(number)
    .heightIs(HEIGHT_TO(25));
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LINECOLOR;
    [self.view  addSubview:line];
    line.sd_layout
    .leftEqualToView(number)
    .rightEqualToView(_phone)
    .heightIs(1)
    .topSpaceToView(number, HEIGHT_TO(20));
    
    UILabel *code = [[UILabel alloc]init];
    code.text = @"验证码";
    [code textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:code];
    code.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .topSpaceToView(line, HEIGHT_TO(24))
    .autoHeightRatio(0);
    [code setSingleLineAutoResizeWithMaxWidth:150];
    [code updateLayout];
    
    _codeF = [[UITextField alloc]init];
    _codeF.textColor = ZWHCOLOR(@"646363");
    _codeF.keyboardType = UIKeyboardTypeNumberPad;
    _codeF.font = FontWithSize(17);
    _codeF.placeholder = @"请输入验证码";
    [self.view addSubview:_codeF];
    _codeF.sd_layout
    .leftSpaceToView(code, WIDTH_TO(20))
    .rightSpaceToView(self.view, WIDTH_TO(15))
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
    [self.view addSubview:line3];
    line3.sd_layout
    .leftEqualToView(code)
    .rightEqualToView(_codeF)
    .heightIs(1)
    .topSpaceToView(code, HEIGHT_TO(20));
    
    UILabel *pas = [[UILabel alloc]init];
    pas.text = @"密码";
    [pas textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:pas];
    pas.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .topSpaceToView(line3, HEIGHT_TO(24))
    .autoHeightRatio(0);
    [pas setSingleLineAutoResizeWithMaxWidth:150];
    [pas updateLayout];
    
    _password = [[UITextField alloc]init];
    _password.textColor = ZWHCOLOR(@"646363");
    _password.keyboardType = UIKeyboardTypeASCIICapable;
    _password.secureTextEntry = YES;
    _password.font = FontWithSize(17);
    _password.placeholder = @"6-16字符";
    [self.view addSubview:_password];
    _password.sd_layout
    .leftSpaceToView(pas, WIDTH_TO(20))
    .rightSpaceToView(self.view, WIDTH_TO(15))
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
    [self.view addSubview:line1];
    line1.sd_layout
    .leftEqualToView(pas)
    .rightEqualToView(_password)
    .heightIs(1)
    .topSpaceToView(pas, HEIGHT_TO(20));
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:backView atIndex:0];
    //[self.view addSubview:backView];
    backView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomEqualToView(line1);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = MAINCOLOR;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"重置密码" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(20))
    .rightSpaceToView(self.view, WIDTH_TO(20))
    .topSpaceToView(line1, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(50));
    
    [btn addTarget:self action:@selector(resetPasClicked) forControlEvents:UIControlEventTouchUpInside];
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
        [self.codeB setTitleColor:ZWHCOLOR(@"646363") forState:0];
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
}

-(void)getRecur{
    [HttpHandler getsendSmsValidCode:@{@"phone":_phone.text,@"type":@1} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"发送成功");
        }else{
            ShowInfoWithStatus(ErrorMessage)
            [self getRecurFaile];
        }
    } failed:^(id obj) {
        ShowSuccessWithStatus(ErrorNet)
        [self getRecurFaile];
    }];
}

#pragma mark - 重置密码
-(void)resetPasClicked{
    if (![UserManager checkTelNumber:_phone.text]) {
        ShowInfoWithStatus(@"请输入正确的手机号");
        return;
    }
    if (![UserManager checkPassword:_password.text]) {
        ShowErrorWithStatus(@"请输入6-16位密码");
        return;
    }
    if (_codeF.text.length != 6 ) {
        ShowInfoWithStatus(@"请输入正确的验证码");
        return;
    }
    ShowProgress
    NotAllowUser
    [HttpHandler getcheckSmsValidCode:@{@"phone":_phone.text,@"type":@1,@"validCode":_codeF.text} Success:^(id obj) {
        if (ReturnValue == 200) {
            [HttpHandler getchangePassword:@{@"phone":_phone.text,@"validCode":_codeF.text,@"newPass":_password.text} Success:^(id obj) {
                if (ReturnValue == 200) {
                    ShowSuccessWithStatus(@"密码成功");
                    ONEPOP
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

#pragma mark - 显示密码
-(void)showpassClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    _password.secureTextEntry = sender.selected;

}


@end
