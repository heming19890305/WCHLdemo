//
//  ZWHAddressTableViewCell.m
//  WLStore
//
//  Created by Syrena on 2017/10/31.
//  Copyright © 2017年 yuanSheng. All rights reserved.
//

#import "ZWHAddressTableViewCell.h"

@interface ZWHAddressTableViewCell()
@property(nonatomic,strong)UILabel *lab;

@end

@implementation ZWHAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}


-(void)setModel:(ZWHAddressModel *)model{
    _model = model;
    _manL.text = [NSString stringWithFormat:@"收货人：%@",_model.name];
    _addressL.text = [NSString stringWithFormat:@"%@%@",[_model.zoneName stringByReplacingOccurrencesOfString:@"," withString:@""],_model.address];
    _phoneL.text = _model.phone;
}

-(void)createView{
    _manL = [[UILabel alloc]init];
    [_manL textFont:14 textColor:ZWHCOLOR(@"292929") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _manL.text = @"收货人：赵雪梅";
    [self.contentView addSubview:_manL];
    _manL.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_PRO(15))
    .topSpaceToView(self.contentView, HEIGHT_PRO(20))
    .autoHeightRatio(0);
    [_manL setSingleLineAutoResizeWithMaxWidth:250];
    [_manL updateLayout];
    
    _lab = [[UILabel alloc]init];
    [_lab textFont:14 textColor:ZWHCOLOR(@"292929") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _lab.text = @"收货地址：";
    [self.contentView addSubview:_lab];
    _lab.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_PRO(15))
    .topSpaceToView(_manL, HEIGHT_PRO(18))
    .autoHeightRatio(0);
    
    [_lab setSingleLineAutoResizeWithMaxWidth:200];
    [_lab updateLayout];
    
    _addressL = [[UILabel alloc]init];
    [_addressL textFont:14 textColor:ZWHCOLOR(@"292929") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _addressL.text = @"四川省成都市高新区环球中心N2区7楼右转最里面再左转右转";
    [self.contentView addSubview:_addressL];
    _addressL.sd_layout
    .leftSpaceToView(_lab, 0)
    .topSpaceToView(_manL, HEIGHT_PRO(18))
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, WIDTH_PRO(15));
    [_addressL setMaxNumberOfLinesToShow:2];
    [self setupAutoHeightWithBottomView:_addressL bottomMargin:5];
    
    _phoneL = [[UILabel alloc]init];
    [_phoneL textFont:14 textColor:ZWHCOLOR(@"292929") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    _phoneL.text = @"18875062213";
    [self.contentView addSubview:_phoneL];
    _phoneL.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_PRO(15))
    .topSpaceToView(self.contentView, HEIGHT_PRO(20))
    .autoHeightRatio(0);
    [_phoneL setSingleLineAutoResizeWithMaxWidth:250];
    [_phoneL updateLayout];
    
    _rightimage = [[UIImageView alloc]initWithImage:ImageNamed(@"更多_灰")];
    [self.contentView addSubview:_rightimage];
    _rightimage.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_PRO(15))
    .widthIs(WIDTH_PRO(20))
    .heightIs(20)
    .topSpaceToView(_manL, HEIGHT_PRO(18));
    
    _rightimage.hidden = YES;
    
    _bottomimage = [[UIImageView alloc]initWithImage:ImageNamed(@"heng")];
    [self.contentView addSubview:_bottomimage];
    _bottomimage.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(HEIGHT_PRO(5));
    
    _bottomimage.hidden = YES;
    //CellLine
}

-(void)showRightImage:(BOOL)bol{
    _rightimage.hidden = !bol;
    if (bol) {
        _addressL.sd_layout
        .leftSpaceToView(_lab, WIDTH_PRO(0))
        .topSpaceToView(_manL, HEIGHT_PRO(18))
        .autoHeightRatio(0)
        .rightSpaceToView(_rightimage, WIDTH_PRO(28.5));
    }else{
        _addressL.sd_layout
        .leftSpaceToView(_lab, WIDTH_PRO(0))
        .topSpaceToView(_manL, HEIGHT_PRO(18))
        .autoHeightRatio(0)
        .rightSpaceToView(self.contentView, WIDTH_PRO(15));
    }
    [_addressL updateLayout];
}

@end
