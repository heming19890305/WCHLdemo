//
//  ZWHCollectTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHCollectTableViewCell.h"

@implementation ZWHCollectTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHCollectModel *)model{
    _model = model;
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.thumbnail] placeholderImage:ImageNamed(@"top_bj1")];
    _name.text = _model.title;
    _intro.text = [NSString stringWithFormat:@"工分 %@元",_model.workpoints];
    _oldprice.text = [NSString stringWithFormat:@"¥%@",_model.marketprice];
    _newprice.text = [NSString stringWithFormat:@"¥%@",_model.price];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_oldprice.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    _oldprice.attributedText = newPrice;
    
    _norL.text = [NSString stringWithFormat:@"商品规格:%@",_model.attrLabel==nil?@"无":_model.attrLabel];
}

-(void)creatView{
    _selectB = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectB setImage:ImageNamed(@"a") forState:0];
    [_selectB setImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
    [self.contentView addSubview:_selectB];
    _selectB.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(30))
    .widthEqualToHeight()
    .centerYEqualToView(self.contentView);
    
    _img = [[UIImageView alloc]initWithImage:ImageNamed(@"top_bj1")];
    [self.contentView addSubview:_img];
    _img.sd_layout
    .leftSpaceToView(_selectB, WIDTH_TO(10))
    .heightIs(HEIGHT_TO(80))
    .widthIs(WIDTH_TO(110))
    .centerYEqualToView(self.contentView);
    
    _name = [[UILabel alloc]init];
    _name.text = @"贵州酒魂酒魂酒魂酒魂酒魂酒魂酒魂";
    [_name textFont:16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_name];
    _name.sd_layout
    .topSpaceToView(self.contentView, HEIGHT_TO(20))
    .leftSpaceToView(_img, WIDTH_TO(6))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_TO(15));
    [_name setMaxNumberOfLinesToShow:1];
    [_name updateLayout];
    
    _norL = [[UILabel alloc]init];
    [_norL textFont:13 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _norL.text = @"商品规格：";
    [self.contentView addSubview:_norL];
    _norL.sd_layout
    .leftSpaceToView(_img, WIDTH_PRO(6))
    .topSpaceToView(_name, HEIGHT_PRO(6))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_PRO(15));
    
    [_norL setMaxNumberOfLinesToShow:1];
    
    _intro = [[UILabel alloc]init];
    _intro.text = @"工分 490元";
    [_intro textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_intro];
    _intro.sd_layout
    .topSpaceToView(_norL, HEIGHT_TO(6))
    .leftSpaceToView(_img, WIDTH_TO(6))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_TO(15));
    [_intro setMaxNumberOfLinesToShow:1];
    [_intro updateLayout];
    
    
    _newprice = [[UILabel alloc]init];
    _newprice.text = @"¥490";
    [_newprice textFont:16 textColor:[UIColor redColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_newprice];
    _newprice.sd_layout
    .bottomSpaceToView(self.contentView, HEIGHT_TO(20))
    .leftSpaceToView(_img, WIDTH_TO(6))
    .autoHeightRatio(0);
    [_newprice setSingleLineAutoResizeWithMaxWidth:150];
    [_newprice updateLayout];
    
    _oldprice = [[UILabel alloc]init];
    _oldprice.text = @"¥230";
    [_oldprice textFont:16 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_oldprice.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    _oldprice.attributedText = newPrice;
    [self.contentView addSubview:_oldprice];
    _oldprice.sd_layout
    .bottomSpaceToView(self.contentView, HEIGHT_TO(20))
    .leftSpaceToView(_newprice, WIDTH_TO(20))
    .autoHeightRatio(0);
    [_oldprice setSingleLineAutoResizeWithMaxWidth:150];
    [_oldprice updateLayout];
    
    
    
    CellLine
    
}

-(void)setIsedit:(BOOL)isedit{
    _isedit = isedit;
    if (_isedit) {
        _selectB.hidden = NO;
        _selectB.sd_layout
        .leftSpaceToView(self.contentView, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(30))
        .widthEqualToHeight()
        .centerYEqualToView(self.contentView);
        _img.sd_layout
        .leftSpaceToView(_selectB, WIDTH_TO(10))
        .heightIs(HEIGHT_TO(80))
        .widthIs(WIDTH_TO(110))
        .centerYEqualToView(self.contentView);
        [_selectB updateLayout];
        [_img updateLayout];
    }else{
        _selectB.hidden = YES;
        _img.sd_layout
        .leftSpaceToView(self.contentView, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(80))
        .widthIs(WIDTH_TO(110))
        .centerYEqualToView(self.contentView);
        [_selectB updateLayout];
        [_img updateLayout];
    }
}



@end
