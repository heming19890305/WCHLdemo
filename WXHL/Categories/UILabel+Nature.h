//
//  UILabel+Nature.h
//  ProjectTest
//
//  Created by 赵升 on 2017/3/20.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Nature)

//设置label 字体大小 字体颜色 背景颜色 对齐方式
- (void)textFont:(CGFloat )textFont textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor textAlignment:(NSTextAlignment)textAlignment;

- (CGSize)sizeOfNSStringWithFont:(CGFloat)font;


@end
