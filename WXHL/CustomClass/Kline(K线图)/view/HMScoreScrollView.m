//
//  HMScoreScrollView.m
//  WXHL
//
//  Created by tomorrow on 2018/3/14.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreScrollView.h"


@implementation HMScoreScrollView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        //添加子控件
        [self setupTopView];
        //添加中间控件
        [self setupMidView];
    }
    return self;
}
//添加子控件
- (void)setupTopView
{
    //1.添加头部背景
    UIImageView *topView =[[UIImageView alloc] init];
    _TopView = topView;
    topView.image =[UIImage imageNamed:@"xf_top_bj"];
    topView.backgroundColor = [UIColor clearColor];
    [self addSubview:topView];
    topView.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, 64)
    .widthIs((CGFloat)[UIScreen mainScreen].bounds.size.width)
    .heightIs(250);
    
    //2.添加已获得工分个数
    UILabel *gotScoreLabel = [UILabel new];
    gotScoreLabel.textColor = [UIColor whiteColor];
    NSString * labelText = @"当前工分";
    gotScoreLabel.text = labelText;
    gotScoreLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    //自适应UILabel 大小
    CGSize labelSize = [self addLabel:gotScoreLabel string:labelText];
    [topView addSubview:gotScoreLabel];
    gotScoreLabel.sd_layout
    .topSpaceToView(topView, 15)
    .centerXEqualToView(topView)
    .widthIs(labelSize.width)
    .heightIs(labelSize.height);
    //2.1工分个数
    UILabel * gotScore = [UILabel new];
    gotScore.textColor = [UIColor whiteColor];
    double c = 3628428;
    NSString * str ;
    if (c > 10000) {
        c = c / 10000;
        str = [NSString stringWithFormat:@"%0.2f 万",c];
    }else
    {
        str = [NSString stringWithFormat:@"%0.f",c];
    }
    gotScore.font = [UIFont systemFontOfSize:28.0];
    //自适应UILabel 大小
    CGSize gotScoreSize = [self addLabel:gotScore string:str];
    
    gotScore.numberOfLines = 0;
    [topView addSubview:gotScore];
    gotScore.sd_layout
    .topSpaceToView(gotScoreLabel, 3)
    .centerXEqualToView(topView)
    .widthIs(gotScoreSize.width)
    .heightIs(gotScoreSize.height);
    
    //3.添加未获得工分个数
    //3.0 未获得工分label
    UILabel * unGotSoreLabel = [UILabel new];
    unGotSoreLabel.textColor = [UIColor whiteColor];
    NSString * unGotStr = @"未获得工分";
    unGotSoreLabel.text = unGotStr;
    unGotSoreLabel.font =[UIFont boldSystemFontOfSize:14.f];
    CGSize unGotLabelSize = [self addLabel:unGotSoreLabel string:unGotStr];
    [topView addSubview:unGotSoreLabel];
    unGotSoreLabel.sd_layout
    .topSpaceToView(gotScore, 15)
    .centerXEqualToView(topView)
    .widthIs(unGotLabelSize.width)
    .heightIs(unGotLabelSize.height);
    //3.1未获得工分num
    UILabel * unGotScore = [UILabel new];
    unGotScore.textColor = [UIColor whiteColor];
    double d = 12345678;
    NSString * unStr;
    if (d > 10000) {
        d = d / 10000;
        unStr = [NSString stringWithFormat:@"%0.2f 万",d];
    }else{
        unStr = [NSString stringWithFormat:@"%0.f",d];
    }
    unGotScore.font = [UIFont systemFontOfSize:16.0];
    CGSize unGotScoreSize = [self addLabel:unGotScore string:unStr];
    unGotScore.text = unStr;
    unGotScore.numberOfLines = 0;
    [topView addSubview:unGotScore];
    unGotScore.sd_layout
    .topSpaceToView(unGotSoreLabel, 3)
    .centerXEqualToView(topView)
    .widthIs(unGotScoreSize.width)
    .heightIs(unGotScoreSize.height);
    //4.卖出按钮
    UIButton *sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sellBtn.backgroundColor = [UIColor clearColor];
    //    [sellBtn addTarget:self action:@selector(sellClick) forControlEvents:UIControlEventTouchUpInside];
    [sellBtn setTitleColor:[UIColor whiteColor] forState:0];
    [sellBtn setTitle:@"卖出工分" forState:0];
    sellBtn.layer.cornerRadius = 5;
    sellBtn.layer.masksToBounds = YES;
    sellBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    sellBtn.layer.borderWidth = 1;
    [topView addSubview:sellBtn];
    //        sellBtn.sd_layout.topEqualToView(_num, HEIGHT_TO(31)).lefts
    sellBtn.sd_layout
    .topSpaceToView(unGotScore, HEIGHT_TO(31))
    .centerXEqualToView(topView)
    .widthIs(WIDTH_TO(120))
    .heightIs(HEIGHT_TO(38));
    
    //5.明细
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"明细" forState:0];
    //    [btn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.backgroundColor = [UIColor clearColor];
    [topView addSubview:btn];
    btn.sd_layout
    .topSpaceToView(topView, 10)
    .rightSpaceToView(topView,0)
    .heightIs(25)
    .widthIs(WIDTH_TO(60));

}
//添加中间控件
- (void)setupMidView
{
    
        //1.背景View
        UIView * BgView = [UIView new];
        BgView.backgroundColor = LINECOLOR;
        [self addSubview:BgView];
        BgView.sd_layout
        .topSpaceToView(_TopView, 0)
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
        _amount = boundsAmountData;
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
        //计算分成Btn
        UIButton *boundsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        boundsBtn.backgroundColor = [UIColor clearColor];
        [boundsBtn addTarget:self action:@selector(boundsClick:) forControlEvents:UIControlEventTouchUpInside];
        [boundsBtn setTitleColor:[UIColor blueColor] forState:0];
        [boundsBtn setTitle:@"计算分成" forState:0];
        boundsBtn.layer.cornerRadius = 8;
        boundsBtn.layer.masksToBounds = YES;
        boundsBtn.layer.borderColor = [[UIColor blueColor] CGColor];
        boundsBtn.layer.borderWidth = 1;
        [BgView addSubview:boundsBtn];
        //        sellBtn.sd_layout.topEqualToView(_num, HEIGHT_TO(31)).lefts
        boundsBtn.sd_layout
        .topSpaceToView(boundsView, HEIGHT_TO(31))
        .centerXEqualToView(BgView)
        .widthIs(WIDTH_TO(220))
        .heightIs(HEIGHT_TO(38));
        
    }
-(void)setDataModel:(ZWHMyWorkModel *)dataModel
{
    _dataModel = dataModel;
}

//分成计算
- (void)boundsClick:(id)sender{
    
    NSString * str = [NSString stringWithFormat:@"%@ 元", [self data:_amount]];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"当前可获得分成" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    NSLog(@"aaaaaaaaaaaaaaaaaaaa");
    
//    [self.viewController presentViewController:alertController animated:YES completion:nil];
//    [self re]
   
    
    
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
