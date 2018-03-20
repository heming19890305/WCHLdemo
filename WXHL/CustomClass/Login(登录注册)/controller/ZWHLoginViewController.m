//
//  ZWHLoginViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHLoginViewController.h"
#import "ZWHRegisterViewController.h"
#import "ZWHForgetViewController.h"

@interface ZWHLoginViewController ()

@property(nonatomic,strong)UITextField *phone;
@property(nonatomic,strong)UITextField *password;

@end

@implementation ZWHLoginViewController

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
    self.title = @"登录";
    [self creatView];
}

-(void)creatView{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerClicked)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    [self.view addSubview:img];
    img.sd_layout
    .topSpaceToView(self.view, HEIGHT_TO(30))
    .heightIs(HEIGHT_TO(110))
    .widthIs(WIDTH_TO(100))
    .centerXEqualToView(self.view);
    
    UILabel *number = [[UILabel alloc]init];
    number.text = @"手机号";
    [number textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:number];
    number.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .topSpaceToView(img, HEIGHT_TO(40))
    .autoHeightRatio(0);
    [number setSingleLineAutoResizeWithMaxWidth:150];
    [number updateLayout];
    
    _phone = [[UITextField alloc]init];
    _phone.textColor = ZWHCOLOR(@"646363");
    _phone.clearButtonMode = UITextFieldViewModeAlways;
    _phone.font = FontWithSize(17);
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phone];
    _phone.sd_layout
    .leftSpaceToView(number, WIDTH_TO(20))
    .rightSpaceToView(self.view, WIDTH_TO(15))
    .centerYEqualToView(number)
    .heightIs(HEIGHT_TO(25));
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LINECOLOR;
    [self.view addSubview:line];
    line.sd_layout
    .leftEqualToView(number)
    .rightEqualToView(_phone)
    .heightIs(1)
    .topSpaceToView(number, HEIGHT_TO(20));
    
    UILabel *pas = [[UILabel alloc]init];
    pas.text = @"密码";
    [pas textFont:17 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:pas];
    pas.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .topSpaceToView(line, HEIGHT_TO(24))
    .autoHeightRatio(0);
    [pas setSingleLineAutoResizeWithMaxWidth:150];
    [pas updateLayout];
    
    _password = [[UITextField alloc]init];
    _password.textColor = ZWHCOLOR(@"646363");
    _password.keyboardType = UIKeyboardTypeASCIICapable;
    _password.secureTextEntry = YES;
    _password.font = FontWithSize(17);
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = MAINCOLOR;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"登录" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(20))
    .rightSpaceToView(self.view, WIDTH_TO(20))
    .topSpaceToView(line1, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(50));
    
    
    UIButton *forpas = [UIButton buttonWithType:UIButtonTypeCustom];
    forpas.backgroundColor = [UIColor clearColor];
    [forpas setTitle:@"忘记密码?" forState:0];
    forpas.titleLabel.font = FontWithSize(14);
    [forpas setTitleColor:ZWHCOLOR(@"646363") forState:0];
    [forpas addTarget:self action:@selector(forgetPasClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forpas];
    forpas.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .widthIs(WIDTH_TO(100))
    .topSpaceToView(btn, HEIGHT_TO(25))
    .heightIs(HEIGHT_TO(30));
    forpas.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

#pragma mark - 显示密码
-(void)showpassClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    _password.secureTextEntry = sender.selected;
}

#pragma mark - 登录
-(void)loginClicked{
    ShowProgress
    NotAllowUser
    if (![UserManager checkPassword:self.phone.text]) {
        ShowInfoWithStatus(@"请输入正确的手机号");
        return;
    }
    if (self.password.text.length == 0) {
        ShowInfoWithStatus(@"请输入密码");
        return;
    }
    [HttpHandler getlogin:@{@"username":self.phone.text,@"password":self.password.text} Success:^(id obj) {
        if (ReturnValue == 200) {
            //Dismiss
            NSLog(@"%@",obj);
            //[UserManager sharedData].token = obj[@"data"];
            NSString *token = obj[@"data"];
            NSLog(@"%@",[UserManager token]);
            [HttpHandler getCurrentUser:@{@"v_weichao":token} Success:^(id obj) {
                if (ReturnValue == 200) {
                    NSLog(@"%@",obj);
                    Dismiss
                    [UserManager sharedData].password = _password.text;
                    [UserManager sharedData].zhanghao = _phone.text;
                    [UserManager sharedData].token = token;
                    [UserManager sharedData].mymodel = [ZWHMyModel mj_objectWithKeyValues:obj[@"data"]];
                    [UserManager sharedData].userDict = obj[@"data"];
                    [JPUSHService setAlias:[UserManager account] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        NSLog(@"%ld,%@,%ld",(long)iResCode,iAlias,(long)seq);
                    } seq:0];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    ShowInfoWithStatus(ErrorMessage);
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
            }];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - 注册
-(void)registerClicked{
    ZWHRegisterViewController *vc = [[ZWHRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 忘记密码
-(void)forgetPasClicked{
    ZWHForgetViewController *vc = [[ZWHForgetViewController alloc]init];
    vc.title = @"找回密码";
    [self.navigationController pushViewController:vc animated:YES];
}



@end
