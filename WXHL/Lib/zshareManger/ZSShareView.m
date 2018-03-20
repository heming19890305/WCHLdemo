//
//  ZSShareView.m
//  PlayVR
//
//  Created by 赵升 on 2016/10/19.
//  Copyright © 2016年 ZS. All rights reserved.
//

#import "ZSShareView.h"

@interface ZSShareView()

@property (nonatomic, strong) UILabel *shareLabel;              //分享标题
@property (nonatomic, strong) UIButton *cancelBtn;              //取消按钮

@end

@implementation ZSShareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    self.shareLabel = [[UILabel alloc]init];
    self.shareLabel.text = @"分享到";
    self.shareLabel.backgroundColor = [UIColor clearColor];
    self.shareLabel.font = [UIFont fontWithPx:30];
    self.shareLabel.textColor = [ZSColor hexStringToColor:@"646363"];
    self.shareLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.shareLabel];

    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.backgroundColor = [ZSColor hexStringToColor:@"f3f3f3"];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[ZSColor hexStringToColor:@"646363"] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont fontWithPx:28];
    [self addSubview:self.cancelBtn];
    
    self.shareLabel.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(HEIGHT_TO(50));
    
    self.cancelBtn.sd_layout
    .bottomEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(HEIGHT_TO(50));
    

    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor greenColor];
    [self addSubview:view];
    view.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self.shareLabel, 0)
    .bottomSpaceToView(self.cancelBtn, 0);
    
    NSArray *titleArray = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    NSArray *imageArray = @[@"weixin",@"朋友圈",@"qq",@"qq空间"];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        UIView *containView = [[UIView alloc]init];
        containView.backgroundColor = [UIColor whiteColor];
        [view addSubview:containView];
        containView.sd_layout
        .xIs(SCREEN_WIDTH / 4 * i)
        .widthIs(SCREEN_WIDTH / 4)
        .topEqualToView(view)
        .bottomEqualToView(view);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:ImageNamed(imageArray[i]) forState:0];
        [button setTitle:titleArray[i] forState:0];
        button.titleLabel.font = [UIFont fontWithPx:26];
        [button addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 10;
        [button setTitleColor:[ZSColor hexStringToColor:@"646363"] forState:0];
        [containView addSubview:button];
        button.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        [button updateLayout];
        [button layoutButtonWithEdgeInsetsStyle:TWButtonEdgeInsetsStyleTop imageTitleSpace:55];
    }
}

- (void)shareClick:(UIButton *)sender{
    if (self.shareWayClick) {
        self.shareWayClick(sender.tag);
    }
}




- (void)cancelClick:(UIButton *)sender{
    if ([self.shareWayClickDelegate respondsToSelector:@selector(cancelClick:)]) {
        [self.shareWayClickDelegate cancelClick:sender];
    }
}




















@end
