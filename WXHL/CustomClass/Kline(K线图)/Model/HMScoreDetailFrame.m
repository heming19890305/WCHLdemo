//
//  HMScoreDetailFrame.m
//  WXHL
//
//  Created by tomorrow on 2018/4/16.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreDetailFrame.h"

// 屏幕尺寸

#define HMScreenW [UIScreen mainScreen].bounds.size.width

@implementation HMScoreDetailFrame
- (void)setModel:(HMScoreModel *)model
{
    _model = model;
    
    //1.创建时间
    CGFloat createDateX = 10;
    CGFloat createDateY = 10;
    CGFloat createDateW = 100;
    CGFloat createDateH = 50;
    self.incomeMoneyFrame = CGRectMake(createDateX, createDateY, createDateW, createDateH);
    
    //自己的frame
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = HMScreenW;
    
    if ([model.status isEqualToString:@"0"]) {
         self.frame = CGRectMake(x, y, w, 80);
    }else
    {
          self.frame = CGRectMake(x, y, w, 150);
    }
    
    self.cellHeight = CGRectGetMaxY(self.frame);
}
@end
