//
//  ZWHMyheaderView.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHMyheaderView.h"
#import "ZWHMyclassifyView.h"

@interface ZWHMyheaderView()


@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *idcard;


@end

@implementation ZWHMyheaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHMyModel *)model{
    _model = model;
    _name.text = _model.nickName==nil?@"暂未填写":_model.nickName;
    _idcard.text = _model.consumerNo==nil?@"":_model.consumerNo;
    [_certify setTitle:_model.idCard==nil?@"未实名认证":@"已实名认证" forState:0];
    if ([_model.idStatus isEqualToString:@"0"]) {
        if (_model.idCard == nil) {
            [_certify setTitle:@"待审核" forState:0];
        }
    }
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_model.face==nil?@"":_model.face]] placeholderImage:ImageNamed(@"logo")];
}

-(void)creatView{
    UIImageView *backimg = [[UIImageView alloc]initWithImage:ImageNamed(@"top_bj1")];
    backimg.userInteractionEnabled = YES;
    [self addSubview:backimg];
    backimg.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .heightIs(HEIGHT_TO(160));
    
    _rigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rigBtn.backgroundColor = [UIColor clearColor];
    [_rigBtn setImage:ImageNamed(@"menu") forState:0];
    [self addSubview:_rigBtn];
    _rigBtn.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .widthIs(WIDTH_TO(30))
    .heightIs(WIDTH_TO(30))
    .topSpaceToView(self, (44 - HEIGHT_TO(30))/2+STATES_HEIGHT);
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingBtn.backgroundColor = [UIColor clearColor];
    [_settingBtn setImage:ImageNamed(@"shezhi") forState:0];
    [self addSubview:_settingBtn];
    _settingBtn.sd_layout
    .rightSpaceToView(_rigBtn, WIDTH_TO(15))
    .widthIs(WIDTH_TO(30))
    .heightIs(WIDTH_TO(30))
    .topSpaceToView(self, (44 - HEIGHT_TO(30))/2+STATES_HEIGHT);
    
    _icon = [[UIImageView alloc]initWithImage:ImageNamed(DefautImageName)];
    _icon.layer.cornerRadius = HEIGHT_TO(70)/2;
    _icon.layer.masksToBounds = YES;
    _icon.image = ImageNamed(DefautImageName);
    _icon.backgroundColor = [UIColor whiteColor];
    [self addSubview:_icon];
    _icon.sd_layout
    .topSpaceToView(self, HEIGHT_TO(40)+STATES_HEIGHT)
    .leftSpaceToView(self, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(70))
    .widthEqualToHeight();
    
    _idcard = [[UILabel alloc]init];
    [_idcard textFont:16 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _idcard.text = @"请登录";
    [self addSubview:_idcard];
    _idcard.sd_layout
    .topSpaceToView(self, HEIGHT_TO(50)+STATES_HEIGHT)
    .leftSpaceToView(_icon, WIDTH_TO(6))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(200));
    
    _name = [[UILabel alloc]init];
    [_name textFont:15 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _name.text = @"";
    [self addSubview:_name];
    _name.sd_layout
    .topSpaceToView(_idcard, HEIGHT_TO(10))
    .leftSpaceToView(_icon, WIDTH_TO(6))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(200));
    
    _certify = [UIButton buttonWithType:UIButtonTypeCustom];
    _certify.layer.cornerRadius = HEIGHT_TO(25)/2;
    _certify.layer.masksToBounds = YES;
    //_certify.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _certify.titleLabel.font = FontWithSize(13);
    _certify.backgroundColor = Color(110, 178, 246);
    //_certify.backgroundColor = [UIColor clearColor];
    [_certify setTitle:@"未实名认证" forState:0];
    [self addSubview:_certify];
    _certify.sd_layout
    .rightSpaceToView(self, -HEIGHT_TO(25)/2)
    .bottomEqualToView(_icon)
    .heightIs(HEIGHT_TO(25))
    .widthIs(WIDTH_TO(115));
    
    [self addSubview:self.upview];
    MJWeakSelf
    self.upview.didClicked = ^(NSInteger idx) {
        if (weakSelf.getindex) {
            weakSelf.getindex(idx);
        }
    };
    
    [self addSubview:self.downview];
    UIView *lingview = [[UIView alloc]init];
    lingview.backgroundColor = LINECOLOR;
    [self addSubview:lingview];
    lingview.sd_layout
    .widthIs(SCREENWIDTH)
    .centerXEqualToView(self)
    .topSpaceToView(self.downview, 0)
    .heightIs(HEIGHT_TO(5));
    
    [self addSubview:self.bottomview];
    self.bottomview.didClicked = ^(NSInteger idx) {
        if (weakSelf.getbottomindex) {
            weakSelf.getbottomindex(idx);
        }
    };
    

}


-(ZWHMyclassifyView *)upview{
    if (!_upview) {
        CGFloat wid = (SCREENWIDTH)/4;
        CGFloat hig = wid*0.8;
        _upview = [[ZWHMyclassifyView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(160), SCREENWIDTH,hig+HEIGHT_TO(10))];
        _upview.dataArray = @[@"我的订单",@"待付款",@"待收货",@"待评价"];
    }
    return _upview;
}


-(ZWHDownClassifyView *)downview{
    if (!_downview) {
        CGFloat wid = (SCREENWIDTH)/4;
        CGFloat hig = wid*0.8;
        _downview = [[ZWHDownClassifyView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(160) + HEIGHT_TO(10)+hig, SCREENWIDTH,hig + HEIGHT_TO(10))];
        _downview.dataArray = @[@"我的工分",@"当前价格",@"工分数量",@"工分市值"];
    }
    return _downview;
}

-(ZWHMyMidView *)bottomview{
    if (!_bottomview) {
        CGFloat wid = (SCREENWIDTH)/4;
        CGFloat hig = wid*0.8;
        _bottomview = [[ZWHMyMidView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(160) + HEIGHT_TO(10)*2 + HEIGHT_TO(5) + hig*2, SCREENWIDTH, HEIGHT_TO(10)+hig)];
        _bottomview.dataArray = @[@"C2F专区",@"商脉圈_1",@"消费红利",@"消息中心"];
    }
    return _bottomview;
}
@end
