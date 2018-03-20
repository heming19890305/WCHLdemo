//
//  ZWHRechrDetailTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHRechrDetailTableViewCell.h"

@implementation ZWHRechrDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

/*changeNum (number): 变动数量 ,
 changeType (string): 变化类型 ,
 consumerNo (string): 消费商号 ,
 createDate (string): 创建时间 ,
 id (string): 工分明细ID ,
 newScore (number): 变动后工分数量 ,
 oldScoreNum (number): 变动前工分数量 ,
 unitPrice (number): 工分单价*/

-(void)setModel:(ZSBaseModel *)model{
    _model = model;
    if ([_state integerValue] == 3) {
        ZWHWorkModel *mo = (ZWHWorkModel *)_model;
        _type.text = mo.changeTypeName;
        _yue.text = [NSString stringWithFormat:@"单价：%@",mo.unitPrice];
        if ([mo.sconew floatValue] > [mo.oldScoreNum floatValue]) {
        }
        _money.text = [NSString stringWithFormat:@"%@%@",[mo.paymentType integerValue]==1?@"+":@"-",mo.changeNum];
        _time.text = mo.createDate;
    }else if ([_state integerValue] == 2){
        ZWHBalaeceModel *mo = (ZWHBalaeceModel *)_model;
        NSArray *titleArray = @[@"余额支付",@"余额充值",@"微超支付",@"轮值卖出",@"余额提现",@"余额提成",@"提现退款"];
        _type.text = titleArray[[mo.changeType integerValue]-1];
        _yue.text = [NSString stringWithFormat:@"余额：%@",mo.afterMoney];
        _time.text = mo.createDate;
        /*if ([mo.paymentType integerValue] == 1 || [mo.paymentType integerValue] == 3 || [mo.paymentType integerValue] == 5 ) {
            _money.text = [NSString stringWithFormat:@"-%@",mo.money];
        }else{
            _money.text = [NSString stringWithFormat:@"+%@",mo.money];
        }*/
        _money.text = [NSString stringWithFormat:@"%@%@",[mo.paymentType integerValue]==1?@"+":@"-",mo.money];
    }else if ([_state integerValue] ==0){
        ZWHRechargeModel *mo = (ZWHRechargeModel *)_model;
        _type.text = @"充值到余额";
        _yue.text = [NSString stringWithFormat:@"余额：%@",mo.money];
        _yue.hidden = YES;
        _money.text = [NSString stringWithFormat:@"+%@",mo.money];
        _time.text = mo.createDate;
    }else if ([_state integerValue] ==1){
        ZWHRechargeModel *mo = (ZWHRechargeModel *)_model;
        _type.text = mo.changeTypeName;
        _yue.text = [NSString stringWithFormat:@"余额：%@",mo.afterMoney];
        _money.text = [NSString stringWithFormat:@"%@%@",[mo.paymentType integerValue]==1?@"+":@"-",mo.money];
        _time.text = mo.createDate;
    }else if ([_state integerValue] ==4){
        ZWHRechargeModel *mo = (ZWHRechargeModel *)_model;
        _type.text = @"提现";
        _yue.text = [NSString stringWithFormat:@"余额：%@",mo.cashRemain];
        _money.text = [NSString stringWithFormat:@"-%@",mo.cashMoney];
        _time.text = mo.cashDate;
    }
    
}

-(void)creatView{
    _type = [[UILabel alloc]init];
    _type.text = @"充值到余额";
    [_type textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_type];
    _type.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(18))
    .autoHeightRatio(0)
    .widthIs(200);
    
    _yue = [[UILabel alloc]init];
    _yue.text = @"余额：2000";
    [_yue textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_yue];
    _yue.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(_type, HEIGHT_TO(9))
    .autoHeightRatio(0)
    .widthIs(200);
    
    _time = [[UILabel alloc]init];
    _time.text = @"2017-5-23";
    [_time textFont:13 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_time];
    _time.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(_type)
    .autoHeightRatio(0)
    .widthIs(200);
    
    _money = [[UILabel alloc]init];
    _money.text = @"+20000.00";
    [_money textFont:15 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_money];
    _money.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(_yue)
    .autoHeightRatio(0)
    .widthIs(200);
    
    
    CellLine
}

@end
