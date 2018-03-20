//
//  ZWHEvaluationTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHEvaluationTableViewCell.h"

@implementation ZWHEvaluationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHEvaModel *)model{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:_model.face]];
    _num.text = [NSString stringWithFormat:@"(%@)",_model.cou];
    _intro.text = _model.content;
    _name.text = _model.nickName==nil?@"暂无名称":_model.nickName;
    
    _icon.hidden = NO;
    _name.hidden = NO;
    _intro.hidden = NO;
    _showall.hidden = NO;
}


-(void)creatView{
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:14 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab.text = @"宝贝评价";
    [self.contentView addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(14))
    .autoHeightRatio(0);
    [lab setSingleLineAutoResizeWithMaxWidth:200];
    [lab updateLayout];
    
    _num = [[UILabel alloc]init];
    [_num textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _num.text = @"(0)";
    [self.contentView addSubview:_num];
    _num.sd_layout
    .leftSpaceToView(lab, 0)
    .topSpaceToView(self.contentView, HEIGHT_TO(14))
    .autoHeightRatio(0);
    [_num setSingleLineAutoResizeWithMaxWidth:200];
    [_num updateLayout];
    
    _icon = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    [self.contentView addSubview:_icon];
    _icon.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(lab,HEIGHT_TO(15))
    .heightIs(HEIGHT_TO(30))
    .widthEqualToHeight();
    _icon.layer.cornerRadius = HEIGHT_TO(30)/2;
    _icon.layer.masksToBounds = YES;
    
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
    [_intro setMaxNumberOfLinesToShow:2];
    
    _showall = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showall setTitle:@"查看全部评价" forState:0];
    [_showall setTitleColor:[UIColor redColor] forState:0];
    _showall.layer.cornerRadius = 5;
    _showall.layer.masksToBounds = YES;
    _showall.titleLabel.font = FontWithSize(14);
    _showall.layer.borderColor = [UIColor redColor].CGColor;
    _showall.layer.borderWidth = 1;
    [self.contentView addSubview:_showall];
    _showall.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(_intro, HEIGHT_TO(24))
    .widthIs(WIDTH_TO(112))
    .heightIs(HEIGHT_TO(32));
    
    _icon.hidden = YES;
    _name.hidden = YES;
    _intro.hidden = YES;
    _showall.hidden = YES;
    
}

@end
