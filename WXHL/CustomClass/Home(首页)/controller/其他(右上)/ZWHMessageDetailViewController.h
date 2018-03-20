//
//  ZWHMessageDetailViewController.h
//  WXHL
//
//  Created by Syrena on 2017/12/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "BasicViewController.h"

@interface ZWHMessageDetailViewController : BasicViewController
@property (nonatomic, copy) NSString *htmlStr;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong , nonatomic) NSString *skipWay;
@property(nonatomic,assign)BOOL isShare;
@property (strong, nonatomic) WKWebView *webView;

@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *mestitle;
@end
