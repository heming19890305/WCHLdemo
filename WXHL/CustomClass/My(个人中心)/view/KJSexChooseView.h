//
//  SexChooseView.h
//  MengMa
//
//  Created by Yonger on 2017/7/3.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>


// ***** 代码块；确认选择某项 ***** //
typedef void (^sureChooseContent)(NSString * choose,NSInteger selectIndex);

// ***** 代码块；确认选择某几项 ***** //
typedef void (^sureChooseContents)(NSArray * chooses,NSArray * selectIndexs);

@interface KJSexChooseView : UIView
//几选一
- (void)showInView:(UIView *)view withAllSelects:(NSArray *)selects didselect:(sureChooseContent)select;

//几选多
- (void)showInView:(UIView *)view withAllSelects:(NSArray *)selects didselects:(sureChooseContents)select;


- (void)hiddenPickerView;

@end
