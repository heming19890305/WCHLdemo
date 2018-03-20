//
//  ZWHGoodsModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/21.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHGoodsModel : ZSBaseModel

@property(nonatomic,copy)NSString *attributes;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *showType;
@property(nonatomic,copy)NSString *saleNum;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *nowPrice;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *masterImg;
@property(nonatomic,copy)NSString *goodsImgs;
@property(nonatomic,copy)NSString *inventory;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *goodsType;
@property(nonatomic,copy)NSString *giveScore;
@property(nonatomic,copy)NSString *frameFlag;
@property(nonatomic,copy)NSString *descr;
@property(nonatomic,copy)NSString *details;
@property(nonatomic,copy)NSString *attrId;
@property(nonatomic,copy)NSString *num;
@property(nonatomic,copy)NSString *curSaleNum;


@property(nonatomic,copy)NSArray *extendLists;
@property(nonatomic,strong)NSArray *attrs;


@property(nonatomic,copy)NSString *givescore;
@property(nonatomic,copy)NSString *goodid;
@property(nonatomic,copy)NSString *goodname;
@property(nonatomic,copy)NSString *marketprice;
@property(nonatomic,copy)NSString *thumbnail;

@property(nonatomic,copy)NSString *detailId;
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *score;
@property(nonatomic,copy)NSString *tabName;

@property(nonatomic,copy)NSString *daySaleNum;
@property(nonatomic,copy)NSString *salePrice;
@property(nonatomic,copy)NSString *totalSaleNum;


@property(nonatomic,copy)NSString *commentFlag;
@property(nonatomic,copy)NSString *collectionFlag;

@property(nonatomic,assign)NSInteger goodslogNum;

//订单
/*detailId (string): 订单商品信息ID ,
 img (string): 商品图片 ,
 name (string): 商品名称 ,
 num (integer): 数量 ,
 price (number): 单价 ,
 score (number): 工分 ,
 tabName (string): SKU标签*/

/*
 attributes (string): 商品属性 ,
 givescore (number): 赠送工分 ,
 goodid (string, optional),
 goodname (string): 商品名称 ,
 id (string, optional),
 marketprice (number): 商品默认价格 ,
 num (integer): 购买数量 ,
 price (number): 商品价格 ,
 thumbnail (string): 商品图*/

/*frameFlag (string): 上下架 ,
 giveScore (number): 赠送工分 ,
 goodsType (string): 商品类别 ,
 id (string): 商品ID ,
 inventory (integer): 商品库存 ,
 masterImg (string): 门户图片 ,
 name (string): 商品名称 ,
 nowPrice (number): 商品售价 ,
 price (number): 商品标价 ,
 saleNum (integer): 销量 ,
 showType (string): 展示方式 ,
 sort (integer): 排序 ,
 status (string): 商品状态 ,
 unit (string): 商品单位*/
@end
