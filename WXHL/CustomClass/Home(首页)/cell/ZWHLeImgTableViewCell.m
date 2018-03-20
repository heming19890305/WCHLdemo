//
//  ZWHLeImgTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHLeImgTableViewCell.h"

@implementation ZWHLeImgTableViewCell

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
    [_type textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_type];
    _type.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0)
    .widthIs(200);
    
    _img = [[UIImageView alloc]initWithImage:ImageNamed(DefautImageName)];
    [self.contentView addSubview:_img];
    _img.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(self.contentView)
    .heightIs(HEIGHT_TO(40))
    .widthEqualToHeight();
    [_img updateLayout];
    _img.layer.cornerRadius = HEIGHT_TO(40) / 2;
    _img.layer.masksToBounds = YES;
}


@end
