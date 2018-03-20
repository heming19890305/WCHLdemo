//
//  ZWHEvaluDetailTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/21.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHEvaluDetailTableViewCell.h"

@implementation ZWHEvaluDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHEvaModel *)model{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:_model.face] placeholderImage:ImageNamed(DefautImageName)];
    _intro.text = _model.content;
    _name.text = _model.nickName==nil?@"暂无名称":_model.nickName;
}

-(void)creatView{
    CellLine
    
    _icon = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    [self.contentView addSubview:_icon];
    _icon.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView,HEIGHT_TO(15))
    .heightIs(HEIGHT_TO(30))
    .widthEqualToHeight();
    _icon.layer.cornerRadius = HEIGHT_TO(30)/2;
    _icon.layer.masksToBounds = YES;
    [_icon updateLayout];
    
    _name = [[UILabel alloc]init];
    [_name textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _name.text = @"何大明";
    [self.contentView addSubview:_name];
    _name.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(8))
    .centerYEqualToView(_icon)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(200));
    
    _intro = [[UILabel alloc]init];
    [_intro textFont:12 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _intro.text = @"skjadnkaddamsndaksjd";
    [self.contentView addSubview:_intro];
    _intro.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(_icon, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_TO(15));
    
    [self setupAutoHeightWithBottomView:_intro bottomMargin:7.5];
}

@end
