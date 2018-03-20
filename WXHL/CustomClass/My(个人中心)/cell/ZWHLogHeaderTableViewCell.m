//
//  ZWHLogHeaderTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHLogHeaderTableViewCell.h"

@implementation ZWHLogHeaderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setGoodsmodel:(ZWHGoodsModel *)goodsmodel{
    _goodsmodel = goodsmodel;
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_goodsmodel.img]]];
    _numL.text = [NSString stringWithFormat:@"%ld件商品",_goodsmodel.goodslogNum];
}


-(void)setModel:(ZWHLogistModel *)model{
    _model = model;
    _stateL.text = _model.status;
    _from.text = _model.name;
    _number.text = _model.postNo;
}

-(void)creatView{
    _img = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    [self.contentView addSubview:_img];
    _img.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(20))
    .bottomSpaceToView(self.contentView, HEIGHT_TO(20))
    .widthIs(HEIGHT_TO(80));
    //_img.hidden = YES;
    
    _numL = [[UILabel alloc]init];
    [_numL textFont:12 textColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithWhite:0.3 alpha:0.8] textAlignment:NSTextAlignmentCenter];
    [_img addSubview:_numL];
    _numL.sd_layout
    .leftEqualToView(_img)
    .rightEqualToView(_img)
    .bottomEqualToView(_img)
    .heightIs(HEIGHT_TO(20));
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab.text = @"物流状态：";
    [self.contentView addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(_img, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(30))
    .autoHeightRatio(0);
    [lab setSingleLineAutoResizeWithMaxWidth:200];
    [lab updateLayout];
    
    _stateL = [[UILabel alloc]init];
    [_stateL textFont:14 textColor:MAINCOLOR backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _stateL.text = @"";
    [self.contentView addSubview:_stateL];
    _stateL.sd_layout
    .leftSpaceToView(lab, WIDTH_TO(15))
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .autoHeightRatio(0)
    .topEqualToView(lab);
    
    UILabel *lab1 = [[UILabel alloc]init];
    [lab1 textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab1.text = @"承运来源：";
    [self.contentView addSubview:lab1];
    lab1.sd_layout
    .leftSpaceToView(_img, WIDTH_TO(15))
    .topSpaceToView(lab, HEIGHT_TO(10))
    .autoHeightRatio(0);
    [lab1 setSingleLineAutoResizeWithMaxWidth:200];
    [lab1 updateLayout];
    
    _from = [[UILabel alloc]init];
    [_from textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _from.text = @"";
    [self.contentView addSubview:_from];
    _from.sd_layout
    .leftSpaceToView(lab1, WIDTH_TO(15))
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .autoHeightRatio(0)
    .topEqualToView(lab1);
    
    UILabel *lab2 = [[UILabel alloc]init];
    [lab2 textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab2.text = @"运单编号：";
    [self.contentView addSubview:lab2];
    lab2.sd_layout
    .leftSpaceToView(_img, WIDTH_TO(15))
    .topSpaceToView(lab1, HEIGHT_TO(10))
    .autoHeightRatio(0);
    [lab2 setSingleLineAutoResizeWithMaxWidth:200];
    [lab2 updateLayout];
    
    _number = [[UILabel alloc]init];
    [_number textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _number.text = @"";
    [self.contentView addSubview:_number];
    _number.sd_layout
    .leftSpaceToView(lab2, WIDTH_TO(15))
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .autoHeightRatio(0)
    .topEqualToView(lab2);
}

@end
