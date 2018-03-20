//
//  ZWHShopCarTableViewCell.m
//  WLStore
//
//  Created by Syrena on 2017/10/30.
//  Copyright © 2017年 yuanSheng. All rights reserved.
//

#import "ZWHShopCarTableViewCell.h"

@interface ZWHShopCarTableViewCell()
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UILabel *titleL;
@property(nonatomic,strong)UILabel *introL;
@property(nonatomic,strong)UILabel *moneyL;
@property(nonatomic,strong)UILabel *numberL;
@property(nonatomic,strong)UILabel *workL;

@end

@implementation ZWHShopCarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)setModel:(ZWHGoodsModel *)model{
    _model = model;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_model.thumbnail]]];
    _titleL.text = _model.goodname;
    _moneyL.text = [NSString stringWithFormat:@"¥%@",_model.price];
    _numberL.text = _model.num;
    _workL.text = [NSString stringWithFormat:@"工分：%@",_model.givescore];
    
    
    _introL.text = [NSString stringWithFormat:@"商品规格:%@",(_model.attributes==nil||[_model.attributes isEqualToString:@""])?@"无":_model.attributes];
}


-(void)createView{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setBackgroundImage:ImageNamed(@"a") forState:0];
    [_selectBtn setBackgroundImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBtn];
    _selectBtn.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_PRO(15))
    .widthIs(WIDTH_PRO(18.5))
    .heightIs(HEIGHT_PRO(18.5))
    .centerYEqualToView(self.contentView);
    
    _imgV = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    _imgV.layer.cornerRadius = 5;
    _imgV.layer.masksToBounds = YES;
    [self.contentView addSubview:_imgV];
    _imgV.sd_layout
    .leftSpaceToView(_selectBtn, WIDTH_PRO(14))
    .topSpaceToView(self.contentView, HEIGHT_PRO(17))
    .widthIs(WIDTH_PRO(104))
    .heightIs(HEIGHT_PRO(85));
    
    _titleL = [[UILabel alloc]init];
    [_titleL textFont:14 textColor:ZWHCOLOR(@"434343") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _titleL.text = @"IPR 12 - 15款 A6L 全LED大灯呵呵呵呵呵呵呵呵呵呵呵呵";
    
    [self.contentView addSubview:_titleL];
    _titleL.sd_layout
    .leftSpaceToView(_imgV, WIDTH_PRO(16))
    .topSpaceToView(self.contentView, HEIGHT_PRO(22.5))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_PRO(15));
    
    [_titleL setMaxNumberOfLinesToShow:1];
    
    _introL = [[UILabel alloc]init];
    [_introL textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _introL.text = @"产品规格：IPR 12 - 15款 A6L 全LED大灯呵呵呵呵呵呵呵呵呵呵呵呵";
    [self.contentView addSubview:_introL];
    _introL.sd_layout
    .leftSpaceToView(_imgV, WIDTH_PRO(16))
    .topSpaceToView(_titleL, HEIGHT_PRO(6))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_PRO(15));
    
    [_introL setMaxNumberOfLinesToShow:1];
    
    _workL = [[UILabel alloc]init];
    [_workL textFont:13 textColor:ZWHCOLOR(@"6f6f6f") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _workL.text = @"工分：0";
    [self.contentView addSubview:_workL];
    _workL.sd_layout
    .leftSpaceToView(_imgV, WIDTH_PRO(16))
    .topSpaceToView(_introL, HEIGHT_PRO(6))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_PRO(15));
    
    [_workL setMaxNumberOfLinesToShow:1];
    
    UIButton *addb = [UIButton buttonWithType:UIButtonTypeCustom];
    [addb setImage:ImageNamed(@"加") forState:0];
    [addb addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addb];
    addb.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_PRO(15))
    .bottomSpaceToView(self.contentView, HEIGHT_PRO(10))
    .widthIs(WIDTH_PRO(20))
    .heightIs(HEIGHT_PRO(20));
    
    _numberL = [[UILabel alloc]init];
    [_numberL textFont:12 textColor:ZWHCOLOR(@"292929") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    _numberL.text = @"1";
   // _numberL.layer.borderWidth = 0.2;
   // _numberL.layer.borderColor = ZWHCOLOR(@"6f6f6f").CGColor;
    [self.contentView addSubview:_numberL];
    _numberL.sd_layout
    .rightSpaceToView(addb, 0)
    .centerYEqualToView(addb)
    .widthIs(WIDTH_PRO(41.5))
    .heightIs(HEIGHT_PRO(20));
    
    UIButton *dercerb = [UIButton buttonWithType:UIButtonTypeCustom];
    [dercerb setImage:ImageNamed(@"减-拷贝") forState:0];
    [dercerb addTarget:self action:@selector(dercerClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:dercerb];
    dercerb.sd_layout
    .rightSpaceToView(_numberL, 0)
    .centerYEqualToView(addb)
    .widthIs(WIDTH_PRO(20))
    .heightIs(HEIGHT_PRO(20));
    
    _moneyL = [[UILabel alloc]init];
    [_moneyL textFont:15 textColor:ZWHCOLOR(@"ff5b5b") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _moneyL.text = @"¥ 28000.00";
    [self.contentView addSubview:_moneyL];
    _moneyL.sd_layout
    .leftSpaceToView(_imgV, WIDTH_PRO(16))
    .centerYEqualToView(dercerb)
    .autoHeightRatio(0)
    .rightSpaceToView(dercerb, WIDTH_PRO(31));
    [_moneyL setMaxNumberOfLinesToShow:1];
}

-(void)addClicked{
    [self changeNum:[_model.num integerValue] + 1];
}

-(void)dercerClicked{
    if ([_model.num integerValue] == 1) {
        return;
    }
    [self changeNum:[_model.num integerValue] - 1];
}


-(void)changeNum:(NSInteger)number{
    [HttpHandler getchangeNum:@{@"id":_model.id,@"num":ZWHINTTOSTR(number)} Success:^(id obj) {
        if (ReturnValue == 200) {
            _model.num = ZWHINTTOSTR(number);
            _numberL.text = _model.num;
            NOTIFY_POST(@"shopSum");
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

@end
