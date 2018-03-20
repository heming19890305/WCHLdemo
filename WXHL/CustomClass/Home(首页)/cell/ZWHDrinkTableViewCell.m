//
//  ZWHDrinkTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHDrinkTableViewCell.h"

@implementation ZWHDrinkTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHDrinkModel *)model{
    _model = model;
    _num.text = _model.orderNo;
    _time.text = _model.createDate;
    _name.text = _model.name==nil?@"":_model.name;
}

-(void)creatView{
    _right = [[UIImageView alloc]initWithImage:ImageNamed(@"right_t")];
    [self.contentView addSubview:_right];
    _right.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(20))
    .widthEqualToHeight();
    
    _num = [[UILabel alloc]init];
    [_num textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _num.text = @"8989045788";
    [self.contentView addSubview:_num];
    _num.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .widthIs(250)
    .autoHeightRatio(0)
    .topSpaceToView(self.contentView, HEIGHT_TO(10));
    
    _time = [[UILabel alloc]init];
    [_time textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _time.text = @"08-25";
    [self.contentView addSubview:_time];
    _time.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .widthIs(250)
    .autoHeightRatio(0)
    .bottomSpaceToView(self.contentView, HEIGHT_TO(10));
    
    _name = [[UILabel alloc]init];
    [_name textFont:16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _name.text = @"";
    [self.contentView addSubview:_name];
    _name.sd_layout
    .leftSpaceToView(self.contentView, SCREENWIDTH/2)
    .widthIs(250)
    .autoHeightRatio(0)
    .centerYEqualToView(self.contentView);
    
    CellLine
}


@end
