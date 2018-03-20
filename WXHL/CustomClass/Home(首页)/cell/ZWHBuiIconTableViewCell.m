//
//  ZWHBuiIconTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHBuiIconTableViewCell.h"

@implementation ZWHBuiIconTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHBuinessModel *)model{
    _model = model;
    
    _textArray = @[_model.money,_model.rank];
    [self.contentView removeAllSubviews];
    [self creatView];
    _name.text = _model.consumerNo;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_model.face]]];
}


-(void)creatView{
    
    _icon = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    NSLog(@"%f",HEIGHT_TO(30)/2);
    _icon.layer.cornerRadius = HEIGHT_TO(30)/2;
    _icon.layer.masksToBounds = YES;
    [self.contentView addSubview:_icon];
    _icon.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(6))
    .heightIs(HEIGHT_TO(30))
    .widthEqualToHeight()
    .centerYEqualToView(self.contentView);
    
    _name = [[UILabel alloc]init];
    [_name textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_name];
    _name.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(3))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0);
    [_name setSingleLineAutoResizeWithMaxWidth:150];
    _name.text = @"4213542";
    [_name updateLayout];
    
    
    for (NSInteger i = 0; i < 2; i++) {
        CGFloat wid = SCREENWIDTH/3;
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(self.contentView, wid*(i+1))
        .topSpaceToView(self.contentView, 0)
        .heightIs(HEIGHT_TO(50))
        .widthIs(wid);
        
        if (_textArray.count > 1) {
            lab.text = _textArray[i];
        }
    }
    
    CellLine
}

@end
