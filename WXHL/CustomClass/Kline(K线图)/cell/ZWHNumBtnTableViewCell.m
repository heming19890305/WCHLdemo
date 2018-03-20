//
//  ZWHNumBtnTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/17.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHNumBtnTableViewCell.h"

@implementation ZWHNumBtnTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
      NSLog(@"+++++dataArray++++=:%@",_dataArray);
    [self.contentView removeAllSubviews];
    [self creatView];
}

-(void)creatView{
    CGFloat wid = SCREENWIDTH/_titArray.count;
    for (NSInteger i = 0; i < _titArray.count; i ++) {
        UILabel *top = [[UILabel alloc]init];
        [top textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        if (_titArray.count > 0) {
            top.text = _titArray[i];
             NSLog(@"+++++titArray++++=:%@",_dataArray);
        }
        [self.contentView addSubview:top];
        top.sd_layout
        .leftSpaceToView(self.contentView, wid*i)
        .topSpaceToView(self.contentView, HEIGHT_TO(20))
        .autoHeightRatio(0)
        .widthIs(wid);
        
        UILabel *data = [[UILabel alloc]init];
        [data textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        if (_introColor) {
            data.textColor = _introColor;
        }
        if (_dataArray.count > 0) {
            data.text = _dataArray[i];
        }
        [self.contentView addSubview:data];
        data.sd_layout
        .leftSpaceToView(self.contentView, wid*i)
        .topSpaceToView(top, HEIGHT_TO(10))
        .autoHeightRatio(0)
        .widthIs(wid);
        
        if (i > 0) {
            UILabel *line = [[UILabel alloc]init];
            line.backgroundColor = LINECOLOR;
            [self.contentView addSubview:line];
            line.sd_layout
            .leftSpaceToView(self.contentView, wid*i)
            .topSpaceToView(self.contentView, HEIGHT_TO(10))
            .bottomSpaceToView(self.contentView, HEIGHT_TO(10))
            .widthIs(1);
        }
    }
    
    CellLine;
}

@end
