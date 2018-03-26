//
//  HMPasswordAlertView.h
//  WXHL
//
//  Created by tomorrow on 2018/3/23.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    passwordAlertViewType_default, //从window中间弹出
    passwordAlertViewType_sheet,   //从底部弹出
}PasswordAlertViewType;
@protocol HMPassWordAlertViewDelegate<NSObject>
//点击确定按钮 或者完成6位密码的输入
- (void)passwordAlertViewCompleteInputWith:(NSString *)password;
//点击取消按钮
- (void)passwordAlertViewDidClickCancleButton;
//点击忘记密码按钮
- (void)passwordAlertViewDidClickForgetButton;
@end
@interface HMPasswordAlertView : UIView
//标题
@property (nonatomic, strong) UILabel * titleLabel;
//输入框下面的提示lable（如提示密码错误) 默认隐藏 当调用密码错误的方法时就显示出来
@property (nonatomic, strong) UILabel * tipsLabel;
@property (nonatomic, weak) id<HMPassWordAlertViewDelegate>delegate;
- (instancetype)initWithType:(PasswordAlertViewType)alertType;
//密码正确调用方法
- (void)passwordCorrect;
//密码错误调用方法
- (void)passwordError;
- (void)show;
@end

