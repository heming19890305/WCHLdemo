//
//  HMSellScoreViewViewController.m
//  WXHL
//
//  Created by tomorrow on 2018/3/22.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMSellScoreViewViewController.h"
#import "HMPasswordAlertView.h"

@interface HMSellScoreViewViewController ()<HMPassWordAlertViewDelegate>
@property (nonatomic, strong) UIView * topview;
@property (nonatomic, strong) UITextField * scoreField;
@property (nonatomic, strong) HMPasswordAlertView * alertDefaultView;
@property (nonatomic, strong) HMPasswordAlertView * alertSheetView;

@end

@implementation HMSellScoreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
   //1.顶部view
    [self setupTopView];
    [self setupBottomView];
}
- (void)setupBottomView
{
    UITextField * scoreField = [[UITextField alloc] init];
    _scoreField = scoreField;
    scoreField.backgroundColor = [UIColor greenColor];
    _scoreField.clearButtonMode = UITextFieldViewModeAlways;
    _scoreField.font = FontWithSize(17);
    scoreField.textColor = ZWHCOLOR(@"646363");
    if (@available(iOS 10.0, *)) {
        scoreField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:scoreField];
    scoreField.sd_layout
    .topSpaceToView(_topview, 30)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(40);
    
    UIButton * nextBtn = [[UIButton alloc] init];
    nextBtn.backgroundColor = [UIColor orangeColor];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    [nextBtn setTitle:@"下一步" forState:0];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    nextBtn.sd_layout
    .topSpaceToView(scoreField, 30)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(40);
    
    //提示框
    //默认样式
    _alertDefaultView = [[HMPasswordAlertView alloc] initWithType:passwordAlertViewType_default];
    _alertDefaultView.delegate = self;
    _alertDefaultView.titleLabel.text = @"请输入交易密码";
    _alertDefaultView.tipsLabel.text = @"您输入的密码不正确！";
    
    //sheet样式
    _alertSheetView = [[HMPasswordAlertView alloc] initWithType:passwordAlertViewType_sheet];
    _alertSheetView.delegate = self;
    _alertSheetView.titleLabel.text = @"请输入交易密码";
    _alertSheetView.tipsLabel.text = @"您输入的密码不正确！";
    
    
    
}
//顶部view
- (void)setupTopView
{
    UIView *topView = [[UIView alloc] init];
    _topview = topView;
    topView.backgroundColor = LINECOLOR;
    [self.view addSubview:topView];
    topView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(200);
    
    UILabel * needScoreLabel = [UILabel new];
    needScoreLabel.backgroundColor = LINECOLOR;
//    needScoreLabel.text = @"系统剩余回收个数";
    needScoreLabel.textColor = [UIColor lightGrayColor];
    CGSize needScoreSize = [self addLabel:needScoreLabel string:@"系统剩余回收个数:" font:16];
    [topView addSubview:needScoreLabel];
    needScoreLabel.sd_layout
    .topSpaceToView(topView, 10)
    .leftSpaceToView(topView, 10)
    .widthIs(needScoreSize.width)
    .heightIs(needScoreSize.height);
    
    UILabel * needScoreNum = [UILabel new];
    needScoreNum.backgroundColor = LINECOLOR;
    needScoreNum.textColor = [UIColor grayColor];
    CGSize needScoreNumSize = [self addLabel:needScoreNum string:@"50000个" font:16];
    [topView addSubview:needScoreNum];
    needScoreNum.sd_layout
    .topSpaceToView(topView, 10)
    .leftSpaceToView(needScoreLabel, 10)
    .widthIs(needScoreNumSize.width)
    .heightIs(needScoreNumSize.height);
    
    UILabel *scoreNumLabel = [UILabel new];
    scoreNumLabel.backgroundColor = LINECOLOR;
    //    needScoreLabel.text = @"系统剩余回收个数";
    scoreNumLabel.textColor = [UIColor lightGrayColor];
    CGSize ScoreLabelSize = [self addLabel:scoreNumLabel string:@"系统剩余回收个数:" font:16];
    [topView addSubview:scoreNumLabel];
    scoreNumLabel.sd_layout
    .topSpaceToView(needScoreLabel, 10)
    .leftSpaceToView(topView, 10)
    .widthIs(ScoreLabelSize.width)
    .heightIs(ScoreLabelSize.height);
    
    UILabel * scoreNum = [UILabel new];
    scoreNum.backgroundColor = LINECOLOR;
    scoreNum.textColor = [UIColor lightGrayColor];
    CGSize scoreNumSize = [self addLabel:scoreNum string:@"2000个" font:36];
    [topView addSubview:scoreNum];
    scoreNum.sd_layout
    .centerXEqualToView(topView)
    .bottomSpaceToView(topView, 50)
    .heightIs(scoreNumSize.height)
    .widthIs(scoreNumSize.width);
    
}
- (void)nextBtnClick
{
    float sum = [_scoreField.text floatValue];
    [_alertDefaultView show];
//    [_alertSheetView show];
    NSLog(@"num = %f",sum);
}
- (void)passwordAlertViewCompleteInputWith:(NSString *)password
{
    NSLog(@"输入的密码为：%@",password);
    
    if ([password isEqualToString:@"554637"]) {
        NSLog(@"密码正确");
        [_alertDefaultView passwordCorrect];
        //这里必须延迟一下，不然看不到最后一个黑点显示，整个视图就消失了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertSheetView passwordCorrect];
        });
    }else
    {
        NSLog(@"密码错误");
        [_alertDefaultView passwordError];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertSheetView passwordError];
        });
    }
}
- (void)passwordAlertViewDidClickCancleButton{
    NSLog(@"点击了取消按钮");
}

- (void)passwordAlertViewDidClickForgetButton
{
    NSLog(@"点击了密码忘记按钮");
}
//自适应UILabel 大小
- (CGSize)addLabel:(UILabel *)label string:(NSString *)string font:(float)font{
    label.text = string;
    label.font = [UIFont systemFontOfSize:font];
    CGSize widthSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    return widthSize;
}
@end
