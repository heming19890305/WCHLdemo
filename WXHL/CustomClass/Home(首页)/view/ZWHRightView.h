//
//  ZWHRightView.h
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^inputidx)(NSInteger idx);

@interface ZWHRightView : UIView

-(void)showView;

@property(nonatomic,strong)inputidx didinput;

@end
