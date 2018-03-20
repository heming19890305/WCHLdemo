//
//  ZWHMyclassifyView.h
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClicked)(NSInteger idx);

@interface ZWHMyclassifyView : UIView

@property(nonatomic,strong)btnClicked didClicked;

@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic,strong)NSArray *redArray;

@property(nonatomic,strong)UILabel *red1;
@property(nonatomic,strong)UILabel *red2;
@property(nonatomic,strong)UILabel *red3;

@property(nonatomic,strong)UIImageView *img1;
@property(nonatomic,strong)UIImageView *img2;
@property(nonatomic,strong)UIImageView *img3;

@property(nonatomic,strong)UIView *view1;
@property(nonatomic,strong)UIView *view2;
@property(nonatomic,strong)UIView *view3;

@end
