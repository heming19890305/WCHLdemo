//
//  ZWHOrderTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHOrderTableViewCell.h"

@implementation ZWHOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHGoodsModel *)model{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_model.thumbnail]]];
    _name.text = _model.goodname;
    _intro.text = [NSString stringWithFormat:@"工分 %@元",_model.givescore];
    _money.text = [NSString stringWithFormat:@"%@元",_model.price];
    _num.text = [NSString stringWithFormat:@"×%@",_model.num];
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",_model.marketprice] attributes:attribtDic];
//    _oldprice.attributedText =attribtStr;
    _oldprice.hidden = YES;
    
}

-(void)setOrdermodel:(ZWHGoodsModel *)ordermodel{
    _ordermodel = ordermodel;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_ordermodel.img]]];
    _name.text = _ordermodel.name;
    _intro.text = [NSString stringWithFormat:@"工分 %@元",_ordermodel.score];
    _money.text = [NSString stringWithFormat:@"%@元",_ordermodel.price];
    _num.text = [NSString stringWithFormat:@"×%@",_ordermodel.num];
    _norL.text = [NSString stringWithFormat:@"商品规格:%@",_ordermodel.tabName==nil?@"无":_ordermodel.tabName];
}

-(void)creatView{
    self.backgroundColor = ORDERBACK;
    
    _icon = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    [self.contentView addSubview:_icon];
    _icon.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(10))
    .heightIs(HEIGHT_TO(80))
    .widthIs(WIDTH_TO(120));
    
    _name = [[UILabel alloc]init];
    [_name textFont:16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _name.text = @"贵州酒魂大大大大";
    [self.contentView addSubview:_name];
    _name.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(6))
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .autoHeightRatio(0)
    .topSpaceToView(self.contentView, HEIGHT_TO(10));
    
    [_name setMaxNumberOfLinesToShow:2];
    
    _norL = [[UILabel alloc]init];
    [_norL textFont:13 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _norL.text = @"商品规格：";
    [self.contentView addSubview:_norL];
    _norL.sd_layout
    .leftSpaceToView(_icon, WIDTH_PRO(6))
    .topSpaceToView(_name, HEIGHT_PRO(6))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_PRO(15));
    
    [_norL setMaxNumberOfLinesToShow:1];
    
    _intro = [[UILabel alloc]init];
    [_intro textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _intro.text = @"工分 490元";
    [self.contentView addSubview:_intro];
    _intro.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(6))
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .autoHeightRatio(0)
    .topSpaceToView(_norL, HEIGHT_TO(6));
    
    _money = [[UILabel alloc]init];
    [_money textFont:14 textColor:[UIColor redColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _money.text = @"980元";
    [self.contentView addSubview:_money];
    _money.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(6))
    .autoHeightRatio(0)
    .bottomEqualToView(_icon);
    
    [_money setSingleLineAutoResizeWithMaxWidth:200];
    [_money updateLayout];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"980元" attributes:attribtDic];
    
    _oldprice = [[UILabel alloc]init];
    [_oldprice textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _oldprice.attributedText = attribtStr;
    [self.contentView addSubview:_oldprice];
    _oldprice.sd_layout
    .leftSpaceToView(_money, WIDTH_TO(20))
    .autoHeightRatio(0)
    .bottomEqualToView(_icon);
    
    [_oldprice setSingleLineAutoResizeWithMaxWidth:200];
    [_oldprice updateLayout];
    
    _oldprice.hidden = YES;
    
    _num = [[UILabel alloc]init];
    [_num textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    _num.text = @"×1";
    [self.contentView addSubview:_num];
    _num.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .autoHeightRatio(0)
    .bottomEqualToView(_icon);
    
    [_num setSingleLineAutoResizeWithMaxWidth:200];
    [_num updateLayout];
    _num.hidden = YES;

    
    /*UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:line];
    line.sd_layout
    .widthIs(SCREENWIDTH)
    .heightIs(HEIGHT_TO(10))
    .bottomSpaceToView(self.contentView, 0)
    .centerXEqualToView(self.contentView);*/
}

@end
