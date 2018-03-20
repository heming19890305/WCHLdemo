//
//  BasicWebViewController.m
//  LookPicture
//
//  Created by ZS on 2017/9/1.
//  Copyright © 2017年 胡青月. All rights reserved.
//

#import "BasicWebViewController.h"


@interface BasicWebViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>



//@property (nonatomic, strong) ZSShareView *shareView;
@property (nonatomic, strong) UIButton *backgroundBtn;
@end

@implementation BasicWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//    NSString *jScript = @"function imgAutoFit() { \
//    var imgs = document.getElementsByTagName('img'); \
//    for (var i = 0; i < imgs.length; ++i) {\
//    var img = imgs[i];   \
//    img.style.maxWidth = %f;   \
//    } \
//    }";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, SCREEN_HEIGHT - 66) configuration:wkWebConfig];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),2)];
    _progressView.progressTintColor = MAINCOLOR;
    _progressView.backgroundColor = [UIColor clearColor];
    _progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:_progressView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    
//    [_webView loadHTMLString:[self reSizeImageWithHTML:self.htmlStr] baseURL:nil];
    if ([self.skipWay isEqualToString:@"outside"]) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlStr]]];
    }else{
        [_webView loadHTMLString:[self reSizeImageWithHTML:self.htmlStr] baseURL:nil];
    }
    if (_isShare) {
        [self createRightBarItem];
    }
    //self.navigationController.navigationBar.barTintColor = MAINCOLOR;
    
}

- (void)createRightBarItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:ImageNamed(@"分享48") forState:0];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:0];
    rightBtn.titleLabel.font = [UIFont fontWithPx:32];
    rightBtn.frame = CGRectMake(0, 0, 40, 25);
    [rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

/*- (void)share{
    NSLog(@"分享");
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backgroundBtn.backgroundColor = [UIColor blackColor];
    self.backgroundBtn.alpha = 0;
    [self.backgroundBtn setFrame:CGRectMake(0,0,SCREENWIDTH,SCREEN_HEIGHT)];
    [self.backgroundBtn addTarget:self action:@selector(disappear:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:self.backgroundBtn];
    
    
    self.shareView = [[ZSShareView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_PRO(180))];
    self.shareView.shareWayClickDelegate = self;
    __weak BasicWebViewController *weakSelf = self;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.armodel.filePaths]]];
    UIImage * image = [self thumbnailWithImageWithoutScale:[UIImage imageWithData:data] size:CGSizeMake(300, 300)];
    self.shareView.shareWayClick = ^(NSInteger index) {
        switch (index) {
            case 10:
            {
                [[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeWechatSession WithTitle:weakSelf.armodel.title Images:image url:[NSURL URLWithString:@"http://www.baidu.com"] content:weakSelf.armodel.intro];
            }
                break;
            case 11:
            {
                [[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeWechatTimeline WithTitle:weakSelf.armodel.title Images:image url:[NSURL URLWithString:@"http://www.baidu.com"] content:weakSelf.armodel.intro];
            }
                break;
            case 12:
            {
                [[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeQQFriend WithTitle:weakSelf.armodel.title Images:image url:[NSURL URLWithString:@"http://www.baidu.com"] content:weakSelf.armodel.intro];
            }
                break;
            case 13:
            {
                [[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeQZone WithTitle:weakSelf.armodel.title Images:image url:[NSURL URLWithString:@"http://www.baidu.com"] content:weakSelf.armodel.intro];
            }
                break;
            default:
                break;
        }
        
        
    };
    [window addSubview:self.shareView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundBtn.alpha = 0.5;
        [self.shareView setFrame:CGRectMake(0, SCREEN_HEIGHT - HEIGHT_TO(180), SCREEN_WIDTH, HEIGHT_TO(180))];
    } completion:^(BOOL finished) {
        
    }];
}*/

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image)
    {
        newimage = nil;
    } else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height)
        {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


#pragma mark - 隐藏分享视图
/*- (void)disappear:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundBtn.alpha = 0;
        [self.shareView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, HEIGHT_TO(180))];
    } completion:^(BOOL finished) {
        [self.backgroundBtn removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
}*/

/*-(void)cancelClick:(UIButton *)sender{
    [self disappear:sender];
}*/


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}


- (NSString *)reSizeImageWithHTML:(NSString *)html {
    return [NSString stringWithFormat:@"<head><style>img{max-width:%.2fpx !important;}</style></head>%@", self.view.frame.size.width - 20,html];
}



@end
