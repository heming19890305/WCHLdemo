//
//  ZWHOrderDetailViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHOrderDetailViewController.h"

#import "ZWHOrderHeaderView.h"
#import "ZWHOrderFooterView.h"
#import "PasswordView.h"
#import "ZWHPayPasViewController.h"
#import "ZWHLogisticsViewController.h"

#import "ZWHOrderAdressTableViewCell.h"
#import "ZWHChoseAdreTableViewCell.h"
#import "KJChangeUserInfoTableViewCell.h"
#import "ZWHDoubleTableViewCell.h"
#import "ZWHOrderTableViewCell.h"
#import "ZWHChoosePayWayView.h"
#import "ZWHShopCarViewController.h"

#define ADCELL @"ZWHOrderAdressTableViewCell"
#define CHCELL @"ZWHChoseAdreTableViewCell"
#define KJCHCELL @"KJChangeUserInfoTableViewCell"
#define DOCELL @"ZWHDoubleTableViewCell"
#define ORCELL @"ZWHOrderTableViewCell"

@interface ZWHOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)ZWHOrderHeaderView *headerView;

@property(nonatomic,strong)ZWHOrderFooterView *footerView;
@property(nonatomic,strong)PasswordView *pdView;

@property(nonatomic,strong)UIButton *backgroundBtn;

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *valueArray;
@property(nonatomic,strong)ZWHChoosePayWayView *paywayView;

@end

@implementation ZWHOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"支付方式：",@"配送方式：",@"赠送工分个数：",@"单日工分单价：",@"赠送工分市值："];
    _valueArray = @[_model.payWay,_model.sendWay,_model.scoreNum,_model.scorePrice,_model.scoreMoney];
    [self creatView];
    
    NOTIFY_ADD(refresh,@"paySuccessAliPay");
    NOTIFY_ADD(payfaild, @"cancelOrderWayChat");
    if (_isAlipayfail == YES) {
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
        self.navigationController.fd_interactivePopDisabled = NO;
    }
    [self leftbtn];

}
- (void)leftbtn{
    UIButton*_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 28, 28);
    [_backBtn setImage:[UIImage imageNamed:@"left_fanhui"] forState:UIControlStateNormal];
    _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backClick{
    if (_isAlipayfail == YES) {
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[ZWHShopCarViewController class]]) {
                [self.navigationController popToViewController:vc animated:true];
                break;
            }
        }
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)refresh{
    NOTIFY_POST(@"orderlist");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)payfaild{
    //ShowSuccessWithStatus(@"支付取消");
}
-(void)dealloc{
    NOTIFY_REMOVE(@"paySuccessAliPay");
    NOTIFY_REMOVE(@"cancelOrderWayChat");
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.model = _model;
    self.tableView.tableFooterView = self.footerView;
    self.footerView.model = _model;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[ZWHOrderAdressTableViewCell class] forCellReuseIdentifier:ADCELL];
    
    [self.tableView registerClass:[ZWHChoseAdreTableViewCell class] forCellReuseIdentifier:CHCELL];
    
    [self.tableView registerClass:[KJChangeUserInfoTableViewCell class] forCellReuseIdentifier:KJCHCELL];
    
    [self.tableView registerClass:[ZWHDoubleTableViewCell class] forCellReuseIdentifier:DOCELL];
    
    [self.tableView registerClass:[ZWHOrderTableViewCell class] forCellReuseIdentifier:ORCELL];
    
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
    
    UIButton *rightB = self.footerView.rightBtn;
    UIButton *leftB = self.footerView.centerBtn;
    
    [leftB addTarget:self action:@selector(leftClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightB addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView.leftBtn addTarget:self action:@selector(delOrder) forControlEvents:UIControlEventTouchUpInside];
    
    switch ([_model.status integerValue]) {
        case 0:
        {
            [leftB setTitle:@"取消订单" forState:0];
            [rightB setTitle:@"付款" forState:0];
            [rightB setTitleColor:[UIColor redColor] forState:0];
            rightB.layer.borderColor = [UIColor redColor].CGColor;
        }
            break;
        case 1:
        {
            [leftB setTitle:@"取消订单" forState:0];
            [rightB setTitle:@"付款" forState:0];
            [rightB setTitleColor:[UIColor redColor] forState:0];
            rightB.layer.borderColor = [UIColor redColor].CGColor;
            leftB.hidden = YES;
            rightB.hidden = YES;
        }
            break;
        case 2:
        {
            [leftB setTitle:@"确认收货" forState:0];
            [rightB setTitle:@"查看物流" forState:0];
            rightB.layer.borderColor = LINECOLOR.CGColor;
            [rightB setTitleColor:ZWHCOLOR(@"999999") forState:0];
            if ([_ordermodel.logisticstype isEqualToString:@"2"]) {
                rightB.hidden = YES;
            }
        }
            break;
        case 3:
        {
            [leftB setTitle:@"" forState:0];
            [rightB setTitle:@"查看物流" forState:0];
            rightB.layer.borderColor = LINECOLOR.CGColor;
            [rightB setTitleColor:ZWHCOLOR(@"999999") forState:0];
            leftB.hidden = YES;
            self.footerView.leftBtn.hidden = NO;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 左右按钮点击事件
-(void)leftClicked:(UIButton *)sender{
    ZWHOrderModel *model = _model;
    switch ([model.status integerValue]) {
        case 0:
            [self cancelOrder:model];
            break;
        case 2:
            [self sureOrder:model];
            break;
        default:
            break;
    }
}

-(void)rightClicked:(UIButton *)sender{
    ZWHOrderModel *model = _model;
    ZWHGoodsModel *goodsmodel = _ordermodel.goodsList[0];
    switch ([model.status integerValue]) {
        case 0:
            [self topay:model];
            break;
        case 2:
            [self showLogistics:model withgoodsmodel:goodsmodel];
            break;
        case 3:
            [self showLogistics:model withgoodsmodel:goodsmodel];
            break;
        default:
            break;
    }
}

//删除订单
-(void)delOrder{
    [HttpHandler getdelOrder:@{@"orderId":_model.id,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"删除成功");
            NOTIFY_POST(@"orderlist");
            ONEPOP
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

//取消订单
-(void)cancelOrder:(ZWHOrderModel *)model{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.id forKey:@"orderId"];
    [dict setValue:[UserManager token] forKey:@"v_weichao"];
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),model.id);
    [HttpHandler getcancelOrder:dict Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"取消成功");
            NOTIFY_POST(@"orderlist");
            ONEPOP
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
    
    /*
     ZWHRecharSuccessViewController *vc = [[ZWHRecharSuccessViewController alloc]init];
     [weakSelf presentViewController:vc animated:YES completion:nil];
     */
    
}

-(void)dismisChooseView{
    [_backgroundBtn removeFromSuperview];
    [_pdView removeFromSuperview];
}

//查看物流
-(void)showLogistics:(ZWHOrderModel *)model withgoodsmodel:(ZWHGoodsModel *)goodsmodel{
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),model.id);
    ZWHLogisticsViewController *vc = [[ZWHLogisticsViewController alloc]init];
    goodsmodel.goodslogNum = _ordermodel.goodsList.count;
    vc.goodsmodel = goodsmodel;
    vc.orderId = model.id;
    vc.title = @"物流信息";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//付款
-(void)topay:(ZWHOrderModel *)model{
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),model.id);
    MJWeakSelf
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundBtn.backgroundColor = [UIColor blackColor];
    _backgroundBtn.alpha = 0.5;
    [_backgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_backgroundBtn];
    _backgroundBtn.sd_layout
    .topEqualToView(window)
    .leftEqualToView(window)
    .rightEqualToView(window)
    .bottomEqualToView(window);
    _paywayView = [[ZWHChoosePayWayView alloc]init];
    _paywayView.returnway = ^(NSInteger payidx) {
        NSLog(@"%ld",payidx);
        [weakSelf dismisChooseView];
        [weakSelf paytoClicked:model way:payidx];
    };
    [window addSubview:_paywayView];
}
//支付
-(void)paytoClicked:(ZWHOrderModel *)model way:(NSInteger)payway{
    MJWeakSelf
    if (payway == 1) {
        ShowProgress
        NotAllowUser
        [HttpHandler getorderPay:@{@"orderId":model.id,@"v_weichao":[UserManager token],@"payWay":@(payway)} Success:^(id obj) {
            if (ReturnValue == 200) {
                Dismiss
                [weakSelf aliPay:obj[@"data"][@"payBody"] urlScheme:@"com.ZWHWXHL.cn.WXHL"];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }else{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundBtn.backgroundColor = [UIColor blackColor];
        _backgroundBtn.alpha = 0.5;
        [_backgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:_backgroundBtn];
        _backgroundBtn.sd_layout
        .topEqualToView(window)
        .leftEqualToView(window)
        .rightEqualToView(window)
        .bottomEqualToView(window);
        _pdView = [[PasswordView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(210), self.view.bounds.size.width, SCREENHIGHT - HEIGHT_TO(210))];
        _pdView.returnPasswordStringBlock = ^(NSString *password){
            [weakSelf dismisChooseView];
            ShowProgress
            NotAllowUser
            [HttpHandler getorderPay:@{@"orderId":model.id,@"v_weichao":[UserManager token],@"payWay":@(payway),@"payPwd":password} Success:^(id obj) {
                if (ReturnValue == 200) {
                    Dismiss
                    ShowSuccessWithStatus(@"支付成功");
                    NOTIFY_POST(@"orderlist");
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        });
                }else{
                    ShowInfoWithStatus(ErrorMessage);
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
            }];
        };
        _pdView.dismissV = ^{
            [weakSelf.backgroundBtn removeFromSuperview];
            [weakSelf.pdView removeFromSuperview];
        };
        
        _pdView.findpw = ^{
            NSLog(@"忘记密码");
            [weakSelf dismisChooseView];
            ZWHPayPasViewController *vc = [[ZWHPayPasViewController alloc]init];
            vc.title = @"支付密码";
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [window addSubview:_pdView];
    }
}
//确认收货
-(void)sureOrder:(ZWHOrderModel *)model{
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),model.id);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.id forKey:@"orderId"];
    [dict setValue:[UserManager token] forKey:@"v_weichao"];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundBtn.backgroundColor = [UIColor blackColor];
    _backgroundBtn.alpha = 0.5;
    [_backgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_backgroundBtn];
    _backgroundBtn.sd_layout
    .topEqualToView(window)
    .leftEqualToView(window)
    .rightEqualToView(window)
    .bottomEqualToView(window);
    MJWeakSelf
    _pdView = [[PasswordView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(210), self.view.bounds.size.width, SCREENHIGHT - HEIGHT_TO(210))];
    _pdView.returnPasswordStringBlock = ^(NSString *password){
        [weakSelf dismisChooseView];
        [dict setValue:password forKey:@"payPwd"];
        ShowProgress
        NotAllowUser
        [HttpHandler getconfirmReceipt:dict Success:^(id obj) {
            if (ReturnValue == 200) {
                ShowSuccessWithStatus(@"确认成功");
                NOTIFY_POST(@"orderlist");
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    };
    _pdView.dismissV = ^{
        [weakSelf.backgroundBtn removeFromSuperview];
        [weakSelf.pdView removeFromSuperview];
    };
    
    _pdView.findpw = ^{
        NSLog(@"忘记密码");
        [weakSelf dismisChooseView];
        ZWHPayPasViewController *vc = [[ZWHPayPasViewController alloc]init];
        vc.title = @"支付密码";
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    [window addSubview:_pdView];
}


#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section == 1) {
        return _model.goods.count;
    }
    
    if (section == 2) {
        return 6;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HEIGHT_TO(75);
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return HEIGHT_TO(66);
        }
        return HEIGHT_TO(40);
    }
    if (indexPath.section == 1) {
        return HEIGHT_TO(100);
    }
    return HEIGHT_TO(96);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return HEIGHT_TO(10);
    }
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ZWHOrderAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ordermodel = _model;
        return cell;
    }else if (indexPath.section == 1){
        ZWHOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ORCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ordermodel = _model.goods[indexPath.row];
        return cell;
    }else{
        if (indexPath.row == 0) {
            ZWHDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DOCELL forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.num.text = _model.orderNo;
            cell.time.text = _model.createTime;
            return cell;
        }else{
            KJChangeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KJCHCELL forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentTex.enabled = NO;
            cell.leftTitleStr = _titleArray[indexPath.row - 1];
            cell.contentTex.text = _valueArray[indexPath.row - 1];
            cell.contentTex.textColor = [UIColor grayColor];
            cell.contentTex.font = FontWithSize(14);
            [cell.leftLable textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
            return cell;
        }
    }
}


#pragma mark - getter
-(ZWHOrderHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZWHOrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(90))];
    }
    return _headerView;
}

-(ZWHOrderFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[ZWHOrderFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(180))];
    }
    return _footerView;
}

#pragma mark - 支付宝支付
- (void)aliPay:(NSString *)url urlScheme:(NSString *)urlScheme
{
    NSLog(@"%@ -- %@",url,urlScheme);
    
    //[url stringByReplacingOccurrencesOfString:@"——" withString:@""];
    [[AlipaySDK defaultService] payUrlOrder:url fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultCode"] isEqualToString:@"6001"]) {
            [SVProgressHUD showSuccessWithStatus:@"取消支付"];
        }else if ([resultDic[@"resultCode"] isEqualToString:@"4000"]) {
            [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
        }else if ([resultDic[@"resultCode"] isEqualToString:@"6002"]) {
            [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
        }if ([resultDic[@"resultCode"] isEqualToString:@"9000"]) {
        }
    }];
}

@end
