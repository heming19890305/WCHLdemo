//
//  ZWHHomeMidView.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHHomeMidView.h"

@implementation ZWHHomeMidView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self creatView];
}

-(void)creatView{
    CGFloat wid = (SCREENWIDTH)/4;
    CGFloat hig = wid*0.7;
    //NSArray * dataArray = @[@"商城",@"钱包",@"封坛酒",@"商脉圈",@"个性定制",@"充值",@"提现",@"微超货柜"];
    for (NSInteger i=0; i<_dataArray.count; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view.sd_layout
        .leftSpaceToView(self, wid* (i%4))
        .topSpaceToView(self, HEIGHT_TO(10)+(hig + HEIGHT_TO(10))*(i/4))
        .heightIs(hig)
        .widthIs(wid);
        
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(_dataArray[i])];
        [view addSubview:img];
        img.sd_layout
        .centerXEqualToView(view)
        .topSpaceToView(view, 0)
        .widthIs(wid/2*0.9)
        .heightIs(wid/2*0.9);
        
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:16 textColor:ZWHCOLOR(@"333333") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        lab.text = [_dataArray[i] stringByReplacingOccurrencesOfString:@"_1" withString:@""];
        [view addSubview:lab];
        lab.sd_layout
        .topSpaceToView(img, HEIGHT_TO(6))
        .centerXEqualToView(img)
        .autoHeightRatio(0);
        [lab setSingleLineAutoResizeWithMaxWidth:200];
        [lab updateLayout];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(benclicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        btn.sd_layout
        .leftEqualToView(view)
        .topEqualToView(view)
        .bottomEqualToView(view)
        .rightEqualToView(view);
    }
    
    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = LINECOLOR;
    [self addSubview:lineview];
    lineview.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(1);
}


-(void)benclicked:(UIButton *)sender{
    if (_didClicked) {
        _didClicked(sender.tag);
    }
}

@end
