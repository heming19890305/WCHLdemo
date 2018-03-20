//
//  ZWHKSixTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/17.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHKSixTableViewCell.h"


@implementation ZWHKSixTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.contentView removeAllSubviews];
    [self creatView];
}

-(void)creatView{
    CGFloat wid = (SCREENWIDTH - WIDTH_TO(30))/2;
    for (NSInteger i = 0; i < _titArray.count; i ++) {
        UILabel *top = [[UILabel alloc]init];
        [top textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        if (_titArray.count > 0) {
            top.text = _titArray[i];
        }
        [self.contentView addSubview:top];
        top.sd_layout
        .leftSpaceToView(self.contentView, (wid+ WIDTH_TO(15))*(i%2) + WIDTH_TO(15))
        .topSpaceToView(self.contentView, HEIGHT_TO(20) + HEIGHT_TO(25)*(i/2))
        .autoHeightRatio(0);
        [top setSingleLineAutoResizeWithMaxWidth:100];
        [top updateLayout];
        
        UILabel *data = [[UILabel alloc]init];
        [data textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        if (_dataArray.count > 0) {
            data.text = _dataArray[i];
            NSLog(@"+++++++++=:%@",_dataArray);
        }
        [self.contentView addSubview:data];
        data.sd_layout
        .leftSpaceToView(top, WIDTH_TO(8))
        .centerYEqualToView(top)
        .autoHeightRatio(0);
        [data setSingleLineAutoResizeWithMaxWidth:wid - top.frame.size.width ];
        [data updateLayout];
        
    }
    
    CellLine;
}


@end
