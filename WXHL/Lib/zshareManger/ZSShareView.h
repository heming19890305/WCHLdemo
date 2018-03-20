//
//  ZSShareView.h
//  PlayVR
//
//  Created by 赵升 on 2016/10/19.
//  Copyright © 2016年 ZS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareWayClick)(NSInteger index);

@protocol ShareWayClick <NSObject>


- (void)cancelClick:(UIButton *)sender;


@end

@interface ZSShareView : UIView

@property (nonatomic, weak) id<ShareWayClick>shareWayClickDelegate;

@property (nonatomic, copy) ShareWayClick shareWayClick;

/*[[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeWechatTimeline WithTitle:self.shareTitle Images:self.shareImages url:[NSURL URLWithString:self.shareUrlString] content:self.shareContent];*/
@property(nonatomic,copy)NSString *shareTitle;
@property(nonatomic,copy)NSString *shareUrlString;
@property(nonatomic,copy)NSString *shareContent;
@property(nonatomic,strong)UIImage *shareImages;

@end
