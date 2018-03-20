//
//  UIButton+ImageTextStyle.h
//  HaveToStudy
//
//  Created by 赵升 on 2017/3/30.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,TWButtonEdgeInsetsStyle){
    TWButtonEdgeInsetsStyleTop,//image在上 label在下
    TWButtonEdgeInsetsStyleLeft,//image在左 label在右
    TWButtonEdgeInsetsStyleRight,//image在右 label在左
    TWButtonEdgeInsetsStyleButtom//image在下 label在右
};
@interface UIButton (ImageTextStyle)
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(TWButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end
