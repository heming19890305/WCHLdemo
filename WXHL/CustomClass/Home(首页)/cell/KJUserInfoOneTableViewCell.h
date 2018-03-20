//
//  KJUserInfoOneTableViewCell.h
//  LookPicture
//
//  Created by Yonger on 2017/8/30.
//  Copyright © 2017年 胡青月. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sureInputContent)(NSString * input);
typedef void (^sureClickChoose)();

@interface KJUserInfoOneTableViewCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong)NSString * image;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * place;

@property(nonatomic,strong)UITextField * inputTex;
@property(nonatomic,strong)UIButton * clickBtn;
@property(nonatomic,strong)UIImageView * leftImage;
@property(nonatomic,strong)UIView * lineView;

//自定义按钮
@property(nonatomic,strong)UIButton *callB;

@property(nonatomic,strong)sureClickChoose clickAction;
@property(nonatomic,strong)sureInputContent sureInput;

@property(nonatomic,assign)BOOL inputTexCanInput;

@property(nonatomic,assign)NSInteger maxLenght;//-1为不限制

//是否自适应宽度
@property(nonatomic,assign)BOOL isesmitWid;

-(void)showLeftImage:(BOOL)show;

@end
