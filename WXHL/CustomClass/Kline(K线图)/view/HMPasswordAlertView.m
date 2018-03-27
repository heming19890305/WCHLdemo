//
//  HMPasswordAlertView.m
//  WXHL
//
//  Created by tomorrow on 2018/3/23.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMPasswordAlertView.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HMPasswordAlertView()<UITextFieldDelegate>
@property (nonatomic, assign) PasswordAlertViewType currentType;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * inputBgView;
@property (nonatomic, strong) UITextField * inputTextFiled;
@property (nonatomic, strong) UIButton * confirmBtn;
@end

@implementation HMPasswordAlertView

- (instancetype) initWithType:(PasswordAlertViewType)alertType
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        self.inputTextFiled = [[UITextField alloc] init];
        self.inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        self.inputTextFiled.delegate = self;
        [self addSubview:self.inputTextFiled];
        [self.inputTextFiled addTarget:self action:@selector(inputTextChange:) forControlEvents:UIControlEventEditingChanged];
        _currentType = alertType;
        switch (alertType) {
            case  passwordAlertViewType_default:
            {
                [self setupPasswordAlertViewType_default];
            }
                
                break;
            case passwordAlertViewType_sheet:
            {
                [self setupPasswordAlertViewType_sheet];
            }
                
                break;
                
            default:
                break;
        }
        
    }
    return self;
}
//中间弹框
- (void)setupPasswordAlertViewType_default
{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(20, self.center.y - 100, ScreenWidth - 40, 200)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 15;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.bgView.frame.size.width - 80, 50)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:19];
    self.titleLabel.text = @"请输入密码";
    self.titleLabel.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.titleLabel];
    
    //取消按钮
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(CGRectGetWidth(self.bgView.frame) - 35, 5, 30, 30);
    cancleBtn.backgroundColor = [UIColor brownColor];
    [cancleBtn setImage:[UIImage imageNamed:@"XXX"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancleBtn];
    
    // 分割线
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.bgView.frame.size.width, 1)];
    line1.backgroundColor = [UIColor grayColor];
    [self.bgView addSubview:line1];
    
    //绘制输入框（6个格子 40 X 45）
    _inputBgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bgView.frame) / 2 - 135, CGRectGetMaxY(line1.frame) + 25, 270, 40)];
    _inputBgView.backgroundColor = [UIColor whiteColor];
    _inputBgView.layer.borderWidth = 1.0;
    _inputBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.bgView addSubview:_inputBgView];
    
    //线框
    for (int i = 0; i < 5; i++) {
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake((i + 1) * 45, 0, 1, 40)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_inputBgView addSubview:line];
    }
    
    //黑色圆点
    for (int i = 0; i < 6; i++) {
        UIImageView * imgview = [[UIImageView alloc] initWithFrame:CGRectMake(i * 45, 0, 45, 40)];
        imgview.tag = 100 + i;
        imgview.hidden = YES;
        [_inputBgView addSubview:imgview];
        
        UIImageView * smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 10, 20, 20)];
        smallImageView.image = [UIImage imageNamed:@"###"];
        [imgview addSubview:smallImageView];
    }
    
    //下面的提示文字
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_inputBgView.frame), CGRectGetMaxY(_inputBgView.frame) + 7.5, 240, 15)];
    self.tipsLabel.font = [UIFont systemFontOfSize:14];
    self.tipsLabel.textColor = [UIColor redColor];
    self.tipsLabel.text = @"密码不正确";
    self.tipsLabel.hidden = YES;
    [self.bgView addSubview:self.tipsLabel];
    
    //确定按钮
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = CGRectMake(30, CGRectGetMaxY(self.tipsLabel.frame)+5, CGRectGetWidth(self.bgView.frame)-60, 40);
    self.confirmBtn.userInteractionEnabled = NO;
    self.confirmBtn.backgroundColor = [UIColor grayColor];
    self.confirmBtn.layer.cornerRadius = 10;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(cofirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.confirmBtn];
    
}
//sheet弹框
- (void)setupPasswordAlertViewType_sheet
{
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden) name:UIKeyboardWillHideNotification object:nil];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 200)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    //标题
    self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.bgView.frame.size.width-80, 50)];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.font = [UIFont systemFontOfSize:19];
    self.tipsLabel.text = @"请输入密码";
    self.tipsLabel.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.tipsLabel];
    
    //取消按钮
    UIButton *cancleBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(5, 5, 30, 30);
    cancleBtn.backgroundColor = [UIColor clearColor];
    [cancleBtn setImage:[UIImage imageNamed:@"xxx"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancleBtn];
    
    //分割线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipsLabel.frame), self.bgView.frame.size.width,1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:line1];
    
    //开始绘制输入框(6个格子40X45)
    _inputBgView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bgView.frame)/2-135, CGRectGetMaxY(line1.frame)+25, 270, 40)];
    _inputBgView.backgroundColor = [UIColor whiteColor];
    _inputBgView.layer.borderWidth = 1.0;
    _inputBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.bgView addSubview:_inputBgView];
    //线框
    for (int i = 0; i<5; i++) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake((i+1)*45, 0, 1, 40)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_inputBgView addSubview:line];
    }
    //黑色圆点
    for (int i = 0; i<6; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*45, 0, 45, 40)];
        imgView.tag = 100+i;
        imgView.hidden = YES;
        [_inputBgView addSubview:imgView];
        
        UIImageView *smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12.5, 10, 20, 20)];
        smallImageView.image = [UIImage imageNamed:@"passwordIcon"];
        [imgView addSubview:smallImageView];
    }
    
    //下面的提示文字
    self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_inputBgView.frame), CGRectGetMaxY(_inputBgView.frame)+7.5, 240, 15)];
    self.tipsLabel.font = [UIFont systemFontOfSize:14];
    self.tipsLabel.textColor = [UIColor redColor];
    self.tipsLabel.text = @"密码不正确！";
    self.tipsLabel.hidden = YES;
    [self.bgView addSubview:self.tipsLabel];
    
    //忘记密码按钮
    UIButton *forgetPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPWBtn.frame = CGRectMake(CGRectGetMaxX(self.inputBgView.frame)-70, CGRectGetMaxY(self.tipsLabel.frame), 80, 30);
    [forgetPWBtn addTarget:self action:@selector(forgetPWBtnClick) forControlEvents:UIControlEventTouchUpInside];
    forgetPWBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetPWBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPWBtn setTitleColor:[UIColor colorWithRed:0.01f green:0.45f blue:0.88f alpha:1.00f] forState:UIControlStateNormal];
    [forgetPWBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.bgView addSubview:forgetPWBtn];
}

- (void)keyBoardWillShow:(NSNotification*)notic
{
    //获取键盘的 frame
    CGRect keyBoardRect = [[notic.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘的动画时间
    CGFloat duiTime = [[notic.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //开始动画
    [UIView animateWithDuration:duiTime animations:^{
        CGRect rect = self.bgView.frame;
        rect.origin.y = keyBoardRect.origin.y - rect.size.height;
        self.bgView.frame = rect;
    }];
}
-(void)keyBoardWillHidden
{
    if (_currentType == passwordAlertViewType_sheet) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
        }];
    }
}
//取消按钮
- (void)cancleBtnClick
{
    for (int i = 0; i < 6; i++) {
        UIImageView * imgView = [self.inputBgView viewWithTag:100 + i];
        imgView.hidden = YES;
    }
    self.inputTextFiled.text = @"";
    self.tipsLabel.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(passwordAlertViewDidClickCancleButton)]) {
        [self.delegate passwordAlertViewDidClickCancleButton];
    }
    [self.inputTextFiled resignFirstResponder];
    self.confirmBtn.userInteractionEnabled = NO;
    self.confirmBtn.backgroundColor = [UIColor grayColor];
    [self removeFromSuperview];
}
//确认按钮
-(void)cofirmBtnClick
{
    if ([self.delegate respondsToSelector:@selector(passwordAlertViewCompleteInputWith:)]) {
        [self.delegate passwordAlertViewCompleteInputWith:self.inputTextFiled.text];
        
    }
    self.confirmBtn.userInteractionEnabled = NO;
    self.confirmBtn.backgroundColor = [UIColor grayColor];
}
//忘记密码
- (void)forgetPWBtnClick
{
    if ([self.delegate respondsToSelector:@selector(passwordAlertViewDidClickForgetButton)]) {
        [self.delegate passwordAlertViewDidClickForgetButton];
    }
    for (int i = 0; i < 6; i++) {
        UIImageView * imgView = [self.inputBgView viewWithTag:100 + i];
        imgView.hidden = YES;
    }
    self.inputTextFiled.text = @"";
    self.tipsLabel.hidden = YES;
    
    [self.inputTextFiled resignFirstResponder];
    [self removeFromSuperview];
    
}

- (void)show
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self.inputTextFiled becomeFirstResponder];
}

//密码文字改变 inputTextChange
- (void)inputTextChange:(UITextField *)textField
{
    NSLog(@"被点击了");
    self.tipsLabel.hidden = YES;
    NSLog(@"%@",textField.text);
    
    //显示
    for (int i = 1; i < textField.text.length; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:99+i];
        imgView.hidden = NO;
    }
    //隐藏
    for (NSInteger i = textField.text.length+1; i<=6; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:99+i];
        imgView.hidden = YES;
    }
    
    switch (_currentType) {
        case passwordAlertViewType_default:
        {
            if (textField.text.length == 6) {
                self.confirmBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:106/255.0 alpha:1];
                self.confirmBtn.userInteractionEnabled = YES;
            }else{
                self.confirmBtn.backgroundColor = [UIColor grayColor];
                self.confirmBtn.userInteractionEnabled = NO;
                
            }
        }
            break;
        case passwordAlertViewType_sheet:
        {
            if (textField.text.length == 6) {
                
                if ([self.delegate respondsToSelector:@selector(passwordAlertViewCompleteInputWith:)]) {
                    [self.delegate passwordAlertViewCompleteInputWith:self.inputTextFiled.text];
                }
                
            }
        }
            break;
        default:
            break;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    NSLog(@"---------->%@",textField.text);
    if (range.location >= 6) {
        return NO;
    }
    return YES;
}
//密码错误后调用这个方法
-(void)passwordError{
    for (int i = 0; i<6; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:100+i];
        imgView.hidden = YES;
    }
    self.inputTextFiled.text = @"";
    self.tipsLabel.hidden = NO;
}
//密码正确后调用这个方法
-(void)passwordCorrect{
    for (int i = 0; i<6; i++) {
        UIImageView *imgView = [self.inputBgView viewWithTag:100+i];
        imgView.hidden = YES;
    }
    self.inputTextFiled.text = @"";
    self.tipsLabel.hidden = YES;
    [self removeFromSuperview];
    [self.inputTextFiled resignFirstResponder];
}
//销毁通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"你点到我了");
    [self cancleBtnClick];
}
@end
