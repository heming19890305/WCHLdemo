//
//  HMScoreDetailView.m
//  WXHL
//
//  Created by tomorrow on 2018/4/16.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreDetailView.h"
#import "HMScoreDetailFrame.h"



@implementation HMScoreDetailView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        /**累计获得收益*/
        UILabel * topTitleLabel = [[UILabel alloc] init];
        topTitleLabel.text = @"累计获得收益";
        topTitleLabel.font = [UIFont systemFontOfSize:18.0];
        topTitleLabel.textColor = [UIColor blackColor];
        [self addSubview:topTitleLabel];
        
        
        //创建时间
        UILabel * creatTime = [[UILabel alloc] init];
        creatTime.text = @"2018-04-04 ";
        creatTime.font = [UIFont systemFontOfSize:14.0];
        creatTime.textColor = [UIColor lightGrayColor];
        [self addSubview:creatTime];
        
        
        UILabel * incomeMoneyLabel = [[UILabel alloc] init];
        _incomeMoneyLabel = incomeMoneyLabel;
        incomeMoneyLabel.text = @"￥000000000";
        incomeMoneyLabel.font = [UIFont systemFontOfSize:26.0];
        incomeMoneyLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:incomeMoneyLabel];
       
        
        /**投入资金*/
        UILabel * titleLabel_1 = [[UILabel alloc] init];
        titleLabel_1.text = @"投入资金:";
        
        titleLabel_1.font = [UIFont systemFontOfSize:14.0];
        titleLabel_1.textColor = [UIColor grayColor];
        [self addSubview:titleLabel_1];
        
       
        
        UILabel * inputMoney = [[UILabel alloc] init];
        _inputMoneyLabel = inputMoney;
        inputMoney.text = @"￥000000000";
        inputMoney.font = [UIFont systemFontOfSize:14.0];
        inputMoney.textColor = [UIColor redColor];
        [self addSubview:inputMoney];
        
        
        /**总工分*/
        UILabel * titleLabel_2 = [[UILabel alloc] init];
        titleLabel_2.text = @"总工分(个):";
        
        titleLabel_2.font = [UIFont systemFontOfSize:14.0];
        titleLabel_2.textColor = [UIColor grayColor];
        [self addSubview:titleLabel_2];
        
       
        
        
        UILabel * poolNum = [[UILabel alloc] init];
        _poolNumLabel = poolNum;
        poolNum.text = @"000000000";
        
        poolNum.font = [UIFont systemFontOfSize:14.0];
        poolNum.textColor = [UIColor redColor];
        [self addSubview:poolNum];
       
        
        /**已发放天数*/
        
        
        UILabel * issueDays = [[UILabel alloc] init];
        _issueDaysLabel = issueDays;
        issueDays.text = @"000000000";
        issueDays.font = [UIFont systemFontOfSize:16.0];
        issueDays.textColor = [UIColor redColor];
        [self addSubview:issueDays];
       
        
        
        
        /**已到账工分*/
        
        
        UILabel * dayIssueWorkpoints = [[UILabel alloc] init];
        _dayIssueWorkpointsLabel = dayIssueWorkpoints;
        dayIssueWorkpoints.text = @"000000000";
        
        dayIssueWorkpoints.font = [UIFont systemFontOfSize:14.0];
        dayIssueWorkpoints.textColor = [UIColor redColor];
        [self addSubview:dayIssueWorkpoints];
       
        
        UILabel * titleLabel_4 = [[UILabel alloc] init];
        titleLabel_4.text = @"到账工分(个): ";
        titleLabel_4.font = [UIFont systemFontOfSize:14.0];
        titleLabel_4.textColor = [UIColor grayColor];
        [self addSubview:titleLabel_4];
        
     
        
        UILabel * titleLabel_3 = [[UILabel alloc] init];
        titleLabel_3.text = @"已发放 ";
        titleLabel_3.font = [UIFont systemFontOfSize:14.0];
        titleLabel_3.textColor = [UIColor grayColor];
        [self addSubview:titleLabel_3];
        
       
        
        //分割线
        UIView * diveLine = [[UIView alloc] init];
        _diveLine = diveLine;
        diveLine.backgroundColor = lineColor;
        [self addSubview:diveLine];
       
        
        UIButton * sellBtn = [[UIButton alloc] init];
        _sellScore_Btn = sellBtn;
        //    sellBtn.hidden = YES;
        [sellBtn setTitle:@"现在卖出" forState:UIControlStateNormal];
        [sellBtn setTitleColor:[UIColor colorWithRed:0 / 255.0 green:132 / 255.0 blue:232 /255.0 alpha:1] forState:0];
        [sellBtn setTitleColor:[UIColor redColor] forState:1];
        [sellBtn addTarget:self action:@selector(sellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sellBtn];
       
    
    }
    return self;
}
- (void)sellBtnClick:(HMScoreModel *)sender
{
    
    NSLog(@"被点击了！");
    [_degegate sellScoreBtn:_model.id];
}

/**
 ** 添加数据
 ***/
- (void)setScoreDetailFrame:(HMScoreDetailFrame *)scoreDetailFrame
{
    _scoreDetailFrame = scoreDetailFrame;
    self.frame = scoreDetailFrame.frame;
    
    //取出工分数据
    HMScoreModel * model = scoreDetailFrame.model;
    
    //收益金额
    _inputMoneyLabel.text = [self data:model.inputMoney];
    _inputMoneyLabel.frame = scoreDetailFrame.inputMoneyFrame;
    //投资金额
    _incomeMoneyLabel.text = [self data:model.incomeMoney];
    _incomeMoneyLabel.frame = scoreDetailFrame.incomeMoneyFrame;
    //总工分
    _poolNumLabel.text = [self data2:model.poolNum];
    _poolNumLabel.frame = scoreDetailFrame.poolNumFrame;
    //已发放天数
    _issueDaysLabel.text = [NSString stringWithFormat:@" %0.0f 天",model.issueDays];
    _issueDaysLabel.frame = scoreDetailFrame.issueDaysFrame;
    //到账工分
    _dayIssueWorkpointsLabel.text = [NSString stringWithFormat:@" %0.5f ",model.poolRealNum];
    _dayIssueWorkpointsLabel.frame = scoreDetailFrame.dayIssueWorkpointsFrame;
    //创建时间
    _createDateLabel.text = [NSString stringWithFormat:@"%@",model.createDate];
    _inputMoneyLabel.frame = scoreDetailFrame.createDateFrame;
    
}



//自适应UILabel 大小
- (CGSize)addLabel:(UILabel *)label {
    CGSize widthSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    return widthSize;
}
//数据长度
- (NSString *)data:(float) data{
    NSString * dataStr;
    if (data > 1000) {
        data = data / 1000;
        dataStr = [NSString stringWithFormat:@"￥%0.2f K",data];
    }else{
        dataStr = [NSString stringWithFormat:@"￥%0.f ",data];
    }
    return dataStr;
}- (NSString *)data2:(float) data{
    NSString * dataStr;
    if (data > 1000) {
        data = data / 1000;
        dataStr = [NSString stringWithFormat:@"%0.2f K",data];
    }else{
        dataStr = [NSString stringWithFormat:@"%0.f ",data];
    }
    return dataStr;
}
@end
