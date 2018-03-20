//
//  ZWHC2fGoodViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHC2fGoodViewController.h"
#import "ZWHGoodDetailViewController.h"
#import "ZWHOrderDetailViewController.h"
#import "ZWHSureOrderViewController.h"
#import "ZWHShopCarViewController.h"
#import "ZWHNorGoodModel.h"

#import "ZWHDoodsHeaderView.h"
#import "ZSNorSelectView.h"
#import "ZWHEvaluationViewController.h"
#import "ZWHEvaModel.h"

#import "ZWHEvaluationTableViewCell.h"

#define EVACELL @"ZWHEvaluationTableViewCell"

@interface ZWHC2fGoodViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,DismissDelegate>

@property(nonatomic,strong)UIView *nav;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)ZWHDoodsHeaderView *headerView;

@property(nonatomic,strong)UIButton *goodB;

@property (nonatomic, strong)UIWebView *detailWebView;

@property(nonatomic,strong)UIButton *norsB;

@property(nonatomic,strong)UIButton *collectB;

//加入购物车数据
@property(nonatomic,strong)NSMutableDictionary *carDict;

//规格视图
@property(nonatomic,strong)ZSNorSelectView *selectView;

@property(nonatomic,strong)UIButton *backgroundBtn;

@property(nonatomic,strong)ZWHEvaModel *evamodel;

@property(nonatomic,assign)NSInteger btntag;
@property(nonatomic,copy)NSString *shareurl;

@end

@implementation ZWHC2fGoodViewController

-(void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    self.navigationController.navigationBar.contentMode = UIViewContentModeScaleAspectFill;
    //self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    [self getEvaluData];
    [self.view addSubview:self.nav];
    [self creatBottomView];
    NOTIFY_ADD(disappear:, @"dismissShareViewNotify");
}

-(void)dealloc{
    NOTIFY_REMOVE(@"dismissShareViewNotify");
}
-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_TO(50)) style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.detailWebView;
    [self showDetail];
    self.headerView.c2fmodel = _model;
    [self.tableView registerClass:[ZWHEvaluationTableViewCell class] forCellReuseIdentifier:EVACELL];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    // [self.detailWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}


/*-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
 if ([keyPath isEqualToString:@"contentSize"]) {
 CGSize fsize = [self.detailWebView sizeThatFits:CGSizeZero];
 self.detailWebView.frame = CGRectMake(0, 0, SCREENWIDTH, fsize.height);
 [self.tableView beginUpdates];
 self.tableView.tableFooterView = self.detailWebView;
 [self.tableView endUpdates];
 }
 }*/

#pragma mark - 评论数据
-(void)getEvaluData{
    MJWeakSelf
    [HttpHandler getCommentList:@{@"id":_model.id,@"pageNo":@"1",@"pageSize":@"1",@"type":_state} Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"][@"list"] count] > 0) {
                weakSelf.evamodel = [ZWHEvaModel mj_objectWithKeyValues:[obj[@"data"][@"list"] firstObject]];
                weakSelf.evamodel.cou = obj[@"data"][@"count"];
                [weakSelf.tableView reloadData];
            }
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}


#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        /*if (_evamodel) {
            return 1;
        }*/
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_evamodel) {
        return HEIGHT_TO(180);
    }
    return HEIGHT_TO(45);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EVACELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_evamodel) {
        cell.model = _evamodel;
    }
    [cell.showall addTarget:self action:@selector(gettoEva) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 评价
-(void)gettoEva{
    ZWHEvaluationViewController *vc = [[ZWHEvaluationViewController alloc]init];
    vc.goodid = _goodId;
    vc.state = _state;
    vc.title = @"全部评价";
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (_evamodel) {
            return HEIGHT_TO(10);
        }
        return HEIGHT_TO(10);
    }
    return HEIGHT_TO(40);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return CGFLOAT_MIN;
    }
    return HEIGHT_TO(10);
    /*if (section == 0) {
     if (_evamodel) {
     return HEIGHT_TO(10);
     }
     return CGFLOAT_MIN;
     }
     return CGFLOAT_MIN;*/
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc]init];
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(40))];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        _goodB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goodB setTitleColor:ZWHCOLOR(@"666666") forState:0];
        //[_goodB setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_goodB addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        _goodB.titleLabel.font = FontWithSize(14);
        _goodB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        if ([_model.details length]==0) {
            [_goodB setTitle:@"暂无商品详情" forState:0];
            [_goodB setTitleColor:[UIColor grayColor] forState:0];
        }else{
            [_goodB setTitle:@"商品详情" forState:0];
           // [self showDetail:_goodB];
        }
        [view addSubview:_goodB];
        _goodB.sd_layout
        .leftSpaceToView(view, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(40))
        .widthIs(WIDTH_TO(100))
        .centerYEqualToView(view);
        
        _norsB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_norsB setTitleColor:[UIColor grayColor] forState:0];
        [_norsB setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_norsB addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        _norsB.titleLabel.font = FontWithSize(14);
        _norsB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_norsB setTitle:@"规格参数" forState:0];
        //[view addSubview:_norsB];
        _norsB.sd_layout
        .leftSpaceToView(_goodB, WIDTH_TO(5))
        .heightIs(HEIGHT_TO(40))
        .widthIs(WIDTH_TO(80))
        .centerYEqualToView(view);
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LINECOLOR;
        [view addSubview:line];
        line.sd_layout
        .bottomEqualToView(view)
        .leftEqualToView(view)
        .rightEqualToView(view)
        .heightIs(1);
        
        return view;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

#pragma mark - 底部点击事件
-(void)bottomClicked:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    self.btntag = sender.tag;
    switch (sender.tag) {
        case 140:
        {
            if ([[UserManager token]length] ==0) {
                [self getLogin];
                return;
            }
            if (_model.extendLists.count>0) {
                [self showNorSelectView];
            }else{
                [self getoPay];
            }
        }
            break;
        case 130:
        {
            if ([[UserManager token]length] ==0) {
                [self getLogin];
                return;
            }
            if (_model.extendLists.count>0) {
                [self showNorSelectView];
            }else{
                [self jhoninShopCar];
            }
        }
            break;
        case 120:
        {
            if ([[UserManager token]length] ==0) {
                [self getLogin];
                return;
            }
            [self getcollect];
        }
            break;
        case 110:
        {
            MJWeakSelf
            [HttpHandler getDictInfo:@{@"type":@"appdown"} Success:^(id obj) {
                if (ReturnValue == 200) {
                    weakSelf.shareurl =obj[@"data"][0][@"code"];
                    [weakSelf share];
                }
            } failed:^(id obj) {
                
            }];
        }
            break;
        case 100:
        {
            [self getphone];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 收藏
-(void)getcollect{
    MJWeakSelf
    [HttpHandler getaddCollection:@{@"goodid":_goodId,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"收藏成功");
            weakSelf.collectB.selected = YES;
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - 底部视图
-(void)creatBottomView{
    UIView *view = [[UIView alloc]init];
    view.layer.shadowColor = LINECOLOR.CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.sd_layout
    .leftSpaceToView(self.view, 0)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(HEIGHT_PRO(50));
    
    
    UIButton *inshop = [UIButton buttonWithType:UIButtonTypeCustom];
    [inshop setImage:ImageNamed(@"客服") forState:0];
    inshop.tag = 100;
    [inshop addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [inshop setTitleColor:ZWHCOLOR(@"6f6f6f") forState:0];
    inshop.titleLabel.font = FontWithSize(11);
    [view addSubview:inshop];
    inshop.sd_layout
    .leftSpaceToView(view, 0)
    .widthIs(WIDTH_PRO(60))
    .heightIs(HEIGHT_PRO(50)*0.7)
    .topEqualToView(view);
    inshop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    inshop.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:11 textColor:ZWHCOLOR(@"6f6f6f") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    lab.text = @"客服";
    [view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(view, 0)
    .widthIs(WIDTH_PRO(60))
    .bottomSpaceToView(view, 0)
    .heightIs(HEIGHT_PRO(50)/2);
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LINECOLOR;
    [view addSubview:line];
    line.sd_layout
    .leftSpaceToView(inshop, 0)
    .widthIs(1)
    .topSpaceToView(view, HEIGHT_PRO(5))
    .bottomSpaceToView(view, HEIGHT_PRO(5));
    
    
    UIButton *inshop1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [inshop1 setImage:ImageNamed(@"分享") forState:0];
    inshop1.tag = 110;
    [inshop1 addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [inshop1 setTitleColor:ZWHCOLOR(@"6f6f6f") forState:0];
    inshop1.titleLabel.font = FontWithSize(11);
    [view addSubview:inshop1];
    inshop1.sd_layout
    .leftSpaceToView(line, 0)
    .widthIs(WIDTH_PRO(60))
    .heightIs(HEIGHT_PRO(50)*0.7)
    .topEqualToView(view);
    inshop1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    inshop1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel *lab1 = [[UILabel alloc]init];
    [lab1 textFont:11 textColor:ZWHCOLOR(@"6f6f6f") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    lab1.text = @"分享";
    [view addSubview:lab1];
    lab1.sd_layout
    .leftSpaceToView(line, 0)
    .widthIs(WIDTH_PRO(60))
    .bottomSpaceToView(view, 0)
    .heightIs(HEIGHT_PRO(50)/2);
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = LINECOLOR;
    [view addSubview:line1];
    line1.sd_layout
    .leftSpaceToView(inshop1, 0)
    .widthIs(1)
    .topSpaceToView(view, HEIGHT_PRO(5))
    .bottomSpaceToView(view, HEIGHT_PRO(5));
    
    _collectB = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectB setImage:ImageNamed(@"收藏") forState:0];
    [_collectB setImage:ImageNamed(@"已收藏") forState:UIControlStateSelected];
    _collectB.tag = 120;
    [_collectB addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_collectB setTitleColor:ZWHCOLOR(@"6f6f6f") forState:0];
    _collectB.titleLabel.font = FontWithSize(11);
    //[view addSubview:_collectB];
    _collectB.sd_layout
    .leftSpaceToView(line1, 0)
    .widthIs(WIDTH_PRO(60))
    .heightIs(HEIGHT_PRO(50)*0.7)
    .topEqualToView(view);
    _collectB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _collectB.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel *lab2 = [[UILabel alloc]init];
    [lab2 textFont:11 textColor:ZWHCOLOR(@"6f6f6f") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    lab2.text = @"收藏";
    //[view addSubview:lab2];
    lab2.sd_layout
    .leftSpaceToView(line1, 0)
    .widthIs(WIDTH_PRO(60))
    .bottomSpaceToView(view, 0)
    .heightIs(HEIGHT_PRO(50)/2);
    
    UIButton *addcar = [UIButton buttonWithType:UIButtonTypeCustom];
    [addcar setTitle:@"加入购物车" forState:0];
    [addcar setTitleColor:[UIColor whiteColor] forState:0];
    addcar.titleLabel.font = FontWithSize(16);
    addcar.backgroundColor = ZWHCOLOR(@"ffa539");
    //[addcar.titleLabel textFont:16 textColor:ZWHCOLOR(@"292929") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    addcar.tag = 130;
    [addcar addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addcar];
    addcar.sd_layout
    .leftSpaceToView(line1, 0)
    .widthIs(WIDTH_PRO(100))
    .heightIs(HEIGHT_TO(50))
    .bottomSpaceToView(view, 0);
    
    UIButton *pay = [UIButton buttonWithType:UIButtonTypeCustom];
    [pay setTitle:@"立刻购买" forState:0];
    pay.backgroundColor = ZWHCOLOR(@"ff5555");
    [pay.titleLabel textFont:16 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    pay.tag = 140;
    [pay addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:pay];
    pay.sd_layout
    .leftSpaceToView(addcar, 0)
    .rightSpaceToView(view, 0)
    .heightIs(HEIGHT_PRO(50))
    .bottomSpaceToView(view, 0);
}

#pragma mark 查看详情
-(void)showDetail{
    //sender.selected = !sender.selected;
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:15px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>",_model.details];
    [_detailWebView loadHTMLString:htmlString baseURL:nil];
    /*"for(var p in  $img){\n"
     " $img[p].style.width = '100%%';\n"
     "$img[p].style.height ='auto'\n"
     "}\n"*/
}

#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    [self.detailWebView stringByEvaluatingJavaScriptFromString:js];
    [self.detailWebView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    
    // 获取webView的高度
    CGFloat webViewHeight = [[self.detailWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    NSLog(@"%.f", webViewHeight);
    self.detailWebView.frame = CGRectMake(0, 0, SCREENWIDTH, webViewHeight);
    self.tableView.tableFooterView = self.detailWebView;
    [self.tableView reloadData];
}

-(void)showNorSelectView{
    //添加规格视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backgroundBtn];
    self.selectView = [[ZSNorSelectView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT/2)];
    [self.selectView.certainBtn addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
    self.selectView.dismissDelegate = self;
    [window addSubview:self.selectView];
    [self.selectView didChangeHeight:^(CGFloat height) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundBtn.alpha = 0.5;
            self.selectView.frame = CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
        }];
    }];
    self.selectView.nowprice = _model.nowPrice;
    self.selectView.model = _model;
}

#pragma mark - 规格确定
-(void)certain{
    NSLog(@"%@",self.selectView.normsString);
    
    if ([self.selectView.productId length] == 0) {
        ShowInfoWithStatus(@"请选择规格");
        return;
    }
    [self dismissView];
    NSLog(@"%@-----数量%ld",self.selectView.productId,self.selectView.selectNumber);
    switch (_btntag) {
        case 140:
            [self getoPay];
            break;
        case 130:
            [self jhoninShopCar];
            break;
        default:
            break;
    }
}

#pragma mark - 立即购买
-(void)getoPay{
    [self getDictinfo];
    NSLog(@"%@",[UserManager token]);
    MJWeakSelf
    [HttpHandler getaddShopCar:_carDict Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"已加入购物车");
            ZWHShopCarViewController *vc = [[ZWHShopCarViewController alloc]init];
            vc.isSpe = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}
#pragma mark - 电话
-(void)getphone{
    [HttpHandler getDictInfo:@{@"type":@"telephone"} Success:^(id obj) {
        if (ReturnValue == 200) {
            [ZSCallManager sharedCall].phoneNumber = obj[@"data"][0][@"code"];
        }
    } failed:^(id obj) {
        
    }];
}

#pragma mark - 加入购物车
-(void)jhoninShopCar{
    [self getDictinfo];
    [HttpHandler getaddShopCar:_carDict Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"已加入购物车");
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - 获得加入购物车数据
-(void)getDictinfo{
    _carDict = [NSMutableDictionary dictionary];
    if (self.selectView.norDict) {
        ZWHNorGoodModel *mo = [ZWHNorGoodModel mj_objectWithKeyValues:self.selectView.norDict];
        [_carDict setValue:_model.id forKey:@"goodid"];
        [_carDict setValue:mo.id forKey:@"attrid"];
        [_carDict setValue:ZWHINTTOSTR(self.selectView.selectNumber) forKey:@"num"];
        [_carDict setValue:mo.price forKey:@"price"];
        NSString *str = [[UserManager token] copy];
        [_carDict setValue:str forKey:@"v_weichao"];
        [_carDict setValue:_state forKey:@"type"];
    }else{
        [_carDict setValue:_model.id forKey:@"goodid"];
        //[_carDict setValue:_model.attrId forKey:@"attrid"];
        [_carDict setValue:@"1" forKey:@"num"];
        [_carDict setValue:_model.salePrice forKey:@"price"];
        [_carDict setValue:[UserManager token] forKey:@"v_weichao"];
        [_carDict setValue:_state forKey:@"type"];
    }
}

#pragma mark - getter

-(ZWHDoodsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZWHDoodsHeaderView alloc]init];
    }
    return _headerView;
}


-(UIView *)nav{
    if (!_nav) {
        _nav = [[UIView alloc]init];
        _nav.userInteractionEnabled = YES;
        _nav.backgroundColor = [UIColor clearColor];
        _nav.frame = CGRectMake(0, STATES_HEIGHT, SCREENWIDTH,44 );
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        //[back setImage:ImageNamed(@"lenft_fh1") forState:0];
        [back setBackgroundImage:ImageNamed(@"箭头左") forState:0];
        [back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nav addSubview:back];
        back.sd_layout
        .leftSpaceToView(_nav, WIDTH_TO(15))
        .centerYEqualToView(_nav)
        .heightIs(HEIGHT_TO(25))
        .widthEqualToHeight();
        
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:17 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        lab.text = @"";
        [_nav addSubview:lab];
        lab.sd_layout
        .centerYEqualToView(_nav)
        .autoHeightRatio(0)
        .centerXEqualToView(_nav);
        [lab setSingleLineAutoResizeWithMaxWidth:100];
        [lab updateLayout];
        
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:ImageNamed(@"类目") forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        [_nav addSubview:btn];
        btn.sd_layout
        .rightSpaceToView(_nav, WIDTH_TO(15))
        .centerYEqualToView(_nav)
        .heightIs(HEIGHT_TO(25))
        .widthEqualToHeight();
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        UIButton *car = [UIButton buttonWithType:UIButtonTypeCustom];
        [car setBackgroundImage:ImageNamed(@"购物车空") forState:0];
        [car setTitleColor:[UIColor whiteColor] forState:0];
        [car addTarget:self action:@selector(showShopCar) forControlEvents:UIControlEventTouchUpInside];
        car.backgroundColor = [UIColor clearColor];
        [_nav addSubview:car];
        car.sd_layout
        .rightSpaceToView(btn, WIDTH_TO(15))
        .centerYEqualToView(_nav)
        .heightIs(HEIGHT_TO(25))
        .widthEqualToHeight();
    }
    return _nav;
}

-(UIWebView *)detailWebView{
    if (!_detailWebView) {
        _detailWebView = [[UIWebView alloc]init];
        _detailWebView.delegate = self;
    }
    return _detailWebView;
}


-(UIButton *)backgroundBtn{
    if (!_backgroundBtn) {
        _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundBtn.backgroundColor = [UIColor blackColor];
        _backgroundBtn.alpha = 0;
        _backgroundBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_backgroundBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundBtn;
}

-(void)dismiss{
    [self dismissView];
}

#pragma mark - 返回的规格
-(void)inputSelectNor:(NSString *)selectinfo{
    NSLog(@"%@",selectinfo);
}

- (void)dismissView{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundBtn.alpha = 0;
        self.selectView.mj_y = SCREEN_HEIGHT*2;
    } completion:^(BOOL finished) {
        [self.backgroundBtn removeFromSuperview];
        [self.selectView removeFromSuperview];
    }];
}

- (void)share{
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
    //NSLog(@"%@",self.armodel.filePath);
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_model.masterImg]]];
    UIImage * image = [self thumbnailWithImageWithoutScale:[UIImage imageWithData:data] size:CGSizeMake(300, 300)];
    
    MJWeakSelf
    self.shareView.shareWayClick = ^(NSInteger index) {
        switch (index) {
            case 10:
            {
                
                [[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeWechatSession WithTitle:@"微超红利分享" Images:image url:[NSURL URLWithString:weakSelf.shareurl] content:weakSelf.model.name];
            }
                break;
            case 11:
            {
                /*[[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeQQFriend WithTitle:@"微超红利分享" Images:image url:[NSURL URLWithString:weakSelf.shareurl] content:weakSelf.model.name];*/
                [[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeWechatTimeline WithTitle:@"微超红利分享" Images:image url:[NSURL URLWithString:weakSelf.shareurl] content:weakSelf.model.name];
            }
                break;
                case 12:
                 {
                 [[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeQQFriend WithTitle:@"微超红利分享" Images:image url:[NSURL URLWithString:weakSelf.shareurl] content:weakSelf.model.name];
                 }
                 break;
                 case 13:
                 {
                 [[ThirdShareManager shared] sharePlatForm:SSDKPlatformSubTypeQZone WithTitle:@"微超红利分享" Images:image url:[NSURL URLWithString:weakSelf.shareurl] content:weakSelf.model.name];
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
}

#pragma mark - 隐藏分享视图
- (void)disappear:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundBtn.alpha = 0;
        [self.shareView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, HEIGHT_TO(180))];
    } completion:^(BOOL finished) {
        [self.backgroundBtn removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
}

-(void)cancelClick:(UIButton *)sender{
    [self disappear:sender];
}

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

//购物车
-(void)showShopCar{
    if ([[UserManager token]length] ==0) {
        [self getLogin];
        return;
    }
    ZWHShopCarViewController *vc = [[ZWHShopCarViewController alloc]init];
    vc.isSpe = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
