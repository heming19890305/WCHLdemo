//
//  ZSNorSelectView.h
//  KPH
//
//  Created by 赵升 on 2017/6/9.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSNorTableHeaderView.h"
#import "ZSNorTableBottomView.h"


#import "ZWHGoodsModel.h"


typedef void (^didFetchDataAndChangeHeight)(CGFloat height);

@protocol DismissDelegate <NSObject>

- (void)dismiss;

-(void)inputSelectNor:(NSString *)selectinfo;

@end

@interface ZSNorSelectView : UIView

@property (nonatomic, weak) id<DismissDelegate>dismissDelegate;

@property (nonatomic, strong) UIButton *certainBtn;

@property (nonatomic, strong) ZSNorTableHeaderView *headerView;

@property (nonatomic, strong) ZSNorTableBottomView *bottomView;

@property (nonatomic, strong) NSString * goodsId;

@property (nonatomic, strong) NSString * normsString;//选择的规格信息
@property (nonatomic, strong) NSString * productId;//当规格确定后，会有对应的productId
@property (nonatomic, strong) NSString * activityType;//当规格确定后，会有对应的活动类型
@property(nonatomic,strong)NSString *nowprice;

@property(nonatomic,strong)NSArray *normsArray;

//商品数量
@property(nonatomic,assign)NSInteger selectNumber;

//商品库存
@property(nonatomic,strong)NSString *savenumber;

//商品单价
@property(nonatomic,strong)NSString *price;

//数据源
@property(nonatomic,strong)ZWHGoodsModel *model;
@property(nonatomic,strong)NSDictionary *norDict;

@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,strong)NSMutableArray *defaultDict;


-(void)didChangeHeight:(didFetchDataAndChangeHeight)change;
//返回是否能进行支付（库存是否足够）
-(BOOL)canPayforGoods;
@end
