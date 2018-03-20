//
//  ZWHSetPhoneViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSetPhoneViewController.h"

@interface ZWHSetPhoneViewController (){
    /// 验证码获取倒计时定时器
    NSTimer *_codeTimer;
    /// 验证码倒计时时间
    NSUInteger _codeTime;
}

@property(nonatomic,strong)UILabel *phone;

@property(nonatomic,strong)UITextField *codeF;

@property(nonatomic,strong)UITextField *newphone;

@property(nonatomic,strong)UIButton *codeB;

@end

@implementation ZWHSetPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GRAYBACKCOLOR;
    [self creatView];
}

-(void)creatView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view , 0)
    .topSpaceToView(self.view, 0)
    .heightIs(60);
    
    UILabel *old = [[UILabel alloc]init];
    old.text = @"原手机号";
    [view addSubview:old];
    old.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .centerYEqualToView(view)
    .autoHeightRatio(0)
    .widthIs(80);
    
    _phone = [[UILabel alloc]init];
    _phone.text = [UserManager sharedData].mymodel.phone;
    [_phone textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:_phone];
    _phone.sd_layout
    .leftSpaceToView(old, WIDTH_TO(15))
    .centerYEqualToView(view)
    .autoHeightRatio(0)
    .rightSpaceToView(view, WIDTH_TO(15));
    
    UIView *mid = [[UIView alloc]init];
    mid.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mid];
    mid.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view , 0)
    .topSpaceToView(view, 1)
    .heightIs(60);
    
    UILabel *code = [[UILabel alloc]init];
    code.text = @"验证码";
    [mid addSubview:code];
    code.sd_layout
    .leftSpaceToView(mid, WIDTH_TO(15))
    .centerYEqualToView(mid)
    .autoHeightRatio(0)
    .widthIs(80);
    
    _codeB = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeB.layer.borderColor = LINECOLOR.CGColor;
    _codeB.layer.borderWidth = 1;
    _codeB.titleLabel.font = FontWithSize(12);
    [_codeB setTitle:@"获取验证码" forState:0];
    [_codeB setTitleColor:ZWHCOLOR(@"646363") forState:0];
    [mid addSubview:_codeB];
    _codeB.sd_layout
    .rightSpaceToView(mid, WIDTH_TO(15))
    .centerYEqualToView(mid)
    .widthIs(WIDTH_TO(80))
    .heightIs(HEIGHT_TO(40));
    
    [_codeB addTarget:self action:@selector(sendCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _codeF = [[UITextField alloc]init];
    _codeF.placeholder = @"请输入验证码";
    _codeF.keyboardType = UIKeyboardTypeNumberPad;
    [mid addSubview:_codeF];
    _codeF.sd_layout
    .leftSpaceToView(code, WIDTH_TO(15))
    .rightSpaceToView(_codeB, WIDTH_TO(5))
    .centerYEqualToView(mid)
    .heightIs(HEIGHT_TO(40));
    
    UIView *bottom = [[UIView alloc]init];
    bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom];
    bottom.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view , 0)
    .topSpaceToView(mid, 1)
    .heightIs(60);
    
    UILabel *newnumber = [[UILabel alloc]init];
    newnumber.text = @"新手机号";
    [bottom addSubview:newnumber];
    newnumber.sd_layout
    .leftSpaceToView(bottom, WIDTH_TO(15))
    .centerYEqualToView(bottom)
    .autoHeightRatio(0)
    .widthIs(80);
    
    
    _newphone = [[UITextField alloc]init];
    _newphone.placeholder = @"请输入新手机";
    _newphone.keyboardType = UIKeyboardTypeNumberPad;
    [bottom addSubview:_newphone];
    _newphone.sd_layout
    .leftSpaceToView(newnumber, WIDTH_TO(15))
    .rightSpaceToView(bottom, WIDTH_TO(5))
    .centerYEqualToView(bottom)
    .heightIs(HEIGHT_TO(40));
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(changePhone) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:0];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = MAINCOLOR;
    [self.view addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(20))
    .rightSpaceToView(self.view, WIDTH_TO(20))
    .topSpaceToView(bottom, HEIGHT_TO(30))
    .heightIs(HEIGHT_TO(50));
    
}

/*修改手机*/
-(void)changePhone{
    if (![UserManager checkTelNumber:_newphone.text]) {
        ShowInfoWithStatus(@"请输入正确的手机号");
        return;
    }
    if (_codeF.text.length != 6 ) {
        ShowInfoWithStatus(@"请输入正确的验证码");
        return;
    }
    [HttpHandler getcheckSmsValidCode:@{@"phone":_phone.text,@"type":@8,@"validCode":_codeF.text} Success:^(id obj) {
        if (ReturnValue == 200) {
            [HttpHandler getchangePhone:@{@"phone":[UserManager sharedData].mymodel.phone,@"validCode":_codeF.text,@"newPhone":_newphone.text,@"v_weichao":[UserManager token]} Success:^(id obj) {
                if (ReturnValue == 200) {
                    ShowSuccessWithStatus(@"修改成功");
                    NOTIFY_POST(@"myinfodata");
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

/*发送验证码*/
-(void)sendCodeClicked{
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
        [self.codeB setBackgroundColor:[UIColor whiteColor]];
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
    } else {
        self.codeB.backgroundColor = [UIColor redColor];
    }
}

- (void)getRecurFaile{
    [_codeTimer invalidate];
    
    [self changeCodeBtnState:YES];
    [self.codeB setBackgroundColor:[UIColor whiteColor]];
    [self.codeB setTitle:@"获取验证码" forState:UIControlStateNormal];
}

-(void)getRecur{
    [HttpHandler getsendSmsValidCode:@{@"phone":_phone.text,@"type":@8} Success:^(id obj) {
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
@end
