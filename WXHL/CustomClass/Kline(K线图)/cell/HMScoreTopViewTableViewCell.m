//
//  HMScoreTopViewTableViewCell.m
//  WXHL
//
//  Created by tomorrow on 2018/3/15.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreTopViewTableViewCell.h"


@implementation HMScoreTopViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.contentView addSubview:_scoreView];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
- (void)setScoreView:(HMScoreScrollView *)scoreView
{
    _scoreView = scoreView;
    if (_scoreView == nil) {
        _scoreView = [[HMScoreScrollView alloc] init];
    }
}
@end
