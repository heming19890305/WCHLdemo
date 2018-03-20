//
//  BasicViewController.h
//  千帆渡留学
//
//  Created by qfd on 15/11/17.
//  Copyright © 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController
@property (nonatomic, strong) UIButton *backBtn;
/**创建返回按钮*/
- (void) createLeftNavButton;

- (void) createRightNavButton;


- (void)backClick:(UIButton *)sender;


-(void)showMore;

-(void)getLogin;
@end
