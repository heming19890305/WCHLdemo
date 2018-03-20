//
//  ZWHCollectModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/22.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHCollectModel : ZSBaseModel

/*goodid (string): 商品id ,
 id (string): 收藏id ,
 marketprice (number): 商品市场价 ,
 price (number): 商品销售价 ,
 thumbnail (string): 商品缩略图 ,
 title (string): 商品标题 ,
 workpoints (number): 商品工分*/

@property(nonatomic,copy)NSString *goodid;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *marketprice;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *thumbnail;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *workpoints;
@property(nonatomic,copy)NSString *attrLabel;

@end
