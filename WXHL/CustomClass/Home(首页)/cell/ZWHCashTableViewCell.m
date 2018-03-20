//
//  ZWHCashTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHCashTableViewCell.h"

@implementation ZWHCashTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)creatView{
    _icon = [[UIImageView alloc]initWithImage:ImageNamed(@"gs")];
    //[self.contentView addSubview:_icon];
    _icon.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(self.contentView)
    .heightIs(HEIGHT_TO(40))
    .widthEqualToHeight();
    
    _type = [[UILabel alloc]init];
    [_type textFont:15 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _type.text = [UserManager bankname];
    [self.contentView addSubview:_type];
    _type.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_TO(15));
    
    _card = [[UILabel alloc]init];
    [_card textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    NSString *card = [UserManager cardNo];
    NSString *str = [card substringWithRange:NSMakeRange(card.length - 4, 4)];
    _card.text = @"尾号9880储蓄卡";
    _card.text = [NSString stringWithFormat:@"尾号%@储蓄卡",str];
    [self.contentView addSubview:_card];
    _card.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .bottomSpaceToView(self.contentView, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_TO(15));
    
}

@end
