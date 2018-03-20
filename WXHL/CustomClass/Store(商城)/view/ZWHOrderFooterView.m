//
//  ZWHOrderFooterView.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHOrderFooterView.h"

@implementation ZWHOrderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHOrderModel *)model{
    _model = model;
    _sumMoney.text = [NSString stringWithFormat:@"¥%@",_model.goodsMoney==nil?@"后台数据问题":_model.goodsMoney];
    _freightMoney.text = [NSString stringWithFormat:@"¥%@",_model.postMoney];
    _payMoney.text = [NSString stringWithFormat:@"¥%@",_model.totalMoney];
}

-(void)creatView{
    UILabel *sumlab = [[UILabel alloc]init];
    [sumlab textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    sumlab.text = @"商品总额";
    [self addSubview:sumlab];
    sumlab.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(self, HEIGHT_TO(18))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    
    UILabel *flab = [[UILabel alloc]init];
    [flab textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    flab.text = @"运费";
    [self addSubview:flab];
    flab.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(sumlab, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    
    _sumMoney = [[UILabel alloc]init];
    [_sumMoney textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight];
    _sumMoney.text = @"¥1999.00";
    [self addSubview:_sumMoney];
    _sumMoney.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .centerYEqualToView(sumlab)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    
    _freightMoney = [[UILabel alloc]init];
    [_freightMoney textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight];
    _freightMoney.text = @"¥19.00";
    [self addSubview:_freightMoney];
    _freightMoney.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .centerYEqualToView(flab)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LINECOLOR;
    [self addSubview:line];
    line.sd_layout
    .widthIs(SCREENWIDTH)
    .centerXEqualToView(self)
    .topSpaceToView(self, HEIGHT_TO(70))
    .heightIs(1);
    
    _payMoney = [[UILabel alloc]init];
    [_payMoney textFont:17 textColor:[UIColor redColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    _payMoney.text = @"¥22219.00";
    [self addSubview:_payMoney];
    _payMoney.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(line, HEIGHT_TO(18))
    .autoHeightRatio(0);
    [_payMoney setSingleLineAutoResizeWithMaxWidth:200];
    [_payMoney updateLayout];
    
    UILabel *sf = [[UILabel alloc]init];
    [sf textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight];
    sf.text = @"实付款：";
    [self addSubview:sf];
    sf.sd_layout
    .rightSpaceToView(_payMoney, 0)
    .centerYEqualToView(_payMoney)
    .autoHeightRatio(0);
    [sf setSingleLineAutoResizeWithMaxWidth:200];
    [sf updateLayout];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = LINECOLOR;
    [self addSubview:line1];
    line1.sd_layout
    .widthIs(SCREENWIDTH)
    .centerXEqualToView(self)
    .topSpaceToView(self, HEIGHT_TO(120))
    .heightIs(1);
    
    
    
    _leftBtn = [[UIButton alloc]init];
    [_leftBtn setTitle:@"删除订单" forState:0];
    [_leftBtn setTitleColor:[UIColor grayColor] forState:0];
    _leftBtn.layer.borderColor = LINECOLOR.CGColor;
    _leftBtn.layer.borderWidth = 1;
    _leftBtn.titleLabel.font = FontWithSize(14);
    [self addSubview:_leftBtn];
    _leftBtn.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(line1, HEIGHT_TO(10))
    .widthIs(WIDTH_TO(80))
    .heightIs(HEIGHT_TO(35));
    _leftBtn.hidden = YES;
    
    _rightBtn = [[UIButton alloc]init];
    [_rightBtn setTitle:@"去支付" forState:0];
    [_rightBtn setTitleColor:ZWHCOLOR(@"ff5555") forState:0];
    _rightBtn.layer.borderColor = ZWHCOLOR(@"ff5555").CGColor;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.titleLabel.font = FontWithSize(14);
    [self addSubview:_rightBtn];
    _rightBtn.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .centerYEqualToView(_leftBtn)
    .widthIs(WIDTH_TO(80))
    .heightIs(HEIGHT_TO(35));
    
    _centerBtn = [[UIButton alloc]init];
    [_centerBtn setTitle:@"取消订单" forState:0];
    [_centerBtn setTitleColor:[UIColor grayColor] forState:0];
    _centerBtn.layer.borderColor = LINECOLOR.CGColor;
    _centerBtn.layer.borderWidth = 1;
    _centerBtn.titleLabel.font = FontWithSize(14);
    [self addSubview:_centerBtn];
    _centerBtn.sd_layout
    .rightSpaceToView(_rightBtn, WIDTH_TO(12))
    .centerYEqualToView(_leftBtn)
    .widthIs(WIDTH_TO(80))
    .heightIs(HEIGHT_TO(35));
    
}

@end
