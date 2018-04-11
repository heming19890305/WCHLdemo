//
//  HMScoreView.m
//  WXHL
//
//  Created by tomorrow on 2018/3/13.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreView.h"
#import "ZWHMyWorkModel.h"

@implementation HMScoreView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        UILabel * scoreLabel = [UILabel new];
        _unGotScore = scoreLabel;
        scoreLabel.backgroundColor = [UIColor yellowColor];
        
        
//        scoreLabel.text = _gotScore ;
        NSLog(@"$$$$$$$$$------$$$$$$$$$$$$$$$$ = %@", _dataModel.userBalance);
        [self addSubview:scoreLabel];
        scoreLabel.sd_layout
        .topSpaceToView(self, 100)
        .leftSpaceToView(self, 50)
        .widthIs(100)
        .heightIs(60);
    }
    return self;
}


-(void)setDataModel:(ZWHMyWorkModel *)dataModel
{
    _dataModel = dataModel;
    _unGotScore.text = dataModel.scorePrice;
    _gotScore = dataModel.scoreNumber;
//    _textArray = [NSMutableArray array];
//    [_textArray addObject:_dataModel.scorePrice==nil?@"":_dataModel.scorePrice];
//    [_textArray addObject:_dataModel.scoreNumber==nil?@"":_dataModel.scoreNumber];
//    [_textArray addObject:_dataModel.scoreMarket==nil?@"":_dataModel.scoreMarket];
//
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ = %@", dataModel.scorePrice);
    NSLog(@"$$$$$$$$+++++++$$$$$$$$$$ = %@", _unGotScore.text);
    
   
}
@end
