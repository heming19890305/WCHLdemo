//
//  WXHLHeader.h
//  WXHL
//
//  Created by Syrena on 2017/11/6.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#ifndef WXHLHeader_h
#define WXHLHeader_h



// ***** cell分割线 *****//
#define CellLine     UIView *view = [[UIView alloc]init];\
view.backgroundColor = LINECOLOR; \
[self.contentView addSubview:view]; \
view.sd_layout  \
.leftEqualToView(self.contentView) \
.rightEqualToView(self.contentView)  \
.bottomEqualToView(self.contentView)  \
.heightIs(1);
// ***** view分割线 *****//
#define ViewLine     UIView *view = [[UIView alloc]init];\
view.backgroundColor = LINECOLOR; \
[self addSubview:view]; \
view.sd_layout  \
.leftEqualToView(self) \
.rightEqualToView(self)  \
.bottomEqualToView(self)  \
.heightIs(1);

#define RGB(R,G,B) [UIColor colorWithRed:R / 255.8f green:G / 255.8f blue:B / 255.8f alpha:1]
#define TEXTFONT(X) [UIFont systemFontOfSize:X]
#define SIXCOLOR(X) [UIColor colorWithHexString:X]

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define SCREENHIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREENWIDTH [[UIScreen mainScreen]bounds].size.width

#define HEIGHT_TO(hei) ([[UIScreen mainScreen]bounds].size.height * (hei) / 667)
#define WIDTH_TO(wid) ([[UIScreen mainScreen]bounds].size.width * (wid) / 375)

#define RGBCOLOR(R,G,B)  [UIColor colorWithRed:R / 255.8f green:G / 255.8f blue:B / 255.8f alpha:1]


#define RGBALPHA(R,G,B,A)  [UIColor colorWithRed:R / 255.8f green:G / 255.8f blue:B / 255.8f alpha:A]

// ***** 屏幕宽高 *****//
#define WIDTH_PRO(X) (X)*(SCREEN_WIDTH/375)
#define HEIGHT_PRO(Y) (Y)*(SCREEN_HEIGHT/667)

#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define STATES_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define NAV_HEIGHT 64.0f
#define TAB_HEIGHT 49.0f
// RGB颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define lineColor [UIColor colorWithHex:@"f7f7f7"]
#define wireColor [UIColor colorWithHex:@"f0f0f0"]
#define mainColor [UIColor colorWithHex:@"ed2929"]

//颜色
#define ZWHCOLOR(Str) [ZSColor hexStringToColor:(Str)]

//整形转字符
#define ZWHINTTOSTR(Int) [NSString stringWithFormat:@"%ld",(Int)]

//返回值
#define ReturnValue [obj[@"status"] integerValue]


//返回错误参数
#define ErrorMessage obj[@"message"]

//网络错误
#define ErrorNet @"世界上最遥远的事就是没网"


// ***** 时间颜色 *****//
#define TIMECOLOR [ZSColor hexStringToColor:@"6f6f6f"]


// ***** 主色 *****//
#define MAINCOLOR [ZSColor hexStringToColor:@"1087f5"]
// ***** 分割线颜色 *****//
#define LINECOLOR [ZSColor hexStringToColor:@"f3f3f3"]
// ***** 背景颜色 *****//
#define BACKCOLOR [ZSColor hexStringToColor:@"f0f0f0"]
//***** 灰色背景颜色 *****//
#define GRAYBACKCOLOR RGBALPHA(246, 246, 246, 1)


//***** 订单灰色背景颜色 *****//
#define ORDERBACK [ZSColor hexStringToColor:@"F2F5F7"]


// ***** 获取图片 *****//
#define ImageNamed(imageName)  [UIImage imageNamed:imageName]
// ***** 默认图片名称 *****//
#define DefautImageName @"logo"
// ***** 移除通知 *****//
#define RemoveNotifiy -(void)dealloc{[[NSNotificationCenter defaultCenter] removeObserver:self];}
// ***** 随机色 *****//
#define RandomColor [UIColor colorWithRed:(arc4random() % 256) /255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1]
// ***** 注册通知 *****//
#define NOTIFY_ADD(_noParamsFunc, _notifyName)  [[NSNotificationCenter defaultCenter] \
addObserver:self \
selector:@selector(_noParamsFunc) \
name:_notifyName \
object:nil];
// ***** 发送通知 *****//
#define NOTIFY_POST(_notifyName)   [[NSNotificationCenter defaultCenter] postNotificationName:_notifyName object:nil];
// ***** 移除通知 *****//
#define NOTIFY_REMOVE(_notifyName) [[NSNotificationCenter defaultCenter] removeObserver:self name:_notifyName object:nil];
// ***** 提醒文字提示 *****//
#define ShowInfoWithStatus(Word) [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];\
[SVProgressHUD setMinimumDismissTimeInterval:2];\
[SVProgressHUD showInfoWithStatus:Word];

// ***** 加载框 *****//
#define ShowProgress [SVProgressHUD show];
// ***** 错误提示 *****//
#define ShowErrorWithStatus(Word) [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];\
[SVProgressHUD setMinimumDismissTimeInterval:2];\
[SVProgressHUD showErrorWithStatus:Word];
// ***** 成功提示 *****//
#define ShowSuccessWithStatus(Word) [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];\
[SVProgressHUD setMinimumDismissTimeInterval:2];\
[SVProgressHUD showSuccessWithStatus:Word];

#define ONEPOP __weak typeof(self) weakSelf = self;\
dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));\
dispatch_after(delayTime, dispatch_get_main_queue(), ^{[weakSelf.navigationController popViewControllerAnimated:YES];\
});\
// ***** 正在加载提示 *****//
#define ShowWithStatus(Word) [SVProgressHUD showWithStatus:Word];
// ***** 正在加载提示 不允许用户其他操作 *****//
#define NotAllowUser [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
// ***** 隐藏提示 *****//
#define Dismiss [SVProgressHUD dismiss];
// ***** 字号 *****//
#define FontWithSize(size) [UIFont fontWithPx:size*2]
// ***** 发布信息头像宽度 *****//
#define imgWid 30

// ***** 暂未填写 *****//
#define ZWTX @"暂未填写"

// ***** cell图片宽度(发布信息) *****//
#define issueimg (SCREEN_WIDTH - WIDTH_PRO(15+imgWid+5+15) - WIDTH_PRO(9)*2)/3

// ***** cell图片宽度(信息详情) *****//
#define IMGWID (SCREEN_WIDTH - WIDTH_PRO(15+15) - WIDTH_PRO(9)*2)/3

//注册时的账号
#define regisaccount @"registeraccount"

//注册时的密码
#define regispassword @"registerpassword"

#define  WORK @"worker"

#define  COMPANY @"company"

// ***** 分享key *****//
#define ShareKey @"1fb00d74a88d3"
// ***** 环信key *****//
#define EaseMobKey @"1112170629115401#kefuchannelapp43759"
// ***** 环信客服公司id *****//
#define EaseTenId @"43759"
// ***** 微信key *****//
#define WeChatKey @"wxc7b888bd32929831"
// ***** 微信secrect *****//
#define WeChatSecrect @"000dbff3575f21c7d45e591304b3c97a"
// ***** QQid *****//
#define QQId @"1106478571"
// ***** QQKey *****//
#define QQAppKey @"KevIQx3XezceudDi"


//#define QQId @"101409567"

//#define QQAppKey @"cb8568db8edaba5fa83cac4db84f57de"


// ***** 极光推送key *****//
#define JPushKey @"c1d3c1537b761e91e8bccdd3"

// ***** 开发或生产环境 *****//
#ifdef DEBUG
#define isProductionState NO
#else
#define isProductionState YES
#endif

// ***** log *****//
#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif




#endif /* WXHLHeader_h */
