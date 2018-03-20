//
//  ZWHBalanceViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHBalanceViewController.h"
#import "ZWHRecharDetailViewController.h"
#import "ZWHRecharSuccessViewController.h"
#import "PasswordView.h"
#import "ZWHWalletModel.h"

@interface ZWHBalanceViewController ()<UITextFieldDelegate>


@property(nonatomic,strong)UIView *midview;
@property(nonatomic,strong)UILabel *money;
@property(nonatomic,strong)UITextField *contex;
@property(nonatomic,strong)UIButton *rechar;

@property(nonatomic,strong)PasswordView *pdView;

@property(nonatomic,strong)UIButton *backgroundBtn;
@end

@implementation ZWHBalanceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];
    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [_state integerValue]==1?@"余额充值":@"提货券充值";
    [self creatView];
    NOTIFY_ADD(getData, @"paySuccessAliPay");
    NOTIFY_ADD(payfaild, @"cancelOrderWayChat");
}

-(void)payfaild{
    ShowSuccessWithStatus(@"支付取消");
}
-(void)dealloc{
    NOTIFY_REMOVE(@"paySuccessAliPay");
    NOTIFY_REMOVE(@"cancelOrderWayChat");
}



#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
            //weakSelf.money.text = model.cashRemain;
            weakSelf.money.text = [_state integerValue]==1?model.cashRemain:model.coupon;
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
    [self.backBtn setImage:ImageNamed(@"left") forState:0];
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(showDetail:)];
    self.navigationItem.rightBarButtonItem = more;
    [self.view addSubview:self.midview];
    
    _contex = [[UITextField alloc]init];
    _contex.layer.borderColor = ZWHCOLOR(@"e7e7e7").CGColor;
    _contex.layer.borderWidth = 1;
    _contex.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contex];
    _contex.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(_midview, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(60));
    _contex.delegate = self;
    [_contex updateLayout];
    
    NSDictionary *attributes = @{NSFontAttributeName:FontWithSize(16)};
    CGFloat length = [@"金额：" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH + WIDTH_PRO(100), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    UILabel * lable = [[UILabel alloc]init];
    lable.frame = CGRectMake(WIDTH_TO(15), 0, length+WIDTH_TO(30), 30);
    [lable textFont:WIDTH_PRO(14) textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    lable.text = @"金额：";
    _contex.leftView = lable;
    _contex.font = FontWithSize(15);
    _contex.textColor = [UIColor grayColor];
    _contex.leftViewMode = UITextFieldViewModeAlways;
    _contex.keyboardType = UIKeyboardTypeDecimalPad;
    
    _rechar = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechar.backgroundColor = MAINCOLOR;
    [_rechar addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rechar setTitle:@"下一步" forState:0];
    [_rechar setTitleColor:[UIColor whiteColor] forState:0];
    _rechar.layer.cornerRadius = 5;
    _rechar.layer.masksToBounds = YES;
    [self.view addSubview:_rechar];
    _rechar.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(30))
    .rightSpaceToView(self.view, WIDTH_TO(30))
    .topSpaceToView(_contex, HEIGHT_TO(30))
    .heightIs(HEIGHT_TO(60));
}
#pragma mark - 下一步
-(void)nextClick:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([_state integerValue] == 1) {
        ShowProgress
        NotAllowUser
        MJWeakSelf
        [HttpHandler getwalletRecharge:@{@"money":@([_contex.text floatValue]),@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                NSLog(@"%@",obj);
                [self aliPay:obj[@"data"] urlScheme:@"com.ZWHWXHL.cn.WXHL"];
                weakSelf.contex.text = @"";
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }else{
        ShowProgress
        NotAllowUser
        MJWeakSelf
        [HttpHandler getrechargeCoupon:@{@"money":@([_contex.text floatValue]),@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                NSLog(@"%@",obj);
                [self aliPay:obj[@"data"] urlScheme:@"com.ZWHWXHL.cn.WXHL"];
                weakSelf.contex.text = @"";
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }
    
    /*UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundBtn.backgroundColor = [UIColor blackColor];
    _backgroundBtn.alpha = 0.5;
    [_backgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_backgroundBtn];
    _backgroundBtn.sd_layout
    .topEqualToView(window)
    .leftEqualToView(window)
    .rightEqualToView(window)
    .bottomEqualToView(window);
    MJWeakSelf
    _pdView = [[PasswordView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(210), self.view.bounds.size.width, SCREENHIGHT - HEIGHT_TO(210))];
    _pdView.returnPasswordStringBlock = ^(NSString *password){
        [weakSelf dismisChooseView];
        if ([password isEqualToString:@"123456"]) {
            ZWHRecharSuccessViewController *vc = [[ZWHRecharSuccessViewController alloc]init];
            [weakSelf presentViewController:vc animated:YES completion:nil];
        }
    };
    _pdView.dismissV = ^{
        [weakSelf.backgroundBtn removeFromSuperview];
        [weakSelf.pdView removeFromSuperview];
    };
    
    _pdView.findpw = ^{
        NSLog(@"忘记密码");
    };
    
    [window addSubview:_pdView];
    */
}

-(void)dismisChooseView{
    [_backgroundBtn removeFromSuperview];
    [_pdView removeFromSuperview];
}

#pragma mark - 支付宝支付
- (void)aliPay:(NSString *)url urlScheme:(NSString *)urlScheme
{
    NSLog(@"%@ -- %@",url,urlScheme);
    
    //[url stringByReplacingOccurrencesOfString:@"——" withString:@""];
    [[AlipaySDK defaultService] payUrlOrder:url fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultCode"] isEqualToString:@"6001"]) {
            [SVProgressHUD showSuccessWithStatus:@"取消支付"];
        }else if ([resultDic[@"resultCode"] isEqualToString:@"4000"]) {
            [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
        }else if ([resultDic[@"resultCode"] isEqualToString:@"6002"]) {
            [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
        }if ([resultDic[@"resultCode"] isEqualToString:@"9000"]) {
        }
    }];
}

#pragma mark - 查看明细
-(void)showDetail:(UIButton *)sender{
    ZWHRecharDetailViewController *vc = [[ZWHRecharDetailViewController alloc]init];
    vc.state = [_state integerValue] == 1?@"0":@"1";
    vc.title = [_state integerValue] == 1?@"充值明细":@"提货券明细";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(((string.intValue<0) || (string.intValue>9))){
        //MyLog(@"====%@",string);
        if ((![string isEqualToString:@"."])) {
            return NO;
        }
        return NO;
    }
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger dotNum = 0;
    NSInteger flag=0;
    const NSInteger limited = 2;
    if((int)futureString.length>=1){
        
        if([futureString characterAtIndex:0] == '.'){//the first character can't be '.'
            return NO;
        }
        if((int)futureString.length>=2){//if the first character is '0',the next one must be '.'
            if(([futureString characterAtIndex:1] != '.'&&[futureString characterAtIndex:0] == '0')){
                return NO;
            }
        }
    }
    NSInteger dotAfter = 0;
    for (int i = (int)futureString.length-1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            dotNum ++;
            dotAfter = flag+1;
            if (flag > limited) {
                return NO;
            }
            if(dotNum>1){
                return NO;
            }
        }
        flag++;
    }
    if(futureString.length - dotAfter > 15){
        return NO;
    }
    return YES;
}

#pragma mark - getter
-(UIView *)midview{
    if (!_midview) {
        _midview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(210)-64)];
        _midview.backgroundColor = MAINCOLOR;
        
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:15 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        lab.text = @"我的余额(元)";
        lab.text = [_state integerValue]==1?@"我的余额(元)":@"我的提货券(元)";
        [_midview addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(_midview, WIDTH_TO(15))
        .topSpaceToView(_midview, HEIGHT_TO(25))
        .autoHeightRatio(0)
        .widthIs(200);
        
        _money = [[UILabel alloc]init];
        [_money textFont:46 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _money.text = _model.cashRemain;
        _money.text = [_state integerValue]==1?_model.cashRemain:_model.coupon;
        [_midview addSubview:_money];
        _money.sd_layout
        .leftSpaceToView(_midview, WIDTH_TO(15))
        .topSpaceToView(lab, HEIGHT_TO(25))
        .autoHeightRatio(0)
        .rightSpaceToView(_midview, WIDTH_TO(15));
    }
    return _midview;
}


@end
