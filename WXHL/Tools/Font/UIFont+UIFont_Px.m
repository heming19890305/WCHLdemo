//
//  UIFont+UIFont_Px.m
//  
//
//  Created by iOS开发 on 16/3/7.
//  Copyright © 2016年 . All rights reserved.
//

#import "UIFont+UIFont_Px.h"

@implementation UIFont (UIFont_Px)
+(instancetype)fontWithPx:(CGFloat )px{
    
    CGFloat s = 1.2;
    
    if ([UIScreen mainScreen].bounds.size.width == 375) {
        s = 1.05;
    } else if ([UIScreen mainScreen].bounds.size.width > 375) {
        s = .95;
    }
    
    return [UIFont systemFontOfSize:px / ( 2 * s ) ];
}

+(instancetype)bodyfontWithPx:(CGFloat )px{
    CGFloat s = 1.2;
    
    if ([UIScreen mainScreen].bounds.size.width == 375) {
        s = 1.05;
    } else if ([UIScreen mainScreen].bounds.size.width > 375) {
        s = .95;
    }
    
    return [UIFont boldSystemFontOfSize:px / ( 2 * s ) ];
}

+(instancetype)fontWithPx:(CGFloat )px andWeight:(CGFloat) weight
{
    CGFloat s = 1.2;
    
    if ([UIScreen mainScreen].bounds.size.width == 375) {
        s = 1.05;
    }
    else if ([UIScreen mainScreen].bounds.size.width >375) {
        s = .95;
    }
    return [UIFont systemFontOfSize:px/(2*s) weight:weight];
}
@end
