//
//  ZWHChoseExView.h
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void(^inputidx)(NSInteger idx);

@interface ZWHChoseExView : UIView

-(void)showViewWith:(CGRect)frame;

@property(nonatomic,strong)inputidx didinput;

@end
