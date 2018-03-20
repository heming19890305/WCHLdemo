//
//  ZWHDownClassifyView.h
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHMyWorkModel.h"

typedef void(^btnClicked)(NSInteger idx);

@interface ZWHDownClassifyView : UIView

@property(nonatomic,strong)btnClicked didClicked;

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray *textArray;

@property(nonatomic,strong)NSString *text;

@property(nonatomic,strong)ZWHMyWorkModel *workmodel;


@end
