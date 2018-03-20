//
//  BasicWebViewController.h
//  LookPicture
//
//  Created by ZS on 2017/9/1.
//  Copyright © 2017年 胡青月. All rights reserved.
//

#import "BasicViewController.h"
#import <WebKit/WebKit.h>
//#import "ZSHomeNewArticleModel.h"

@interface BasicWebViewController : BasicViewController;
@property (nonatomic, copy) NSString *htmlStr;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong , nonatomic) NSString *skipWay;
@property(nonatomic,assign)BOOL isShare;
@property (strong, nonatomic) WKWebView *webView;
//党建动态 最新动态模型
//@property(nonatomic,strong)ZSHomeNewArticleModel *armodel;
@end
