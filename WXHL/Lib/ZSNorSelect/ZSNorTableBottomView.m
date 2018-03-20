//
//  ZSNorTableBottomView.m
//  KPH
//
//  Created by 赵升 on 2017/6/9.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "ZSNorTableBottomView.h"

@implementation ZSNorTableBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view1.backgroundColor = [UIColor whiteColor];
    [view addSubview:view1];
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.text = @"购买数量";
    [countLabel textFont:WIDTH_PRO(15) textColor:[ZSColor hexStringToColor:@"323232"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:countLabel];
    countLabel.sd_layout
    .leftSpaceToView(view, 15)
    .centerYEqualToView(view)
    .heightIs(20)
    .widthIs(75);
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.addBtn setImage:ImageNamed(@"加") forState:0];
    [self.addBtn addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview: self.addBtn];
     self.addBtn.sd_layout
    .rightSpaceToView(view, 22)
    .widthIs(25)
    .heightIs(25)
    .centerYEqualToView(view);
    
    
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.layer.borderWidth = 1;
    self.countLabel.layer.borderColor = GRAYBACKCOLOR.CGColor;
    self.countLabel.layer.cornerRadius = 5;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.text = @"1";
    [self.countLabel textFont:WIDTH_PRO(15) textColor:[ZSColor hexStringToColor:@"363636"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [view addSubview:self.countLabel];
    self.countLabel.sd_layout
    .rightEqualToView(self.addBtn)
    .widthIs(130)
    .topEqualToView(self.addBtn)
    .bottomEqualToView(self.addBtn);
    
    self.reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reduceBtn setImage:ImageNamed(@"减-拷贝") forState:0];
    [self.reduceBtn addTarget:self action:@selector(reduceNumber) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.reduceBtn];
    self.reduceBtn.sd_layout
    .leftEqualToView(self.countLabel)
    .widthIs(25)
    .heightIs(25)
    .centerYEqualToView(view);
    
    [self addSubview:view];
    self.goodsNumber = 1;
}

-(void)addNumber{//加
    if(self.goodsNumber == self.maxGoodsNumber){
        ShowInfoWithStatus(@"库存不足");
        return;
    }
    self.goodsNumber = self.goodsNumber+1;
}
-(void)reduceNumber{//减
    if(self.goodsNumber == 1){
        ShowInfoWithStatus(@"最少选择一件商品");
        return;
    }
    self.goodsNumber = self.goodsNumber-1;
}

-(void)setGoodsNumber:(NSInteger)goodsNumber{
    _goodsNumber = goodsNumber;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",goodsNumber];
    if(self.delegete){
        [self.delegete didChangeNumber:goodsNumber];
    }
}

@end
