//
//  ZWHConsumeView.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHConsumeView.h"

@implementation ZWHConsumeView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];
    }
    return self;
}

-(void)creatView{
    _money = [[UILabel alloc]init];
    [_money textFont:25 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    _money.text = @"-899.00";
    [self addSubview:_money];
    _money.sd_layout
    .topSpaceToView(self, HEIGHT_TO(32))
    .centerXEqualToView(self)
    .widthIs(SCREENWIDTH)
    .autoHeightRatio(0);
    
    _statetype = [[UILabel alloc]init];
    [_statetype textFont:17 textColor:Color(235, 163, 83) backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    _statetype.text = @"等待确认收货";
    [self addSubview:_statetype];
    _statetype.sd_layout
    .topSpaceToView(_money, HEIGHT_TO(12))
    .centerXEqualToView(self)
    .widthIs(SCREENWIDTH)
    .autoHeightRatio(0);
}

@end
