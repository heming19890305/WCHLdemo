/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


@property(nonatomic,assign)BOOL titleViewIsShow;//影藏返回按钮(默认不显示)
@property(nonatomic,assign)BOOL backBtnIsHiden;//影藏返回按钮（默认显示）
@property(nonatomic,strong)NSString * baseTitle;//标题，设置的时候会显示（默认为”“）
@property (nonatomic,strong)UIView * titleView;//顶部显示的视图

@property (nonatomic,strong)UILabel * titleLable;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *firstRightBtn;
@property (nonatomic, strong) UIButton *secondRightBtn;

//添加返回按钮
-(void)addBackLeftBtn:(NSString *)title hightTile:(NSString *)hightTile fontsize:(CGFloat)fontsize fontcolor:(UIColor *)color Image:(NSString *)image hightImage:(NSString *)hightImage;

//设置导航栏右部按钮
-(UIButton *)addFirstRightBtn:(NSString *)title hightTile:(NSString *)hightTile fontsize:(CGFloat)fontsize fontcolor:(UIColor *)color Image:(NSString *)image hightImage:(NSString *)hightImage;
-(UIButton *)addSecondRightBtn:(NSString *)title hightTile:(NSString *)hightTile fontsize:(CGFloat)fontsize fontcolor:(UIColor *)color Image:(NSString *)image hightImage:(NSString *)hightImage;

@end
