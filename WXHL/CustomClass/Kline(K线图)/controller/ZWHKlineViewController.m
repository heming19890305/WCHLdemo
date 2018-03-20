//
//  ZWHKlineViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/6.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHKlineViewController.h"
#import <WebViewJavascriptBridge.h>
#import "ZWHNumBtnTableViewCell.h"
#import "ZWHLeRiTableViewCell.h"
#import "ZWHKSixTableViewCell.h"

#import "ZWHChoseDayView.h"

#define NLCELL @"ZWHNumBtnTableViewCell"
#define LRCELL @"ZWHLeRiTableViewCell"
#define SICELL @"ZWHKSixTableViewCell"
#define NORCELL @"uitablecell"

@interface ZWHKlineViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *titView;
@property(nonatomic,strong)UILabel *tit;

@property(nonatomic,strong)ZWHChoseDayView *rigview;

@property(nonatomic,strong)UIButton *backgroundBtn;
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic,strong) WebViewJavascriptBridge* bridge;

@property(nonatomic,strong)NSMutableArray *orderArr;

@property(nonatomic,strong)NSMutableArray *topArr;

@property(nonatomic,strong)NSMutableArray *botArr;
@property(nonatomic,strong)UIButton *btnday;

@end

@implementation ZWHKlineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderArr = [NSMutableArray array];
    _topArr = [NSMutableArray array];
    _botArr = [NSMutableArray array];
    self.backBtn.hidden = YES;
    [self creatView];
    [self getData];
    MJWeakSelf
    [HttpHandler getSelectDay:@{} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
             weakSelf.tableView.tableHeaderView = self.webView;
            [weakSelf changedayData:obj[@"data"][0][@"day"]];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
    
}


-(void)getData{
    MJWeakSelf
    [HttpHandler getCurOrderStatistics:@{} Success:^(id obj) {
        if (ReturnValue == 200) {
            [weakSelf.orderArr addObject:obj[@"data"][@"num"] ];
            [weakSelf.orderArr addObject:obj[@"data"][@"amount"]];
            [weakSelf.tableView reloadData];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
    [HttpHandler getCurWorkPoints:@{} Success:^(id obj) {
        if (ReturnValue == 200) {
            [weakSelf.topArr addObject:obj[@"data"][@"initPrice"]];
            [weakSelf.topArr addObject:obj[@"data"][@"publishTotalNum"]];
            [weakSelf.topArr addObject:obj[@"data"][@"curPrice"]];
            [weakSelf.topArr addObject:obj[@"data"][@"yesterdayPrice"]];
            
            [weakSelf.botArr addObject:[NSString stringWithFormat:@"%.2f",[obj[@"data"][@"scoreNum"] floatValue]]];
            [weakSelf.botArr addObject:[NSString stringWithFormat:@"%.2f",[obj[@"data"][@"scoreMoney"] floatValue]]];
            [weakSelf.botArr addObject:obj[@"data"][@"curPrice"]];
            [weakSelf.botArr addObject:obj[@"data"][@"yesterdayPrice"]];
            [weakSelf.botArr addObject:[NSString stringWithFormat:@"%@%%",obj[@"data"][@"rate"]]];
            [weakSelf.botArr addObject:obj[@"data"][@"totalMoney"]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf.tableView.mj_header endRefreshing];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}



-(void)creatView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - TAB_HEIGHT) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    [self.tableView registerClass:[ZWHNumBtnTableViewCell class] forCellReuseIdentifier:NLCELL];
    
    [self.tableView registerClass:[ZWHLeRiTableViewCell class] forCellReuseIdentifier:LRCELL];
    
    [self.tableView registerClass:[ZWHKSixTableViewCell class] forCellReuseIdentifier:SICELL];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NORCELL];
    
    self.navigationItem.titleView = self.titView;
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    [self.view addSubview:self.tableView];
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.orderArr = [NSMutableArray array];
        weakSelf.topArr = [NSMutableArray array];
        weakSelf.botArr = [NSMutableArray array];
        [weakSelf getData];
    }];
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(45);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(45))];
    view.backgroundColor = GRAYBACKCOLOR;
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:16 textColor:MAINCOLOR backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .centerYEqualToView(view)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(80));
    lab.text = section==1?@"工分":@"订单";
    
    UILabel *rig = [[UILabel alloc]init];
    [rig textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    [view addSubview:rig];
    rig.sd_layout
    .rightSpaceToView(view, WIDTH_TO(15))
    .centerYEqualToView(view)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(80));
    rig.text = @"单位:元/个";
    rig.hidden = section==0?NO:YES;
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 && indexPath.section == 0) {
        return HEIGHT_TO(100);
    }else if (indexPath.row == 0 && indexPath.section == 0){
        return HEIGHT_TO(80);
    }
    return HEIGHT_TO(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*if (indexPath.section == 0) {
        ZWHNumBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NLCELL forIndexPath:indexPath];
        cell.introColor = [UIColor redColor];
        cell.titArray = @[@"本周最高",@"累计卖出",@"涨幅"];
        cell.dataArray = @[@"4.4040",@"2.6070",@"1.8407%"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else*/ if (indexPath.section == 0){
        if (indexPath.row == 0) {
            ZWHNumBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NLCELL forIndexPath:indexPath];
            cell.introColor = [UIColor grayColor];
            cell.titArray = @[@"原始价格(元)",@"发行总量(个)",@"当前价格(元)",@"昨日收盘(元)"];
            if (_topArr.count > 0) {
                cell.dataArray = _topArr;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ZWHKSixTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SICELL forIndexPath:indexPath];
            cell.titArray = @[@"日交易量",@"日交易额(元)",@"今日单价(元)",@"昨日单价(元)",@"轮值回购",@"总市值(元)"];
            if (_botArr.count > 0) {
                cell.dataArray = _botArr;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        ZWHLeRiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRCELL forIndexPath:indexPath];
        cell.type.text = @"今日订单(笔) ";
        cell.yue.text = @"订单金额(元) 万";
        [cell.type textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [cell.yue textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        if (_orderArr.count == 2) {
            cell.type.text = [NSString stringWithFormat:@"今日订单(笔)  %@",_orderArr[0]];
            cell.yue.text = [NSString stringWithFormat:@"订单金额(元)  %@",_orderArr[1]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(UIWebView *)webView{
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 280)];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        //设置第三方Bridge是否可用
        [WebViewJavascriptBridge enableLogging];
        
        //WebViewJavascriptBridge *bridge = [[WebViewJavascriptBridge alloc]init];
        //关联webView和bridge
        //WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        
        // 初始化*WebViewJavascriptBridge*实例,设置代理,进行桥接
        
        _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        [_bridge setWebViewDelegate:self];
    }
    return _webView;
}

#pragma mark - 切换天数
-(void)changeDay:(UIButton *)sender{
    [self showEX];
}

-(void)changedayData:(NSString *)day{
    MJWeakSelf
    [HttpHandler getKlineData:@{@"day":day} Success:^(id obj) {
    
        if (ReturnValue == 200) {
            weakSelf.webView = nil;
            weakSelf.tableView.tableHeaderView = weakSelf.webView;
            NSString *json = [weakSelf convertToJsonData:obj];
            [weakSelf.bridge callHandler:@"callMobile" data:json responseCallback:^(id responseData) {
                NSLog(@"abc");
            }];
           // [weakSelf.webView loadHTMLString:htmlCont baseURL:baseURL];
            
            
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"Kline"]]]];
            //[weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cssc.ccyskj.com/wchl/"]]];
            weakSelf.tit.text = [NSString stringWithFormat:@"最近%@天",day];
        }
    } failed:^(id obj) {
        
    }];
}

-(void)showEX{
    MJWeakSelf
    [HttpHandler getSelectDay:@{} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            [UserManager sharedData].dayArray = obj[@"data"];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            weakSelf.backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            weakSelf.backgroundBtn.backgroundColor = [UIColor clearColor];
            [weakSelf.backgroundBtn addTarget:self action:@selector(dismisEXView) forControlEvents:UIControlEventTouchUpInside];
            [window addSubview:weakSelf.backgroundBtn];
            weakSelf.backgroundBtn.sd_layout
            .topEqualToView(window)
            .leftEqualToView(window)
            .rightEqualToView(window)
            .bottomEqualToView(window);
            
            weakSelf.rigview = [[ZWHChoseDayView alloc]init];
            weakSelf.rigview.didinput = ^(NSString *day) {
                [weakSelf dismisEXView];
                [weakSelf changedayData:day];
            };
            [window addSubview:weakSelf.rigview];
            [weakSelf.rigview showViewWith:weakSelf.titView.frame];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
    
}

-(void)dismisEXView{
    [_backgroundBtn removeFromSuperview];
    [_rigview removeFromSuperview];
}

#pragma mark - getter

-(UIView *)titView{
    if (!_titView) {
        _titView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_TO(80), 40)];
        _tit = [[UILabel alloc]init];
        _tit.text = @"最近7天";
        [_tit textFont:17 textColor:MAINCOLOR backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [_titView addSubview:_tit];
        _tit.sd_layout
        .leftEqualToView(_titView)
        .autoHeightRatio(0)
        .centerYEqualToView(_titView)
        .widthIs(WIDTH_TO(80));
        
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"xia_jt")];
        [_titView addSubview:img];
        img.sd_layout
        .leftSpaceToView(_tit, 0)
        .widthIs(WIDTH_TO(15))
        .heightEqualToWidth()
        .centerYEqualToView(_titView);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(changeDay:) forControlEvents:UIControlEventTouchUpInside];
        _btnday = btn;
        [_titView addSubview:btn];
        btn.sd_layout
        .leftEqualToView(_titView)
        .topEqualToView(_titView)
        .bottomEqualToView(_titView)
        .rightEqualToView(_titView);
    }
    return _titView;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

@end
