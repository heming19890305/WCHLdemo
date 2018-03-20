//
//  ZWHOrderAdressTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHOrderAdressTableViewCell.h"

@implementation ZWHOrderAdressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setAddressmodel:(ZWHAddressModel *)addressmodel{
    _addressmodel = addressmodel;
    _name.text = [NSString stringWithFormat:@"收货人：%@",_addressmodel.name];
    _phone.text = _addressmodel.phone;
    _address.text = [NSString stringWithFormat:@"%@%@",[addressmodel.zoneName stringByReplacingOccurrencesOfString:@"," withString:@""],_addressmodel.address];
}

-(void)setOrdermodel:(ZWHOrderModel *)ordermodel{
    _ordermodel = ordermodel;
    _name.text = [NSString stringWithFormat:@"收货人：%@",_ordermodel.contacts];
    _phone.text = _ordermodel.phone;
    _address.text = _ordermodel.address;
}

-(void)creatView{
    UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"dizhi")];
    [self.contentView addSubview:img];
    img.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(20))
    .widthEqualToHeight()
    .centerYEqualToView(self.contentView);
    
    _name = [[UILabel alloc]init];
    [_name textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _name.text = @"收货人：何明";
    [self.contentView addSubview:_name];
    _name.sd_layout
    .leftSpaceToView(img, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(15))
    .autoHeightRatio(0);
    [_name setSingleLineAutoResizeWithMaxWidth:HEIGHT_TO(200)];
    [_name updateLayout];
    
    _phone = [[UILabel alloc]init];
    [_phone textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    _phone.text = @"18875062213";
    [self.contentView addSubview:_phone];
    _phone.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .centerYEqualToView(_name)
    .autoHeightRatio(0);
    [_phone setSingleLineAutoResizeWithMaxWidth:HEIGHT_TO(200)];
    [_phone updateLayout];
    
    
    _address = [[UILabel alloc]init];
    [_address textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _address.text = @"银河系地球大陆亚洲东亚中国四川成都高新环球中心7楼右转最里";
    [self.contentView addSubview:_address];
    _address.sd_layout
    .leftSpaceToView(img, WIDTH_TO(15))
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(_name, HEIGHT_TO(13))
    .autoHeightRatio(0);
    [_address setMaxNumberOfLinesToShow:1];
    [_address updateLayout];
    
    _rigimg = [[UIImageView alloc]initWithImage:ImageNamed(@"right_t")];
    [self.contentView addSubview:_rigimg];
    _rigimg.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(17.5))
    .widthEqualToHeight()
    .topSpaceToView(_phone, HEIGHT_TO(8));
    
    _rigimg.hidden = YES;
    
    CellLine
}

-(void)showright:(BOOL)bol{
    if (bol) {
        _rigimg.hidden = NO;
        _address.sd_layout
        .leftEqualToView(_name)
        .rightSpaceToView(_rigimg, WIDTH_TO(6))
        .topSpaceToView(_name, HEIGHT_TO(13))
        .autoHeightRatio(0);
        
        [_address updateLayout];
    }
}

@end
