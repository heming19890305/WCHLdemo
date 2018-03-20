//
//  UIFont+UIFont_Px.h
//  
//
//  Created by iOS开发 on 16/3/7.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIFont (UIFont_Px)
+(instancetype)fontWithPx:(CGFloat )px;
+(instancetype)bodyfontWithPx:(CGFloat )px;
+(instancetype)fontWithPx:(CGFloat )px andWeight:(CGFloat) weight;
@end
