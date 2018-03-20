//
//  ZWHOrderHeaderView.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHOrderHeaderView.h"

@implementation ZWHOrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHOrderModel *)model{
    _model = model;
    _statename.text = _model.statusStr;
    _statename.sd_layout
    .leftSpaceToView(self, WIDTH_TO(28))
    .topSpaceToView(self, self.frame.size.height/2 - HEIGHT_TO(10))
    .autoHeightRatio(0);
    [_statename updateLayout];
    if ([_model.status integerValue]==3) {
        _img.image = ImageNamed(@"jiaoyiwc");
    }
}


-(void)setState:(NSString *)state{
    _state = state;
    if ([_state isEqualToString:@"1"]) {
        _statename.text = @"交易完成";
        _statename.sd_layout
        .leftSpaceToView(self, WIDTH_TO(28))
        .topSpaceToView(self, self.frame.size.height/2 - HEIGHT_TO(10))
        .autoHeightRatio(0);
        
        [_statename updateLayout];
        
        _time.hidden = YES;
        
        _img.image = ImageNamed(@"jiaoyiwc");
    }
}

-(void)creatView{
    UIImageView *backimg = [[UIImageView alloc]initWithImage:ImageNamed(@"lantiao_bj")];
    [self addSubview:backimg];
    backimg.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self);
    
    _statename = [[UILabel alloc]init];
    [_statename textFont:16 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _statename.text = @"等待买家付款";
    [self addSubview:_statename];
    _statename.sd_layout
    .leftSpaceToView(self, WIDTH_TO(28))
    .topSpaceToView(self, HEIGHT_TO(20))
    .autoHeightRatio(0);
    
    [_statename setSingleLineAutoResizeWithMaxWidth:200];
    [_statename updateLayout];
    
    _time = [[UILabel alloc]init];
    [_time textFont:12 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _time.text = @"剩2天19小时自动关闭";
    [self addSubview:_time];
    _time.sd_layout
    .leftSpaceToView(self, WIDTH_TO(28))
    .topSpaceToView(_statename, HEIGHT_TO(6))
    .autoHeightRatio(0);
    _time.hidden = YES;
    
    [_time setSingleLineAutoResizeWithMaxWidth:250];
    [_time updateLayout];
    
    _img = [[UIImageView alloc]initWithImage:ImageNamed(@"daifukuan")];
    [self addSubview:_img];
    _img.sd_layout
    .rightSpaceToView(self, WIDTH_TO(30))
    .heightRatioToView(self, 0.7)
    .widthEqualToHeight()
    .centerYEqualToView(self);
    
}

@end
