//
//  ZWHConsumeTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHConsumeTableViewCell.h"

@implementation ZWHConsumeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)setModel:(ZWHComsumModel *)model{
    _model = model;
    _day.text = [self getTheDayOfTheWeekByDateString:_model.createDate];
    _date.text = _model.createDate;
    _money.text = [NSString stringWithFormat:@"-%@",_model.payMoney];
    _name.text = [NSString stringWithFormat:@"[%@]",[UserManager dealWith:_model.goodsName with:@","]];
}

-(NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString{
    
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *formatterDate=[inputFormatter dateFromString:dateString];
    
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    
    return [weekArray objectAtIndex:0];
}

-(void)creatView{
    _day = [[UILabel alloc]init];
    [_day textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_day];
    _day.text = @"周一";
    _day.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .topSpaceToView(self.contentView, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(90));
    
    
    
    _date = [[UILabel alloc]init];
    [_date textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_date];
    _date.text = @"08-21";
    _date.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .bottomSpaceToView(self.contentView, HEIGHT_TO(10))
    .autoHeightRatio(0);
    [_date setSingleLineAutoResizeWithMaxWidth:200];
    [_date updateLayout];
    
    
    _name = [[UILabel alloc]init];
    [_name textFont:15 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_name];
    _name.text = @"贵州窖酒";
    _name.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_TO(15))
    .bottomSpaceToView(self.contentView, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    [_name setMaxNumberOfLinesToShow:1];
    
    _money = [[UILabel alloc]init];
    [_money textFont:17 textColor:MAINCOLOR backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_money];
    _money.text = @"-899.00";
    _money.sd_layout
    .rightEqualToView(_name)
    .topSpaceToView(self.contentView, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    
    
    CellLine
}

@end
