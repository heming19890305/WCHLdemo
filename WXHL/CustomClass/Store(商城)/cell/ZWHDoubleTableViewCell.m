//
//  ZWHDoubleTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHDoubleTableViewCell.h"

@implementation ZWHDoubleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}


-(void)creatView{
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab.text = @"订单编号：";
    [self.contentView addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(14))
    .autoHeightRatio(0);
    [lab setSingleLineAutoResizeWithMaxWidth:200];
    [lab updateLayout];
    
    UILabel *lab1 = [[UILabel alloc]init];
    [lab1 textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab1.text = @"下单时间：";
    [self.contentView addSubview:lab1];
    lab1.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(lab, HEIGHT_TO(9))
    .autoHeightRatio(0);
    [lab1 setSingleLineAutoResizeWithMaxWidth:200];
    [lab1 updateLayout];
    
    _num = [[UILabel alloc]init];
    [_num textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _num.text = @"449199948";
    [self.contentView addSubview:_num];
    _num.sd_layout
    .leftSpaceToView(lab, WIDTH_TO(0))
    .centerYEqualToView(lab)
    .autoHeightRatio(0);
    [_num setSingleLineAutoResizeWithMaxWidth:200];
    [_num updateLayout];
    
    _time = [[UILabel alloc]init];
    [_time textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _time.text = @"2017-08-15 13:32:09";
    [self.contentView addSubview:_time];
    _time.sd_layout
    .leftSpaceToView(lab1, WIDTH_TO(0))
    .centerYEqualToView(lab1)
    .autoHeightRatio(0);
    [_time setSingleLineAutoResizeWithMaxWidth:200];
    [_time updateLayout];
    
    CellLine
}
@end
