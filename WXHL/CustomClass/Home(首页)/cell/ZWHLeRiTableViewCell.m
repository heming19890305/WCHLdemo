//
//  ZWHLeRiTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHLeRiTableViewCell.h"

@implementation ZWHLeRiTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)creatView{
    _type = [[UILabel alloc]init];
    _type.text = @"充值到余额";
    [_type textFont:17 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_type];
    _type.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    
    _yue = [[UILabel alloc]init];
    _yue.text = @"余额：2000";
    [_yue textFont:15. textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_yue];
    _yue.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0)
    .leftSpaceToView(_type, WIDTH_TO(10));
    
    [_yue setMaxNumberOfLinesToShow:2];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = LINECOLOR;
    [self.contentView addSubview:_line];
    _line.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(1)
    .bottomEqualToView(self.contentView);
    
    _line.hidden = YES;
}

@end
