//
//  PasswordView.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "PasswordView.h"
#import "ZWHPayPasViewController.h"
// 输入密码的位数
static const int boxCount = 6;
// 输入方格的边长
static const CGFloat boxWH = 55;

@interface PasswordView()
@property (strong, nonatomic) NSMutableArray *boxes;
// 占位编辑框(这样就点击密码格以外的部分,可以弹出键盘)
@property (weak, nonatomic) UITextField *contentTextField;

@end


@implementation PasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUpContentView];
    }
    return self;
}

-(void)closeView{
    if (_dismissV) {
        _dismissV();
    }
}

- (void)setUpContentView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:ImageNamed(@"left_fanhui") forState:0];
    [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(self, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(20))
    .widthEqualToHeight();
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:20 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    lab.text = @"请输入支付密码";
    [self addSubview:lab];
    lab.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, HEIGHT_TO(20))
    .autoHeightRatio(0)
    .widthIs(HEIGHT_TO(200));
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LINECOLOR;
    [self addSubview:line];
    line.sd_layout
    .topSpaceToView(self, HEIGHT_TO(60))
    .centerXEqualToView(self)
    .widthRatioToView(self, 1)
    .heightIs(1);
    
    
    
    UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.contentTextField = contentField;
    contentField.keyboardType = UIKeyboardTypeNumberPad;
    contentField.placeholder = @"请输入支付密码";
    contentField.hidden = YES;
    [contentField addTarget:self action:@selector(txchange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:contentField];
    
    
    UIButton *findm = [UIButton buttonWithType:UIButtonTypeCustom];
    [findm setTitle:@"忘记密码?" forState:0];
    [findm setTitleColor:MAINCOLOR forState:0];
    [findm addTarget:self action:@selector(forgetfassword) forControlEvents:UIControlEventTouchUpInside];
    findm.titleLabel.font = FontWithSize(14);
    [self addSubview:findm];
    findm.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(40))
    .widthIs(WIDTH_TO(100))
    .topSpaceToView(self, HEIGHT_TO(boxWH + 20 + 60 + 20));
    findm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    // 密码格之间的间隔
    CGFloat margin = 0;
    for (int i = 0; i < boxCount; i++)
    {
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - boxCount * HEIGHT_TO(boxWH) - (boxCount - 1)* margin) * 0.5 + (HEIGHT_TO(boxWH) + margin) * i - i;
        //UITextField *pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake(x, (self.frame.size.height - boxWH) * 0.5, boxWH, boxWH)];
        UITextField *pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake(x, HEIGHT_TO(80), WIDTH_TO(boxWH), HEIGHT_TO(boxWH))];
        pwdLabel.layer.borderColor = lineColor.CGColor;
        pwdLabel.enabled = NO;
        pwdLabel.textAlignment = NSTextAlignmentCenter;//居中
        pwdLabel.secureTextEntry = YES;//设置密码模式
        pwdLabel.layer.borderWidth = 1;
        [self addSubview:pwdLabel];
        
        [self.boxes addObject:pwdLabel];
    }
    //进入界面，contentTextField 成为第一响应
    [self.contentTextField becomeFirstResponder];
}

#pragma mark - 忘记密码
-(void)forgetfassword{
    if (_findpw) {
        _findpw();
    }
}

#pragma mark 文本框内容改变
- (void)txchange:(UITextField *)tx
{
    NSString *password = tx.text;
    
    for (int i = 0; i < self.boxes.count; i++)
    {
        UITextField *pwdtx = [self.boxes objectAtIndex:i];
        pwdtx.text = @"";
        if (i < password.length)
        {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdtx.text = pwd;
        }
        
    }
    // 输入密码完毕
    if (password.length == boxCount)
    {
       // [tx resignFirstResponder];//隐藏键盘
        if (self.returnPasswordStringBlock != nil) {
            self.returnPasswordStringBlock(password);
        }
        
    }
}
#pragma mark --- 懒加载
- (NSMutableArray *)boxes{
    if (!_boxes) {
        _boxes = [NSMutableArray array];
    }
    return _boxes;
}




@end
