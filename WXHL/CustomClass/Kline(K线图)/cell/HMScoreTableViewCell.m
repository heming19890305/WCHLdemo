//
//  HMScoreTableViewCell.m
//  WXHL
//
//  Created by tomorrow on 2018/4/10.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreTableViewCell.h"

@interface HMScoreTableViewCell()

@end

@implementation HMScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
        self.contentView.backgroundColor = ORDERBACK;
        
    }
    return self;
}

- (void)setModel:(HMScoreModel *)model
{
    _model = model;
    _inputMoneyLabel.text = [self data:model.inputMoney];
    _incomeMoneyLabel.text = [self data:model.incomeMoney];
    _poolNumLabel.text = [self data2:model.poolNum];
    _issueDaysLabel.text = [NSString stringWithFormat:@" %0.0f 天",model.issueDays];
    _dayIssueWorkpointsLabel.text = [NSString stringWithFormat:@" %0.5f ",model.dayIssueWorkpoints];
    _createDateLabel.text = [NSString stringWithFormat:@"%@",model.createDate];
//    NSLog(@"YYY哟 =======%@",model.businessNo);
  
}
- (void)creatView
{
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    bgView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(200);
   /**累计获得收益*/
    UILabel * topTitleLabel = [[UILabel alloc] init];
    topTitleLabel.text = @"累计获得收益";
    topTitleLabel.font = [UIFont systemFontOfSize:18.0];
    topTitleLabel.textColor = [UIColor blackColor];
    [bgView addSubview:topTitleLabel];
    CGSize topTitleLabelSize = [self addLabel:topTitleLabel];
    topTitleLabel.sd_layout
    .topSpaceToView(bgView, 15)
    .leftSpaceToView(bgView, 10)
    .widthIs(topTitleLabelSize.width)
    .heightIs(topTitleLabelSize.height);
    
    //创建时间
    UILabel * creatTime = [[UILabel alloc] init];
    creatTime.text = @"2018-04-04 ";
    creatTime.font = [UIFont systemFontOfSize:14.0];
    creatTime.textColor = [UIColor lightGrayColor];
    [bgView addSubview:creatTime];
    CGSize creatTimeSize = [self addLabel:creatTime];
    creatTime.sd_layout
    .centerYEqualToView(topTitleLabel)
    .rightSpaceToView(bgView, 30)
    .widthIs(creatTimeSize.width)
    .heightIs(creatTimeSize.height);
    
    UILabel * incomeMoneyLabel = [[UILabel alloc] init];
    _incomeMoneyLabel = incomeMoneyLabel;
    incomeMoneyLabel.text = @"￥000000000";
    incomeMoneyLabel.font = [UIFont systemFontOfSize:26.0];
    incomeMoneyLabel.textColor = [UIColor lightGrayColor];
    [bgView addSubview:incomeMoneyLabel];
    CGSize incomeMoneyLabelSize = [self addLabel:incomeMoneyLabel];
    incomeMoneyLabel.sd_layout
    .topSpaceToView(topTitleLabel, 10)
    .leftSpaceToView(bgView, 5)
    .widthIs(incomeMoneyLabelSize.width)
    .heightIs(incomeMoneyLabelSize.height);
    /**投入资金*/
    UILabel * titleLabel_1 = [[UILabel alloc] init];
    titleLabel_1.text = @"投入资金:";

    titleLabel_1.font = [UIFont systemFontOfSize:14.0];
    titleLabel_1.textColor = [UIColor grayColor];
    [bgView addSubview:titleLabel_1];
    
    CGSize titleLabel_1_size = [self addLabel:titleLabel_1];
    titleLabel_1.sd_layout
    .topSpaceToView(incomeMoneyLabel, 10)
    .leftSpaceToView(bgView,8)
    .widthIs(titleLabel_1_size.width)
    .heightIs(titleLabel_1_size.height);
    
    UILabel * inputMoney = [[UILabel alloc] init];
    _inputMoneyLabel = inputMoney;
    inputMoney.text = @"￥000000000";
    
    inputMoney.font = [UIFont systemFontOfSize:14.0];
    inputMoney.textColor = [UIColor redColor];
    [bgView addSubview:inputMoney];
    
    CGSize inputMoney_size = [self addLabel:inputMoney];
    inputMoney.sd_layout
    .topSpaceToView(incomeMoneyLabel, 10)
    .leftSpaceToView(titleLabel_1,2)
    .widthIs(inputMoney_size.width)
    .heightIs(inputMoney_size.height);
    
   /**总工分*/
    UILabel * titleLabel_2 = [[UILabel alloc] init];
    titleLabel_2.text = @"总工分(个):";
    
    titleLabel_2.font = [UIFont systemFontOfSize:14.0];
    titleLabel_2.textColor = [UIColor grayColor];
    [bgView addSubview:titleLabel_2];
    
    CGSize titleLabel_2_size = [self addLabel:titleLabel_2];
    titleLabel_2.sd_layout
    .topSpaceToView(titleLabel_1, 10)
    .leftSpaceToView(bgView,8)
    .widthIs(titleLabel_2_size.width)
    .heightIs(titleLabel_2_size.height);
    
    UILabel * poolNum = [[UILabel alloc] init];
    _poolNumLabel = poolNum;
    poolNum.text = @"000000000";
    
    poolNum.font = [UIFont systemFontOfSize:14.0];
    poolNum.textColor = [UIColor redColor];
    [bgView addSubview:poolNum];
    CGSize poolNum_size = [self addLabel:poolNum];
    poolNum.sd_layout
    .topSpaceToView(titleLabel_1, 10)
    .leftSpaceToView(titleLabel_2,2)
    .widthIs(poolNum_size.width)
    .heightIs(poolNum_size.height);
    
    /**已发放天数*/
    
    
    UILabel * issueDays = [[UILabel alloc] init];
    _issueDaysLabel = issueDays;
    issueDays.text = @"000000000";
    
    issueDays.font = [UIFont systemFontOfSize:16.0];
    issueDays.textColor = [UIColor redColor];
    [bgView addSubview:issueDays];
    CGSize issueDays_size = [self addLabel:issueDays];
    issueDays.sd_layout
    .topSpaceToView(incomeMoneyLabel, 10)
    .rightSpaceToView(bgView,20)
    .widthIs(issueDays_size.width)
    .heightIs(issueDays_size.height);
    
   
    
    /**已到账工分*/
    
    
    UILabel * dayIssueWorkpoints = [[UILabel alloc] init];
    _dayIssueWorkpointsLabel = dayIssueWorkpoints;
    dayIssueWorkpoints.text = @"000000000";
    
    dayIssueWorkpoints.font = [UIFont systemFontOfSize:14.0];
    dayIssueWorkpoints.textColor = [UIColor redColor];
    [bgView addSubview:dayIssueWorkpoints];
    CGSize dayIssueWorkpoints_size = [self addLabel:dayIssueWorkpoints];
    dayIssueWorkpoints.sd_layout
    .topSpaceToView(issueDays, 10)
    .rightSpaceToView(bgView,10)
    .widthIs(dayIssueWorkpoints_size.width)
    .heightIs(dayIssueWorkpoints_size.height);
    
    UILabel * titleLabel_4 = [[UILabel alloc] init];
    titleLabel_4.text = @"到账工分(个): ";
    titleLabel_4.font = [UIFont systemFontOfSize:14.0];
    titleLabel_4.textColor = [UIColor grayColor];
    [bgView addSubview:titleLabel_4];
    
    CGSize titleLabel_4_size = [self addLabel:titleLabel_4];
    titleLabel_4.sd_layout
    .topSpaceToView(titleLabel_1, 10)
    .rightSpaceToView(dayIssueWorkpoints, 5)
    .widthIs(titleLabel_4_size.width)
    .heightIs(titleLabel_4_size.height);
    
    UILabel * titleLabel_3 = [[UILabel alloc] init];
    titleLabel_3.text = @"已发放 ";
    titleLabel_3.font = [UIFont systemFontOfSize:14.0];
    titleLabel_3.textColor = [UIColor grayColor];
    [bgView addSubview:titleLabel_3];
    
    CGSize titleLabel_3_size = [self addLabel:titleLabel_3];
    titleLabel_3.sd_layout
    .topSpaceToView(incomeMoneyLabel, 10)
    .rightSpaceToView(issueDays, 20)
    .widthIs(titleLabel_3_size.width)
    .heightIs(titleLabel_3_size.height);
    
    //分割线
    UIView * diveLine = [[UIView alloc] init];
    diveLine.backgroundColor = lineColor;
    [bgView addSubview:diveLine];
    diveLine.sd_layout
    .topSpaceToView(poolNum, 10)
    .leftEqualToView(bgView)
    .rightEqualToView(bgView)
    .heightIs(1);
    
    UIButton * sellBtn = [[UIButton alloc] init];
    [sellBtn setTitle:@"现在卖出" forState:UIControlStateNormal];
    [sellBtn setTitleColor:[UIColor colorWithRed:0 / 255.0 green:132 / 255.0 blue:232 /255.0 alpha:1] forState:0];
    [sellBtn setTitleColor:[UIColor redColor] forState:1];
    [sellBtn addTarget:self action:@selector(sellBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sellBtn];
    sellBtn.sd_layout
    .topSpaceToView(diveLine, 10)
    .centerXEqualToView(bgView)
    .widthIs(150)
    .heightIs(40);
    
    _cellHeight = bgView.height;
}

- (void)sellBtnClick
{
    
    NSLog(@"被点击了！");
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
