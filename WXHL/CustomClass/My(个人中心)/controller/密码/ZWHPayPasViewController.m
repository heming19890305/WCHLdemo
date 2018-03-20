//
//  ZWHPayPasViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHPayPasViewController.h"
#import "ZWHSetPayPasViewController.h"

@interface ZWHPayPasViewController (){
    /// 验证码获取倒计时定时器
    NSTimer *_codeTimer;
    /// 验证码倒计时时间
    NSUInteger _codeTime;
}

@property(nonatomic,strong)UILabel *phone;

@property(nonatomic,strong)UITextField *codeF;

@property(nonatomic,strong)UIButton *codeB;


@end

@implementation ZWHPayPasViewController

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
    old.text = @"已验证手机";
    [view addSubview:old];
    old.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .centerYEqualToView(view)
    .autoHeightRatio(0)
    .widthIs(120);
    
    _phone = [[UILabel alloc]init];
    _phone.text = [[UserManager phone] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
    
    [_phone textFont:15 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
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
    .leftSpaceToView(mid, WIDTH_TO(15))
    .rightSpaceToView(_codeB, WIDTH_TO(5))
    .centerYEqualToView(mid)
    .heightIs(HEIGHT_TO(40));
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(nextstep) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"下一步" forState:0];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = MAINCOLOR;
    [self.view addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(20))
    .rightSpaceToView(self.view, WIDTH_TO(20))
    .topSpaceToView(mid, HEIGHT_TO(30))
    .heightIs(HEIGHT_TO(50));
}

#pragma mark - 下一步
-(void)nextstep{
    ShowProgress
    NotAllowUser
    MJWeakSelf
    [HttpHandler getcheckSmsValidCode:@{@"phone":_phoneStr,@"type":@7,@"validCode":_codeF.text} Success:^(id obj) {
        if (ReturnValue == 200) {
            Dismiss
            ZWHSetPayPasViewController *vc = [[ZWHSetPayPasViewController alloc]init];
            vc.phone = weakSelf.codeF.text;
            vc.title = @"支付密码";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage)
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
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

-(void)getRecur{
    [HttpHandler getsendSmsValidCode:@{@"phone":_phoneStr,@"type":@7} Success:^(id obj) {
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

/// 改变验证码按钮状态
- (void)changeCodeBtnState:(BOOL)state {
    self.codeB.userInteractionEnabled = state;
    
    if (self.codeB.userInteractionEnabled) {
        self.codeB.backgroundColor = [UIColor whiteColor];
        [self.codeB setTitleColor:ZWHCOLOR(@"646363") forState:0];
        [self.codeB setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        [self.codeB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.codeB.backgroundColor = [UIColor redColor];
    }
}

- (void)getRecurFaile{
    [_codeTimer invalidate];
    
    [self changeCodeBtnState:YES];
    [self.codeB setBackgroundColor:[UIColor whiteColor]];
    [self.codeB setTitle:@"获取验证码" forState:UIControlStateNormal];
}


@end
