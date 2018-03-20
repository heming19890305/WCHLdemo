//
//  ZWHTextTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHTextTableViewCell.h"

@implementation ZWHTextTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHDrinkModel *)model{
    _model = model;
    _text.text = _model.remark==nil?@"":_model.remark;
}

-(void)creatView{
    _text = [[UILabel alloc]init];
    [_text textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_text];
    _text.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .autoHeightRatio(0)
    .topSpaceToView(self.contentView, HEIGHT_TO(8));
    
    [self setupAutoHeightWithBottomView:_text bottomMargin:7.5];
    
}


@end
