//
//  ZSNorTableHeaderView.h
//  KPH
//
//  Creat/Users/syrenamac/Desktop/狂拍会/KPH/KPH/CustomerClass/Classify/View/ZSNorTableHeaderView.hed by 赵升 on 2017/6/9.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZSNorTableHeaderView : UIView

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *goodsImageView;

@property (nonatomic, strong) UIView *bottomView;

// ***** 价格 *****//
@property (nonatomic, strong) UILabel *priceLabel;
// ***** 旧价 *****//
@property (nonatomic, strong) UILabel *oldpriceLabel;

// ***** 请选择规格 *****//
@property (nonatomic, strong) UILabel *chooseNor;

// ***** 关闭 *****//
@property (nonatomic, strong) UIButton *closeBtn;


@property (nonatomic, strong) NSDictionary *dict;;


@end
