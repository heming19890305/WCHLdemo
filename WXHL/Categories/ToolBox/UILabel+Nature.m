//
//  UILabel+Nature.m
//  ProjectTest
//
//  Created by 赵升 on 2017/3/20.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "UILabel+Nature.h"

@implementation UILabel (Nature)
- (void)textFont:(CGFloat )textFont textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor textAlignment:(NSTextAlignment)textAlignment{
    self.textColor = textColor;
    self.font = [UIFont fontWithPx:textFont * 2];
    self.backgroundColor = backgroundColor;
    self.textAlignment = textAlignment;
}

- (CGSize)sizeOfNSStringWithFont:(CGFloat)font{
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:FontWithSize(font)}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return adjustedSize;
}

@end
