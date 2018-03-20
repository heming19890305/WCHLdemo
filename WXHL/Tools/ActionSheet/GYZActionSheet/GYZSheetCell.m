//
//  GYZSheetCell.m
//  GYZCustomActionSheet
//
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "GYZSheetCell.h"
#import "GYZCommon.h"
#import "Masonry.h"
@implementation GYZSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-10*2, 60)];
        self.myLabel = [[UILabel alloc]init];
        _myLabel.textAlignment = NSTextAlignmentCenter;
        _myLabel.backgroundColor = [UIColor whiteColor];
        _myLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        _myLabel.font = [UIFont systemFontOfSize:13];
        if (kScreenHeight == 667) {
            _myLabel.font = [UIFont systemFontOfSize:16];
        }
        else if (kScreenHeight > 667) {
            _myLabel.font = [UIFont systemFontOfSize:16];
        }
        [self.contentView addSubview:self.myLabel];
        [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(@200);
            make.height.mas_equalTo(@20);
        }];
        
        
        self.tableDivLine = [[UIView alloc]initWithFrame:CGRectMake(0, MaxY(self.myLabel), kScreenWidth, kLineHeight)];
        self.tableDivLine.backgroundColor = kGrayLineColor;
        [self.contentView addSubview: self.tableDivLine];
    }
    return self;
}

@end
