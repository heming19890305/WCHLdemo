//
//  ZWHDownClassifyView.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHDownClassifyView.h"

@implementation ZWHDownClassifyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self creatView];
}

//-(void)setText:(NSString *)text{
//    _textArray = [NSMutableArray array];
//    [_textArray addObject:@"0"];
//    [_textArray addObject:@"0"];
//    [_textArray addObject:@"0"];
//    [self removeAllSubviews];
//    [self creatView];
//}

-(void)setWorkmodel:(ZWHMyWorkModel *)workmodel{
    _workmodel = workmodel;
    _textArray = [NSMutableArray array];
    [_textArray addObject:_workmodel.scorePrice==nil?@"":_workmodel.scorePrice];
    [_textArray addObject:_workmodel.scoreNumber==nil?@"":_workmodel.scoreNumber];
    NSLog(@"_________-textArray = %@", _textArray);
    NSLog(@"_________-scorePrice = %@", _workmodel.scorePrice);
    [_textArray addObject:_workmodel.scoreMarket==nil?@"":_workmodel.scoreMarket];
    [self removeAllSubviews];
    [self creatView];
}

-(void)creatView{
    CGFloat wid = (SCREENWIDTH)/4;
    CGFloat hig = wid*0.8;
    //NSArray * dataArray = @[@"商城",@"钱包",@"封坛酒",@"商脉圈",@"个性定制",@"充值",@"提现",@"微超货柜"];
    for (NSInteger i=0; i<_dataArray.count; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view.sd_layout
        .leftSpaceToView(self, wid* (i%4))
        .topSpaceToView(self, WIDTH_TO(20)+(hig + HEIGHT_TO(20))*(i/4))
        .heightIs(hig)
        .widthIs(wid);
        
        
        
        
        /*UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(_dataArray[i])];
        [view addSubview:img];
        img.sd_layout
        .centerXEqualToView(view)
        .topSpaceToView(view, 0)
        .widthIs(wid/3)
        .heightIs(wid/3);*/
        
        UIButton *imgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imgbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [imgbtn setTitleColor:[UIColor grayColor] forState:0];
        imgbtn.titleLabel.font = FontWithSize(13);
        [view addSubview:imgbtn];
        if (i == 0) {
            [imgbtn setBackgroundImage:ImageNamed(@"gongfen") forState:0];
            //[imgbtn setImage:ImageNamed(@"gongfen") forState:0];
            imgbtn.sd_layout
            .centerXEqualToView(view)
            .topSpaceToView(view, 0)
            .widthIs(wid/3)
            .heightIs(wid/3);
        }else{
            if (_textArray.count > 0) {
                [imgbtn setTitle:_textArray[i-1] forState:0];
            }
            imgbtn.sd_layout
            .centerXEqualToView(view)
            .topSpaceToView(view, 0)
            .widthRatioToView(view, 1)
            .heightIs(wid/3);
        }
        
        
        
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        lab.text = _dataArray[i];
        [view addSubview:lab];
        lab.sd_layout
        .topSpaceToView(imgbtn, HEIGHT_TO(6))
        .centerXEqualToView(imgbtn)
        .autoHeightRatio(0);
        [lab setSingleLineAutoResizeWithMaxWidth:200];
        [lab updateLayout];
        if (i == 0) {
            UIImageView *lineimg = [[UIImageView alloc]initWithImage:ImageNamed(@"w_tiao")];
            [view addSubview:lineimg];
            lineimg.sd_layout
            .rightSpaceToView(view, 0)
            .topEqualToView(imgbtn)
            .bottomEqualToView(lab)
            .widthIs(4);
        }
        
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
