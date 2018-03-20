//
//  ZWHChoseAdreTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHChoseAdreTableViewCell.h"

@implementation ZWHChoseAdreTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)creatView{
    _addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addbtn setTitle:@"添加收货地址" forState:0];
    [_addbtn setTitleColor:[UIColor blackColor] forState:0];
    [_addbtn setImage:ImageNamed(@"dizhi") forState:0];
    _addbtn.titleLabel.font = FontWithSize(14);
    [self.contentView addSubview:_addbtn];
    _addbtn.sd_layout
    .widthIs(WIDTH_TO(130))
    .heightIs(HEIGHT_TO(35))
    .centerYEqualToView(self.contentView)
    .centerXEqualToView(self.contentView);
    
    _addbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

@end
