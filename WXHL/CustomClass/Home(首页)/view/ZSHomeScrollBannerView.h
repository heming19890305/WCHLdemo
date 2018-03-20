//
//  ZSHomeScrollBannerView.h
//  LookPicture
//
//  Created by ZS on 2017/9/12.
//  Copyright © 2017年 龙泉舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollLabelView.h"
@interface ZSHomeScrollBannerView : UIView <ZSChangeTextViewDelegate>

@property (strong , nonatomic)NSArray *dataArray;

// ***** 容器view *****//
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) UIViewController *fffVC;
// ***** 通知滚动文字 *****//
@property (nonatomic, strong) ScrollLabelView *notifyScrollView;
// ***** 公告滚动文字 *****//
@property (nonatomic, strong) ScrollLabelView *announceScrollView;
// ***** 公示滚动文字 *****//
@property (nonatomic, strong) ScrollLabelView *publicityScrollView;

-(void)setDataSource:(NSArray *)textArray;

-(void)setDataWithInformList:(NSArray *)array;

-(void)setDataWithNoticeList:(NSArray *)array;
@end
