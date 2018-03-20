//
//  ZWHBuinessNorTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHBuinessNorTableViewCell.h"

@implementation ZWHBuinessNorTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labnumber = 4;
        _textArray = [NSMutableArray array];
        [self creatView];
    }
    return self;
}

-(void)setTextArray:(NSMutableArray *)textArray{
    _textArray = textArray;
    [self.contentView removeAllSubviews];
    [self creatView];
}

-(void)creatView{
    _topline = [[UIView alloc]init];\
    _topline.backgroundColor = LINECOLOR; \
    [self.contentView addSubview:_topline]; \
    _topline.sd_layout  \
    .leftEqualToView(self.contentView) \
    .rightEqualToView(self.contentView)  \
    .topEqualToView(self.contentView)  \
    .heightIs(1);
    _topline.hidden = YES;
    
    for (NSInteger i = 0; i < _labnumber; i++) {
        CGFloat wid = SCREENWIDTH/_labnumber;
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(self.contentView, wid*i)
        .topSpaceToView(self.contentView, 0)
        .heightIs(HEIGHT_TO(50))
        .widthIs(wid);
        
        if (_textArray.count == _labnumber) {
            lab.text = _textArray[i];
        }
    }
    
    CellLine
}

@end
