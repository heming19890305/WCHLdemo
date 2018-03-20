//
//  FirstClassifyView.h
//  LookPicture
//
//  Created by 胡青月 on 2017/8/2.
//  Copyright © 2017年 胡青月. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FirstClassifyView : UIView

@property (nonatomic, copy) void (^ClassifyButtonClicked)(int index);

/** 加入分类数据 */
- (void) addClassifyDataToView:(NSArray *) dataArray;

// ***** scrollView *****//
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger type;

@property(nonatomic,strong)UIPageControl *pageC;


@property(nonatomic,assign)BOOL isshowPage;
@end
