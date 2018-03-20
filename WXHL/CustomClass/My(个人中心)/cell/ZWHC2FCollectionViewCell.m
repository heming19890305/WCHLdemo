//
//  ZWHC2FCollectionViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHC2FCollectionViewCell.h"

@implementation ZWHC2FCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)createView{
    _img = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    _img.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_img];
    _img.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(HEIGHT_TO(150));
    
    _title = [[UILabel alloc]init];
    [_title textFont:16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_title];
    _title.sd_layout
    .centerXEqualToView(_img)
    .topSpaceToView(_img, HEIGHT_TO(5))
    .autoHeightRatio(0);
    [_title setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(180)];
    _title.text = @"封坛酒";
    [_title updateLayout];
    
    
}


@end
