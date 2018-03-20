//
//  ZWHHomeMidView.h
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClicked)(NSInteger idx);

@interface ZWHHomeMidView : UIView


@property(nonatomic,strong)btnClicked didClicked;

@property(nonatomic,strong)NSArray *dataArray;
@end
