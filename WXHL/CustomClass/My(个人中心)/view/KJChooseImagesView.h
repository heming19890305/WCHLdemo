//
//  KJChooseImagesView.h
//  KPH
//
//  Created by Yonger on 2017/7/24.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^chooseImageHeightIsChnage)(CGFloat height);

@interface KJChooseImagesView : UIView

@property (nonatomic,strong)NSMutableArray * imagesArry;
@property (nonatomic,strong)NSString * titleStr;
@property(nonatomic,assign)NSInteger maxImagesNumber;//最大图片数（0为不限制）
@property(nonatomic,assign)NSInteger numberOfLine;//每行张数

@property(nonatomic,assign)BOOL hasChooseImage;

-(void)viewheightIsChanged:(chooseImageHeightIsChnage)change addimage:(NSString *)image;
//根据url数组加载图片
-(void)loadImagsWithImageUrlArry:(NSArray *)arry;
@end
