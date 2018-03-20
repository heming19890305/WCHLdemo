//
//  ScrollLabelView.h
//  MengMa
//
//  Created by 赵升 on 2017/6/29.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScrollLabelView;

@protocol ZSChangeTextViewDelegate <NSObject>

//点击公告方法
- (void)zsChangeTextView:(ScrollLabelView *)textView didTapedAtIndex:(NSInteger)index;

@end

@interface ScrollLabelView : UIView
@property (strong , nonatomic)NSArray *dataArray;
@property (nonatomic, assign) id<ZSChangeTextViewDelegate> delegate;

- (void)animationWithTexts:(NSArray *)textAry;

- (void)stopAnimation;

@end
