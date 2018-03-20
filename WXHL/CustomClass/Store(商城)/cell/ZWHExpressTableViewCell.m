//
//  ZWHExpressTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHExpressTableViewCell.h"

@implementation ZWHExpressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)creatView{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"配送方式" forState:0];
    [_btn setTitleColor:ZWHCOLOR(@"646363") forState:0];
    [_btn setImage:ImageNamed(@"bottom_jt") forState:0];
    [_btn layoutButtonWithEdgeInsetsStyle:TWButtonEdgeInsetsStyleRight imageTitleSpace:5];
    _btn.titleLabel.font = FontWithSize(14);
    [self.contentView addSubview:_btn];
    _btn.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(self.contentView)
    .heightIs(HEIGHT_TO(40))
    .widthIs(WIDTH_TO(120));
    _btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _left = [[UILabel alloc]init];
    [_left textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _left.text = @"氨基酸大恒科技撒";
    [self.contentView addSubview:_left];
    _left.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0);
    
    [_left setSingleLineAutoResizeWithMaxWidth:200];
    [_left updateLayout];
    
    _left.hidden = YES;
    
    _right = [[UILabel alloc]init];
    [_right textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    _right.text = @"运费";
    [self.contentView addSubview:_right];
    _right.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0);
    
    [_right setSingleLineAutoResizeWithMaxWidth:200];
    [_right updateLayout];
    
    CellLine

}

@end
