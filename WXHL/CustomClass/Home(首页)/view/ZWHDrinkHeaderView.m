//
//  ZWHDrinkHeaderView.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHDrinkHeaderView.h"

@implementation ZWHDrinkHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)setModel:(ZWHMyModel *)model{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_model.face]] placeholderImage:ImageNamed(DefautImageName)];
    _name.text = [NSString stringWithFormat:@"姓名：%@",_model.name];
    _num.text = [NSString stringWithFormat:@"团队编号：%@",_model.consumerNo];
   // 身份证号码：
    NSString *str = [NSString stringWithFormat:@"%@",_model.idCard];
    if (str.length > 10) {
        _card.text = [str stringByReplacingCharactersInRange:NSMakeRange(5, str.length - 10) withString:@"******"];
    }
    
}

-(void)createView{
    UIView *view = [[UIView alloc]init];
    view.layer.cornerRadius = HEIGHT_TO(70)/2;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = LINECOLOR.CGColor;
    view.layer.borderWidth = 1;
    [self addSubview:view];
    view.sd_layout
    .leftSpaceToView(self, WIDTH_TO(20))
    .topSpaceToView(self, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(70))
    .widthEqualToHeight();
    
    _icon = [[UIImageView alloc]initWithImage:ImageNamed(DefautImageName)];
    _icon.layer.cornerRadius = HEIGHT_TO(60)/2;
    _icon.layer.masksToBounds = YES;
    _icon.layer.borderColor = LINECOLOR.CGColor;
    _icon.layer.borderWidth = 1;
    [view addSubview:_icon];
    _icon.sd_layout
    .centerYEqualToView(view)
    .centerXEqualToView(view)
    .heightIs(HEIGHT_TO(60))
    .widthEqualToHeight();
    
    _name = [[UILabel alloc]init];
    [_name textFont:15 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    _name.text = @"姓名：";
    [self addSubview:_name];
    _name.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .rightSpaceToView(self, WIDTH_TO(15))
    .autoHeightRatio(0)
    .topSpaceToView(self, HEIGHT_TO(20));
    
    _num = [[UILabel alloc]init];
    [_num textFont:15 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    _num.text = @"团队编号：";
    [self addSubview:_num];
    _num.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .rightSpaceToView(self, WIDTH_TO(15))
    .autoHeightRatio(0)
    .topSpaceToView(_name, HEIGHT_TO(5));
    
    _idcard = [[UILabel alloc]init];
    [_idcard textFont:15 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    _idcard.text = @"身份证号码：";
    [self addSubview:_idcard];
    _idcard.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
//    .rightSpaceToView(_card, WIDTH_TO(0))
    .autoHeightRatio(0)
    .topSpaceToView(_num, HEIGHT_TO(5));
    
    _card = [[UILabel alloc]init];
    [_card textFont:15 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    _card.text = @"";
    [self addSubview:_card];
    _card.sd_layout
    .rightSpaceToView(self, WIDTH_TO(0))
    .leftSpaceToView(_idcard, -10)
    .autoHeightRatio(0)
    .topSpaceToView(_num, HEIGHT_TO(5));

    
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],[UserManager face]]] placeholderImage:ImageNamed(DefautImageName)];
    _name.text = [NSString stringWithFormat:@"姓名：%@",[UserManager nickName]];
    _num.text = [NSString stringWithFormat:@"团队编号：%@",[UserManager consumerNo]];
    NSString *str = [NSString stringWithFormat:@"%@",_model.idCard==nil?@"":_model.idCard];
    if (str.length > 10) {
        _idcard.text = [str stringByReplacingCharactersInRange:NSMakeRange(5, str.length - 10) withString:@"******"];
    }
   // _idcard.text = [NSString stringWithFormat:@"身份证号码：%@",[UserManager idCard]];
}

@end
