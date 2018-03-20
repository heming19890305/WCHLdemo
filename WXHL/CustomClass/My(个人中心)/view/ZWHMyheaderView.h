//
//  ZWHMyheaderView.h
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWHMyclassifyView.h"
#import "ZWHDownClassifyView.h"
#import "ZWHHomeMidView.h"
#import "ZWHMyMidView.h"



typedef void(^upinputidx)(NSInteger idx);

@interface ZWHMyheaderView : UIView

@property(nonatomic,strong)UIButton *rigBtn;

@property(nonatomic,strong)UIButton *settingBtn;

@property(nonatomic,strong)UIButton *certify;

@property(nonatomic,strong)ZWHMyclassifyView *upview;

@property(nonatomic,strong)ZWHDownClassifyView *downview;

@property(nonatomic,strong)ZWHMyMidView *bottomview;

@property(nonatomic,copy)upinputidx getindex;

@property(nonatomic,copy)upinputidx getbottomindex;

@property(nonatomic,strong)ZWHMyModel *model;

@property(nonatomic,strong)UIImageView *icon;

@end
