//
//  PasswordView.h
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnPasswordStringBlock)(NSString *password);

typedef void(^dismissView)(void);

typedef void(^fotgetpw)(void);

@interface PasswordView : UIView

@property (copy, nonatomic) ReturnPasswordStringBlock returnPasswordStringBlock;
@property(copy,nonatomic)dismissView dismissV;
@property(copy,nonatomic)fotgetpw findpw;
@end
