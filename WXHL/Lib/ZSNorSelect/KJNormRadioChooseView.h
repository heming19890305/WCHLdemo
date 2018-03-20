//
//  KJNormRadioChooseView.h
//  KPH
//
//  Created by Yonger on 2017/8/3.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^chooseNormChange)(NSString * norm);

@interface KJNormRadioChooseView : UIView
@property (nonatomic,strong)NSString * key;
@property(nonatomic,strong)NSArray * values;

-(BOOL)isSelect;//是否选择
-(NSString *)selectValue;
//初始化后，会自动计算高度，
-(instancetype)initWithFrame:(CGRect)frame Key:(NSString *)key Values:(NSArray *)values SelectValu:(NSString *)selectValue;

-(void)didChooseNorm:(chooseNormChange)choose;

@end
