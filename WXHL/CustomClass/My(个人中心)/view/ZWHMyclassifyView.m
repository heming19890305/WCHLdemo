//
//  ZWHMyclassifyView.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHMyclassifyView.h"

@implementation ZWHMyclassifyView

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

-(void)setRedArray:(NSArray *)redArray{
    NSArray *imgArr = @[_img1,_img2,_img3];
    NSArray *redArr = @[_red1,_red2,_red3];
    NSArray *viewArr = @[_view1,_view2,_view3];
    for(NSInteger i=0;i<redArray.count;i++){
        NSString *str = redArray[i];
        UILabel *lab = redArr[i];
        UIView *view = viewArr[i];
        UIImageView *img = imgArr[i];
        if (str.length>0 && [str integerValue]>0) {
            lab.hidden = NO;
            lab.text = str;
            [lab textFont:10 textColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] textAlignment:NSTextAlignmentCenter];
            CGSize labsize = [lab.text sizeWithFont:FontWithSize(11) constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            lab.backgroundColor = [UIColor redColor];
            lab.sd_layout
            .leftSpaceToView(img, -6)
            .topSpaceToView(view, -6)
            .autoHeightRatio(0)
            .widthIs(labsize.width+8);
            [lab updateLayout];
            lab.layer.cornerRadius = lab.size.height/2;
            lab.layer.masksToBounds = YES;
        }else{
            lab.hidden = YES;
        }
    }
}

-(void)creatView{
    CGFloat wid = (SCREENWIDTH)/4;
    CGFloat hig = wid*0.8;
    //NSArray * dataArray = @[@"商城",@"钱包",@"封坛酒",@"商脉圈",@"个性定制",@"充值",@"提现",@"微超货柜"];
    _red1 = [[UILabel alloc]init];
    _red2 = [[UILabel alloc]init];
    _red3 = [[UILabel alloc]init];
    for (NSInteger i=0; i<_dataArray.count; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view.sd_layout
        .leftSpaceToView(self, wid* (i%4))
        .topSpaceToView(self, WIDTH_TO(20)+(hig + HEIGHT_TO(20))*(i/4))
        .heightIs(hig)
        .widthIs(wid);
        
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(_dataArray[i])];
        [view addSubview:img];
        img.sd_layout
        .centerXEqualToView(view)
        .topSpaceToView(view, 0)
        .widthIs(wid/3)
        .heightIs(wid/3);
        
        switch (i) {
            case 1:
            {
                _img1 = img;
                _view1 = view;
            }
                break;
            case 2:
            {
                _img2 = img;
                _view2 = view;
            }
                break;
            case 3:
            {
                _img3 = img;
                _view3 = view;
            }
                break;
            default:
                break;
        }
        
        if (i>0) {
            UILabel *lab;
            switch (i) {
                case 1:
                    lab = _red1;
                    break;
                case 2:
                    lab = _red2;
                    break;
                case 3:
                    lab = _red3;
                    break;
                default:
                    break;
            }
            lab.text = @"5";
            [lab textFont:10 textColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] textAlignment:NSTextAlignmentCenter];
            CGSize labsize = [lab.text sizeWithFont:FontWithSize(11) constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            lab.backgroundColor = [UIColor redColor];
            [view addSubview:lab];
            lab.sd_layout
            .leftSpaceToView(img, -6)
            .topSpaceToView(view, -6)
            .autoHeightRatio(0)
            .widthIs(labsize.width+4);
            [lab updateLayout];
            lab.layer.cornerRadius = lab.size.height/2;
            lab.layer.masksToBounds = YES;
            lab.hidden = YES;
        }
        
    
        
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        lab.text = _dataArray[i];
        [view addSubview:lab];
        lab.sd_layout
        .topSpaceToView(img, HEIGHT_TO(6))
        .centerXEqualToView(img)
        .autoHeightRatio(0);
        [lab setSingleLineAutoResizeWithMaxWidth:200];
        [lab updateLayout];
        
        if (i == 0) {
            UIImageView *lineimg = [[UIImageView alloc]initWithImage:ImageNamed(@"w_tiao")];
            [view addSubview:lineimg];
            lineimg.sd_layout
            .rightSpaceToView(view, 0)
            .topEqualToView(img)
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
