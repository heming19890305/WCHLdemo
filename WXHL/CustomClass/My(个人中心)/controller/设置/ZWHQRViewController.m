//
//  ZWHQRViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHQRViewController.h"
#import "JQScanWrapper.h"


@interface ZWHQRViewController ()

@property(nonatomic,strong)UIImageView *icon;

@property(nonatomic,strong)UILabel *num;

@property(nonatomic,strong)UIImageView *qrimg;

@end

@implementation ZWHQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
}

-(void)creatView{
    self.view.backgroundColor = GRAYBACKCOLOR;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .rightSpaceToView(self.view, WIDTH_TO(15))
    .topSpaceToView(self.view, HEIGHT_TO(30))
    .heightIs(HEIGHT_TO(450));
    
    ZWHMyModel *model = [UserManager sharedData].mymodel;
    _icon = [[UIImageView alloc]initWithImage:ImageNamed(DefautImageName)];
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],model.face]]];
    _icon.layer.cornerRadius = HEIGHT_TO(50)/2;
    _icon.layer.masksToBounds = YES;
    [view addSubview:_icon];
    _icon.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .topSpaceToView(view, HEIGHT_TO(15))
    .heightIs(HEIGHT_TO(50))
    .widthEqualToHeight();
    
    _num = [[UILabel alloc]init];
    [_num textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _num.text = @"消费商号：";
    _num.text = [NSString stringWithFormat:@"消费商号：%@",model.consumerNo];
    [view addSubview:_num];
    _num.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(8))
    .rightSpaceToView(view, 0)
    .centerYEqualToView(_icon)
    .autoHeightRatio(0);
    
    _qrimg = [[UIImageView alloc]initWithImage:ImageNamed(DefautImageName)];

    [view addSubview:_qrimg];
    _qrimg.sd_layout
    .leftSpaceToView(view, WIDTH_TO(20))
    .topSpaceToView(_icon, HEIGHT_TO(20))
    .rightSpaceToView(view, HEIGHT_TO(20))
    .bottomSpaceToView(view, HEIGHT_TO(20));
    
    _qrimg.contentMode = UIViewContentModeCenter;
    
    [_qrimg updateLayout];
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    lab.text = @"扫一扫上面的二维码图案，加入我的商圈";
    [self.view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .rightSpaceToView(self.view, WIDTH_TO(15))
    .topSpaceToView(view, HEIGHT_TO(10))
    .autoHeightRatio(0);
    
    _qrimg.image = [JQScanWrapper createQRWithString:[UserManager account] size:CGSizeMake(WIDTH_TO(300), HEIGHT_TO(300))];
    

}



@end
