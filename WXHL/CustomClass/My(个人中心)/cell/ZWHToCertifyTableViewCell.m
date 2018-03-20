//
//  ZWHToCertifyTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHToCertifyTableViewCell.h"

@implementation ZWHToCertifyTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = Color(251, 245, 208);
        [self createView];
    }
    return self;
}

-(void)createView{
    
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:ImageNamed(@"xf_gt")];
    [self.contentView addSubview:leftImage];
    leftImage.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_PRO(15))
    .heightRatioToView(self.contentView, 0.6)
    .widthEqualToHeight()
    .centerYEqualToView(self.contentView);
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:14 textColor:ZWHCOLOR(@"f08b2a") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab.text = @"为了资金安全，请立即实名认证";
    [self.contentView addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(leftImage, WIDTH_TO(10))
    .autoHeightRatio(0)
    .centerYEqualToView(self.contentView);
    [lab setSingleLineAutoResizeWithMaxWidth:300];
    [lab updateLayout];
    
    
    UIImageView *rig = [[UIImageView alloc]initWithImage:ImageNamed(@"xf_right")];
    [self.contentView addSubview:rig];
    rig.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(20))
    .centerYEqualToView(self.contentView)
    .heightIs(HEIGHT_TO(17.5))
    .widthEqualToHeight();

    
}

@end
