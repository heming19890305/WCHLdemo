//
//  ZWHMessageModel.h
//  WXHL
//
//  Created by Syrena on 2017/11/20.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZSBaseModel.h"

@interface ZWHMessageModel : ZSBaseModel

/*"content": "string",
 "createDate": "2017-11-20T05:41:10.230Z",
 "id": "string",
 "isReaded": "string",
 "title": "string",
 "type": "string"*/

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *isReaded;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *type;

@end
