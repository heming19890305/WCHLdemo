//
//  ZWHLogisticsTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHLogisticsTableViewCell.h"

@implementation ZWHLogisticsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}


-(void)creatView{
    _img = [[UIImageView alloc]init];
    _img.backgroundColor = LINECOLOR;
    _img.layer.cornerRadius = HEIGHT_TO(15)/2;
    _img.layer.masksToBounds = YES;
    [self.contentView addSubview:_img];
    _img.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(24))
    .heightIs(HEIGHT_TO(15))
    .widthEqualToHeight();
    
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = LINECOLOR;
    [self.contentView addSubview:line];
    line.sd_layout
    .centerXEqualToView(_img)
    .topSpaceToView(_img, 0)
    .bottomEqualToView(self.contentView)
    .widthIs(1);
    
    _topline= [[UIImageView alloc]init];
    _topline.backgroundColor = LINECOLOR;
    [self.contentView addSubview:_topline];
    _topline.sd_layout
    .centerXEqualToView(_img)
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(_img, 0)
    .widthIs(1);
    
    _intro = [[UILabel alloc]init];
    [_intro textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _intro.text = @"阿斯加德黑科技爱神的箭卡号是的科技爱好看书就还是大家哈市科技电话卡机";
    [self.contentView addSubview:_intro];
    _intro.sd_layout
    .leftSpaceToView(_img, WIDTH_TO(28))
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(24))
    .autoHeightRatio(0);
    
    [_intro setMaxNumberOfLinesToShow:3];
    
    UIImageView *botline = [[UIImageView alloc]init];
    botline.backgroundColor = LINECOLOR;
    [self.contentView addSubview:botline];
    botline.sd_layout
    .leftEqualToView(_intro)
    .rightEqualToView(_intro)
    .heightIs(1)
    .bottomEqualToView(self.contentView);
    
    
}

@end
