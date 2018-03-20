//
//  ZWHMessageTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHMessageTableViewCell.h"

@implementation ZWHMessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHMessageModel *)model{
    _model = model;
    _type.text = _model.type;
    _title.text = _model.title;
    _intro.text = _model.content;
    _time.text = _model.createDate;
    _red.hidden = [_model.isReaded integerValue]==1?YES:NO;
}

-(void)creatView{
    _type = [[UILabel alloc]init];
    [_type textFont:12 textColor:[UIColor whiteColor] backgroundColor:MAINCOLOR textAlignment:NSTextAlignmentLeft];
    _type.text = @"个人";
    _type.layer.cornerRadius = 3;
    _type.layer.masksToBounds = YES;
    [self.contentView addSubview:_type];
    _type.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(10))
    .autoHeightRatio(0);
    
    [_type setSingleLineAutoResizeWithMaxWidth:200];
    [_type updateLayout];
    
    _red = [[UIImageView alloc]init];
    _red.backgroundColor = [UIColor redColor];
    _red.layer.cornerRadius = HEIGHT_TO(6)/2;
    _red.layer.masksToBounds = YES;
    [self.contentView addSubview:_red];
    _red.sd_layout
    .leftSpaceToView(_type, -WIDTH_TO(3))
    .topSpaceToView(self.contentView, HEIGHT_TO(10)-HEIGHT_TO(5)/2)
    .widthIs(WIDTH_TO(6))
    .heightEqualToWidth();
    
    
    _title = [[UILabel alloc]init];
    [_title textFont:15 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _title.text = @"关于二维码调整通知";
    [self.contentView addSubview:_title];
    _title.sd_layout
    .leftSpaceToView(_type, WIDTH_TO(5))
    .topSpaceToView(self.contentView, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_TO(15));
    
    [_title setMaxNumberOfLinesToShow:1];
    
    _intro = [[UILabel alloc]init];
    [_intro textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _intro.text = @"关于二维码调整通知关于二维码调整通知关于二维码调整通知关于二维码调整通知关于二维码调整通知关于二维码调整通知关于二维码调整通知";
    [self.contentView addSubview:_intro];
    _intro.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(_title, HEIGHT_TO(15))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_TO(15));
    
    [_intro setMaxNumberOfLinesToShow:2];
    
    
    _time = [[UILabel alloc]init];
    [_time textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _time.text = @"2017-08-07";
    [self.contentView addSubview:_time];
    _time.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(_intro, HEIGHT_TO(15))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_TO(15));
    
    [_time setMaxNumberOfLinesToShow:1];
    
    CellLine
}



@end
