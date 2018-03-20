//
//  ZWHHomeCollectionViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHHomeCollectionViewCell.h"

@implementation ZWHHomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)setModel:(ZWHGoodsModel *)model{
    _model = model;
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_model.masterImg]] placeholderImage:ImageNamed(DefautImageName)];
    _title.text = _model.name;
    _money.text = [NSString stringWithFormat:@"¥%@",_model.nowPrice];
    _intro.text = @"日销12件 赠工分360元";
    _intro.text = [NSString stringWithFormat:@"日销%@件  赠工分%@元",_model.saleNum,_model.giveScore==nil?@"0":_model.giveScore];
}


-(void)createView{
    _img = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    [self.contentView addSubview:_img];
    _img.sd_layout
    .widthEqualToHeight()
    .topSpaceToView(self.contentView, HEIGHT_TO(10))
    .heightIs(HEIGHT_TO(120))
    .centerXEqualToView(self.contentView);
    
    _title = [[UILabel alloc]init];
    [_title textFont:16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_title];
    _title.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(_img, HEIGHT_TO(10))
    .autoHeightRatio(0);
    [_title setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(180)];
    _title.text = @"贵州酒魂大师版";
    [_title updateLayout];
    
    _money = [[UILabel alloc]init];
    [_money textFont:18 textColor:[UIColor redColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_money];
    _money.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(_title, HEIGHT_TO(6))
    .autoHeightRatio(0);
    [_money setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(180)];
    _money.text = @"¥2688";
    [_money updateLayout];
    
    
    _intro = [[UILabel alloc]init];
    [_intro textFont:12 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_intro];
    _intro.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(_money, HEIGHT_TO(4))
    .autoHeightRatio(0);
    [_intro setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(180)];
    _intro.text = @"日销12件 赠工分360元";
    [_intro updateLayout];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setImage:ImageNamed(@"shoppingcart") forState:0];
    [self.contentView addSubview:_btn];
    _btn.sd_layout
    .centerYEqualToView(_money)
    .heightIs(HEIGHT_TO(30))
    .widthEqualToHeight()
    .rightSpaceToView(self.contentView, WIDTH_TO(6));
    
    _btn.hidden = YES;
}

@end
