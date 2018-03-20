//
//  ZWHJudgeTableViewCell.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHJudgeTableViewCell.h"

@implementation ZWHJudgeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.btnArray = [NSMutableArray array];
        [self creatView];
    }
    return self;
}

-(void)creatView{
    _select = [UIButton buttonWithType:UIButtonTypeCustom];
    //_select.enabled = NO;
    [_select setBackgroundImage:ImageNamed(@"a") forState:0];
    [_select setBackgroundImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
    [self.contentView addSubview:_select];
    _select.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(25))
    .heightIs(HEIGHT_TO(20))
    .widthEqualToHeight()
    .centerYEqualToView(self.contentView);
    
    _icon = [[UIImageView alloc]init];;
    //_icon.enabled = NO;
    _icon.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:_icon];
    _icon.sd_layout
    .leftSpaceToView(_select, WIDTH_TO(6))
    .heightIs(HEIGHT_TO(20))
    .widthEqualToHeight()
    .centerYEqualToView(self.contentView);
    
    _title = [[UILabel alloc]init];
    [_title textFont:15 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _title.text = @"标题";
    [self.contentView addSubview:_title];
    _title.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(6))
    .autoHeightRatio(0)
    .centerYEqualToView(self.contentView);
    [_title setSingleLineAutoResizeWithMaxWidth:150];
    [_title updateLayout];
    
    
    /*_title = [[UILabel alloc]init];
    [_title textFont:15 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _title.text = @"标题标题";
    [self.contentView addSubview:_title];
    _title.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_TO(15))
    .autoHeightRatio(0)
    .centerYEqualToView(self.contentView);
    [_title setSingleLineAutoResizeWithMaxWidth:150];
    [_title updateLayout];
    
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:ImageNamed(@"pj") forState:0];
        [btn setImage:ImageNamed(@"已收藏") forState:UIControlStateSelected];
        btn.tag = 10 + i;
        if (i == 0) {
            btn.selected = YES;
        }
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.sd_layout
        .leftSpaceToView(_title, WIDTH_TO(15) + (WIDTH_TO(45)*i))
        .heightIs(HEIGHT_TO(30))
        .widthEqualToHeight()
        .centerYEqualToView(self.contentView);
        
        [self.btnArray addObject:btn];
    }*/
    
}

#pragma mark - 点击
-(void)selectClicked:(UIButton *)sender{
    for (UIButton *btn in self.btnArray) {
        btn.selected = NO;
        if (btn.tag <=sender.tag) {
            btn.selected = YES;
        }
    }
    if (_inputnumber) {
        _inputnumber(sender.tag - 9);
    }
}

@end
