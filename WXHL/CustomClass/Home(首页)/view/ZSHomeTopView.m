//
//  ZSHomeTopView.m
//  XGB
//
//  Created by ZS on 2017/8/21.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "ZSHomeTopView.h"

@implementation ZSHomeTopView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        self.backgroundColor = ZWHCOLOR(@"3990dd");
    }
    return self;
}

- (void)createView{
    
    self.cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cityBtn.backgroundColor = [UIColor clearColor];
    [self.cityBtn setImage:ImageNamed(@"qrcode") forState:0];
    [self addSubview:self.cityBtn];
    
    self.cityBtn.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .widthIs(WIDTH_TO(30))
    .heightIs(WIDTH_TO(30))
    .bottomSpaceToView(self, 8);
    
    _searchB = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchB.backgroundColor = ZWHCOLOR(@"2c7ecf");
    [self addSubview:_searchB];
    _searchB.sd_layout
    .leftSpaceToView(_cityBtn, WIDTH_TO(15))
    .centerYEqualToView(_cityBtn)
    .heightIs(32)
    .widthIs(WIDTH_TO(256));
    _searchB.layer.cornerRadius = 5;
    _searchB.layer.masksToBounds = YES;
    
    UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"search")];
    [_searchB addSubview:img];
    img.sd_layout
    .leftSpaceToView(_searchB, WIDTH_TO(8))
    .centerYEqualToView(_searchB)
    .widthIs(15)
    .heightIs(15);
    
    self.moreB = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreB.backgroundColor = [UIColor clearColor];
    [self.moreB setImage:ImageNamed(@"menu") forState:0];
    [self addSubview:self.moreB];
    
    self.moreB.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .widthIs(WIDTH_TO(30))
    .heightIs(WIDTH_TO(30))
    .centerYEqualToView(_cityBtn);
    
}



@end
