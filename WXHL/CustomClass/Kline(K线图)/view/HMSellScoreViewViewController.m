//
//  HMSellScoreViewViewController.m
//  WXHL
//
//  Created by tomorrow on 2018/3/22.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMSellScoreViewViewController.h"

@interface HMSellScoreViewViewController ()
@property (nonatomic, strong) UIView * topview;
@property (nonatomic, strong) UITextField * scoreField;

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
        scoreField.keyboardType = UIKeyboardTypeDefault;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:scoreField];
    scoreField.sd_layout
    .topSpaceToView(_topview, 30)
    .leftSpaceToView(self.view, 30)
    .rightSpaceToView(self.view, 30)
    .heightIs(40);
    
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

//自适应UILabel 大小
- (CGSize)addLabel:(UILabel *)label string:(NSString *)string font:(float)font{
    label.text = string;
    label.font = [UIFont systemFontOfSize:font];
    CGSize widthSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    return widthSize;
}
@end
