//
//  KJChooseNormsView.h
//  KPH
//
//  Created by Yonger on 2017/8/3.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^normChooseDidChange)(BOOL isselectAll);//返回是否全部规格都做了选择

@interface KJChooseNormsView : UIView

-(BOOL)isSelectAllNorm;//判断是否所有规则都做了选择
-(NSString *)selectNormInfo;//获取选择的规格[{@"key":@"name",@"val":@"a"},{}]
//加载后会自动计算高度
-(instancetype)initWithFrame:(CGRect)frame WithAllNormInfo:(NSArray *)allNormInfoArry SelectNormInfo:(NSArray *)selectInfo readOnly:(BOOL)readOnly;

-(void)normChooseDidChange:(normChooseDidChange)change;

@end


