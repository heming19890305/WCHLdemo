//
//  ZSNorTableBottomView.h
//  KPH
//
//  Created by 赵升 on 2017/6/9.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol goodsNumberChooseChangeDelegete<NSObject>

-(void)didChangeNumber:(NSInteger )goodsNumber;
@end
@interface ZSNorTableBottomView : UIView

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *reduceBtn;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic,assign)NSInteger goodsNumber;//选择的数量
@property (nonatomic,assign)NSInteger maxGoodsNumber;//最多选多少


@property (nonatomic,weak)id<goodsNumberChooseChangeDelegete> delegete;
@end
