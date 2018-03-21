//
//  HMScoreMidViewTableViewCell.m
//  WXHL
//
//  Created by tomorrow on 2018/3/15.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreMidViewTableViewCell.h"

@implementation HMScoreMidViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        //添加中间控件
        [self setupMidView];
    }
    return self;
}
//添加中间控件
- (void)setupMidView
{
    
    //1.背景View
    UIView * BgView = [UIView new];
    BgView.backgroundColor = LINECOLOR;
    [self addSubview:BgView];
    BgView.sd_layout
    .topSpaceToView(self, 0)
    .bottomEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self);
    //2.添加订单数据
    //2.1添加“订单”label
    UILabel * orderLabel = [UILabel new];
    orderLabel.text = @"订单";
    orderLabel.textColor = [UIColor blueColor];
    orderLabel.font = [UIFont systemFontOfSize:18.0];
    [BgView addSubview:orderLabel];
    orderLabel.sd_layout
    .topSpaceToView(BgView, 20)
    .leftSpaceToView(BgView, 10)
    .widthIs(60)
    .heightIs(25);
    //2.2订单数据view
    UIView * orderView = [UIView new];
    orderView.backgroundColor = [UIColor whiteColor];
    [BgView addSubview:orderView];
    orderView.sd_layout
    .topSpaceToView(orderLabel, 6)
    .leftEqualToView(BgView)
    .rightEqualToView(BgView)
    .heightIs(50);
    //2.3 订单笔数Label
    UILabel * orderNumLabel = [UILabel new];
    orderNumLabel.text = @"今日订单（笔）：";
    orderNumLabel.font = [UIFont systemFontOfSize:16.0];
    [orderView addSubview:orderNumLabel];
    CGSize orderNumLabelSize = [self addLabel:orderNumLabel string:orderNumLabel.text];
    orderNumLabel.sd_layout
    .topEqualToView(orderView)
    .bottomEqualToView(orderView)
    .leftSpaceToView(orderView, 10)
    .widthIs(orderNumLabelSize.width);
    //2.4订单数据Label
    UILabel * orderDataLabel = [UILabel new];
    float orderData = 2253;
    orderDataLabel.text = [self data:orderData];
    orderDataLabel.font = [UIFont systemFontOfSize:16.0];
    [orderView addSubview:orderDataLabel];
    CGSize orderDataLabelSize = [self addLabel:orderNumLabel string:orderDataLabel.text];
    orderDataLabel.sd_layout
    .topEqualToView(orderView)
    .bottomEqualToView(orderView)
    .leftSpaceToView(orderNumLabel, 2)
    .widthIs(orderDataLabelSize.width);
    //2.5订单金额数据Label
    UILabel * orderAmountDataLabel = [UILabel new];
    float orderAmountData = 225233;
    orderAmountDataLabel.text = [self data:orderAmountData];
    orderAmountDataLabel.font = [UIFont systemFontOfSize:16.0];
    [orderView addSubview:orderAmountDataLabel];
    CGSize orderAmountDataLabelSize = [self addLabel:orderAmountDataLabel string:orderAmountDataLabel.text];
    orderAmountDataLabel.sd_layout
    .topEqualToView(orderView)
    .bottomEqualToView(orderView)
    .rightSpaceToView(orderView, 10)
    .widthIs(orderAmountDataLabelSize.width);
    //2.6 订单金额Label
    UILabel * orderAmountabel = [UILabel new];
    orderAmountabel.text = @"订单合计（元）：";
    orderAmountabel.font = [UIFont systemFontOfSize:16.0];
    [orderView addSubview:orderAmountabel];
    CGSize orderAmountabelSize = [self addLabel:orderAmountabel string:orderAmountabel.text];
    orderAmountabel.sd_layout
    .topEqualToView(orderView)
    .bottomEqualToView(orderView)
    .rightSpaceToView(orderAmountDataLabel, 2)
    .widthIs(orderAmountabelSize.width);
    
    
    
    //3.添加分成数据
    //3.1添加“分成”label
    UILabel * boundsLabel = [UILabel new];
    boundsLabel.text = @"分成";
    boundsLabel.textColor = [UIColor blueColor];
    boundsLabel.font = [UIFont systemFontOfSize:18.0];
    [BgView addSubview:boundsLabel];
    boundsLabel.sd_layout
    .topSpaceToView(orderView, 20)
    .leftSpaceToView(BgView, 10)
    .widthIs(60)
    .heightIs(25);
    //3.2分成数据view
    UIView * boundsView = [UIView new];
    boundsView.backgroundColor = [UIColor whiteColor];
    [BgView addSubview:boundsView];
    boundsView.sd_layout
    .topSpaceToView(boundsLabel, 6)
    .leftEqualToView(BgView)
    .rightEqualToView(BgView)
    .heightIs(50);
    //3.3 订单笔数Label
    UILabel * orderBoundsLabel = [UILabel new];
    orderBoundsLabel.text = @"分成工分（个）：";
    orderBoundsLabel.font = [UIFont systemFontOfSize:16.0];
    [boundsView addSubview:orderBoundsLabel];
    CGSize orderBoundsLabelSize = [self addLabel:orderBoundsLabel string:orderBoundsLabel.text];
    orderBoundsLabel.sd_layout
    .topEqualToView(boundsView)
    .bottomEqualToView(boundsView)
    .leftSpaceToView(boundsView, 10)
    .widthIs(orderBoundsLabelSize.width);
    //3.4分成工分个数数据Label
    UILabel * orderBoundsDataLabel = [UILabel new];
    float orderBoundsData = 2253;
    orderBoundsDataLabel.text = [self data:orderBoundsData];
    orderBoundsDataLabel.font = [UIFont systemFontOfSize:16.0];
    [boundsView addSubview:orderBoundsDataLabel];
    CGSize orderBoundsDataLabelSize = [self addLabel:orderBoundsDataLabel string:orderBoundsDataLabel.text];
    orderBoundsDataLabel.sd_layout
    .topEqualToView(boundsView)
    .bottomEqualToView(boundsView)
    .leftSpaceToView(orderBoundsLabel, 2)
    .widthIs(orderBoundsDataLabelSize.width);
    //3.5分成金额数据Label
    UILabel * boundsDataLabel = [UILabel new];
    float boundsAmountData = 2233;
//    _amount = boundsAmountData;
    boundsDataLabel.text = [self data:boundsAmountData];
    boundsDataLabel.font = [UIFont systemFontOfSize:16.0];
    [boundsView addSubview:boundsDataLabel];
    CGSize boundsDataLabelSize = [self addLabel:boundsDataLabel string:boundsDataLabel.text];
    boundsDataLabel.sd_layout
    .topEqualToView(boundsView)
    .bottomEqualToView(boundsView)
    .rightSpaceToView(boundsView, 10)
    .widthIs(boundsDataLabelSize.width);
    //3.6 分成金额Label
    UILabel * boundsAmountabel = [UILabel new];
    boundsAmountabel.text = @"分成金额（元）：";
    boundsAmountabel.font = [UIFont systemFontOfSize:16.0];
    [boundsView addSubview:boundsAmountabel];
    CGSize boundsAmountabelSize = [self addLabel:boundsAmountabel string:boundsAmountabel.text];
    boundsAmountabel.sd_layout
    .topEqualToView(boundsView)
    .bottomEqualToView(boundsView)
    .rightSpaceToView(boundsDataLabel, 2)
    .widthIs(boundsAmountabelSize.width);
//    //计算分成Btn
//    UIButton *boundsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    boundsBtn.backgroundColor = [UIColor clearColor];
//    [boundsBtn addTarget:self action:@selector(boundsClick:) forControlEvents:UIControlEventTouchUpInside];
//    [boundsBtn setTitleColor:[UIColor blueColor] forState:0];
//    [boundsBtn setTitle:@"计算分成" forState:0];
//    boundsBtn.layer.cornerRadius = 8;
//    boundsBtn.layer.masksToBounds = YES;
//    boundsBtn.layer.borderColor = [[UIColor blueColor] CGColor];
//    boundsBtn.layer.borderWidth = 1;
//    [BgView addSubview:boundsBtn];
    //        sellBtn.sd_layout.topEqualToView(_num, HEIGHT_TO(31)).lefts
//    boundsBtn.sd_layout
//    .topSpaceToView(boundsView, HEIGHT_TO(31))
//    .centerXEqualToView(BgView)
//    .widthIs(WIDTH_TO(220))
//    .heightIs(HEIGHT_TO(38));
    
}
//自适应UILabel 大小
- (CGSize)addLabel:(UILabel *)label string:(NSString *)string {
    CGSize widthSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    return widthSize;
}
//数据长度
- (NSString *)data:(float) data{
    NSString * dataStr;
    if (data > 10000) {
        data = data / 10000;
        dataStr = [NSString stringWithFormat:@"%0.2f 万",data];
    }else{
        dataStr = [NSString stringWithFormat:@"%0.f ",data];
    }
    return dataStr;
}
@end
