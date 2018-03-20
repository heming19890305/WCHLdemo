//
//  UIColor+HexColor.h
//  千帆渡留学
//
//  Created by ZhHS on 16/11/1.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorWithHex:(NSString *)hexStr;

+ (UIColor *)colorWithHex:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
