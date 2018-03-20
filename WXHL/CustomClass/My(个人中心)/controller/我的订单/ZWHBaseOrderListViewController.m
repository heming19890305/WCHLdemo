//
//  ZWHBaseOrderListViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHBaseOrderListViewController.h"


#import "ZWHLogisticsViewController.h"
#import "ZWHPayPasViewController.h"
#import "ZWHOrderTableViewCell.h"
#import "ZWHSpeOrderTableViewCell.h"
#import "ZWHJudgeViewController.h"
#import "PasswordView.h"
#import "ZWHOrderModel.h"
#import "ZWHGoodsModel.h"
#import "ZWHRecharSuccessViewController.h"
#import "ZWHOrderDetailViewController.h"
#import "ZWHChoosePayWayView.h"


#define norCell @"ZWHOrderTableViewCell.h"
#define speCell @"ZWHSpeOrderTableViewCell.h"

#define EMPCELL @"uitableview"

@interface ZWHBaseOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)PasswordView *pdView;

@property(nonatomic,strong)UIButton *backgroundBtn;
@property(nonatomic,strong)ZWHChoosePayWayView *paywayView;
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation ZWHBaseOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self creatView];
    //[self setrefresh];
    [self getData];
    NOTIFY_ADD(refresh, @"orderlist");
    NOTIFY_ADD(refresh,@"paySuccessAliPay");
    NOTIFY_ADD(payfaild, @"cancelOrderWayChat");
}

-(void)refresh{
    [self.tableView.mj_header beginRefreshing];
}

-(void)payfaild{
    //ShowSuccessWithStatus(@"支付取消");
}

-(void)dealloc{
    NOTIFY_REMOVE(@"orderlist");
    NOTIFY_REMOVE(@"paySuccessAliPay");
    NOTIFY_REMOVE(@"cancelOrderWayChat");
}

#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ZWHINTTOSTR(_index) forKey:@"pageNo"];
    [dict setValue:@"20" forKey:@"pageSize"];
    [dict setValue:[UserManager token] forKey:@"v_weichao"];
    switch ([_state integerValue]) {
        case 1:
            [dict setValue:@"0" forKey:@"status"];
            break;
        case 2:
            [dict setValue:@"2" forKey:@"status"];
            break;
        case 3:
            [dict setValue:@"3" forKey:@"status"];
            break;
        default:
            break;
    }
    
    [HttpHandler getOrder:dict Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            if ([obj[@"data"][@"list"] count] == 0) {
                weakSelf.index -- ;
            }
            [ZWHOrderModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"goodsList":@"ZWHGoodsModel"};
            }];
            [weakSelf.dataArray addObjectsFromArray:[ZWHOrderModel mj_objectArrayWithKeyValuesArray:obj[@"data"][@"list"]]];
            //[weakSelf.tableView reloadData];
            if (weakSelf.tableView) {
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf creatView];
                [self setrefresh];
            }
            [weakSelf endrefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf endrefresh];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
        [weakSelf endrefresh];
    }];
}

#pragma mark - 刷新
-(void)setrefresh{
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataArray = [NSMutableArray array];
        [weakSelf getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index ++ ;
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 加载视图  跳转方法

-(void)creatView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ZWHOrderTableViewCell class] forCellReuseIdentifier:norCell];
    [self.tableView registerClass:[ZWHSpeOrderTableViewCell class] forCellReuseIdentifier:speCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EMPCELL];
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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray.count ==0) {
        return 1;
    }
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
        return 1;
    }
    if (_dataArray.count > 0) {
        ZWHOrderModel *model = _dataArray[section];
        return model.goodsList.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return SCREENHIGHT - 64 - 40;
    }
    ZWHOrderModel *model = _dataArray[indexPath.section];
    if ([model.status integerValue] ==3) {
        //ZWHGoodsModel *ordermodel = model.goodsList[indexPath.row];
        /*if ([ordermodel.commentFlag integerValue]==1) {
            return HEIGHT_TO(120);
        }*/
        return HEIGHT_TO(160);
    }
    return HEIGHT_TO(120);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMPCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.emptyView];
        return cell;
    }else{
        ZWHOrderModel *order;
        if (_dataArray.count > 0) {
            order = _dataArray[indexPath.section];
        }
        if ([order.status integerValue]==3) {
            ZWHSpeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:speCell forIndexPath:indexPath];
            cell.num.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_dataArray.count > 0) {
                MJWeakSelf
                ZWHOrderModel *model = _dataArray[indexPath.section];
                cell.ordermodel = model.goodsList[indexPath.row];
                cell.clicked = ^(ZWHGoodsModel *model) {
                    [weakSelf evlClicked:model];
                };
            }
            return cell;
        }else{
            ZWHOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:norCell forIndexPath:indexPath];
            cell.num.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_dataArray.count > 0) {
                ZWHOrderModel *model = _dataArray[indexPath.section];
                cell.ordermodel = model.goodsList[indexPath.row];
            }
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
        return CGFLOAT_MIN;
    }
    return HEIGHT_TO(40);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
        return CGFLOAT_MIN;
    }
    ZWHOrderModel *model = _dataArray[section];
    return [model.status integerValue]==1?HEIGHT_TO(0.01):HEIGHT_TO(115);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
        return [UIView new];
    }
    ZWHOrderModel *model = _dataArray[section];
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(40))];
    head.backgroundColor = [UIColor whiteColor];
    
    UIView *linev = [[UIView alloc]init];\
    linev.backgroundColor = LINECOLOR; \
    [head addSubview:linev]; \
    linev.sd_layout  \
    .leftEqualToView(head) \
    .rightEqualToView(head)  \
    .topEqualToView(head)  \
    .heightIs(1);
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [head addSubview:lab];
    lab.text = @"";
    lab.text = [NSString stringWithFormat:@"订单号：%@",model.orderNo];
    lab.sd_layout
    .leftSpaceToView(head, WIDTH_TO(15))
    .centerYEqualToView(head)
    .autoHeightRatio(0);
    
    [lab setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(200)];
    [lab updateLayout];
    
    UILabel *statel = [[UILabel alloc]init];
    [statel textFont:14 textColor:[UIColor redColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    [head addSubview:statel];
    NSArray *array = @[@"待付款",@"待发货",@"待收货",@"已完成"];
    statel.text = @"完成交易";
    statel.text = array[[model.status integerValue]];
    statel.sd_layout
    .rightSpaceToView(head, WIDTH_TO(15))
    .centerYEqualToView(head)
    .autoHeightRatio(0);
    
    [statel setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(200)];
    [statel updateLayout];
    
    return head;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
        return [UIView new];
    }
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(110))];
    foot.backgroundColor = [UIColor whiteColor];
    
    ZWHOrderModel *model = _dataArray[section];
    UILabel *yunf = [[UILabel alloc]init];
    [yunf textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    yunf.text = @"含运费¥18.00";
    yunf.text = [NSString stringWithFormat:@"(含运费¥%@)",model.postMoney];
    [foot addSubview:yunf];
    yunf.sd_layout
    .rightSpaceToView(foot, WIDTH_TO(15))
    .topSpaceToView(foot, HEIGHT_TO(10))
    .autoHeightRatio(0);
    
    [yunf setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(200)];
    [yunf updateLayout];
    
    UILabel *sum = [[UILabel alloc]init];
    [sum textFont:16 textColor:ZWHCOLOR(@"666666") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    sum.text = @"¥1800";
    sum.text = [NSString stringWithFormat:@"¥%@",model.totalMoney];
    [foot addSubview:sum];
    sum.sd_layout
    .rightSpaceToView(yunf, WIDTH_TO(0))
    .centerYEqualToView(yunf)
    .autoHeightRatio(0);
    
    [sum setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(200)];
    [sum updateLayout];
    
    UILabel *num = [[UILabel alloc]init];
    [num textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    num.text = @"共1件商品 合计";
    num.text = [NSString stringWithFormat:@"共%ld件商品 合计",model.goodsList.count];
    [foot addSubview:num];
    num.sd_layout
    .rightSpaceToView(sum, WIDTH_TO(0))
    .centerYEqualToView(yunf)
    .autoHeightRatio(0);
    
    [num setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(200)];
    [num updateLayout];
    
    UILabel *give = [[UILabel alloc]init];
    [give textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    give.text = @"赠送工分：980元";
    give.text = [NSString stringWithFormat:@"赠送工分：%@元",model.totalScore];
    [foot addSubview:give];
    give.sd_layout
    .rightSpaceToView(foot, WIDTH_TO(15))
    .topSpaceToView(yunf, HEIGHT_TO(10))
    .autoHeightRatio(0);
    
    [give setSingleLineAutoResizeWithMaxWidth:WIDTH_TO(200)];
    [give updateLayout];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = GRAYBACKCOLOR;
    [foot addSubview:line2];
    line2.sd_layout
    .leftEqualToView(foot)
    .rightEqualToView(foot)
    .heightIs(1)
    .topSpaceToView(give, HEIGHT_TO(10));
    
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    rightB.layer.borderColor = LINECOLOR.CGColor;
    rightB.layer.borderWidth = 1;
    [rightB setTitleColor:ZWHCOLOR(@"999999") forState:0];
    rightB.titleLabel.font = FontWithSize(14);
    [foot addSubview:rightB];
    rightB.sd_layout
    .rightSpaceToView(foot, WIDTH_TO(15))
    .widthIs(HEIGHT_TO(70))
    .heightIs(HEIGHT_TO(35))
    .topSpaceToView(line2, HEIGHT_TO(10));
    
    UIButton *leftB = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftB setTitleColor:ZWHCOLOR(@"999999") forState:0];
    leftB.layer.borderColor = LINECOLOR.CGColor;
    leftB.layer.borderWidth = 1;
    leftB.titleLabel.font = FontWithSize(14);
    [foot addSubview:leftB];
    leftB.sd_layout
    .rightSpaceToView(rightB, WIDTH_TO(15))
    .widthIs(HEIGHT_TO(70))
    .heightIs(HEIGHT_TO(35))
    .topSpaceToView(line2, HEIGHT_TO(10));
    
    [leftB addTarget:self action:@selector(leftClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightB addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    leftB.tag = section;
    rightB.tag = section;
    leftB.layer.cornerRadius = 5;
    rightB.layer.cornerRadius = 5;
    leftB.layer.masksToBounds = YES;
    rightB.layer.masksToBounds = YES;
    
    switch ([model.status integerValue]) {
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
            if ([model.logisticstype isEqualToString:@"2"]) {
                [leftB setTitle:@"" forState:0];
                leftB.layer.borderWidth = 0;
                leftB.userInteractionEnabled = NO;
            }else{
                [leftB setTitle:@"查看物流" forState:0];
                leftB.userInteractionEnabled = YES;
            }
            [rightB setTitle:@"确认收货" forState:0];
            rightB.layer.borderColor = [UIColor redColor].CGColor;
            rightB.layer.borderWidth = 1;
            [rightB setTitleColor:[UIColor redColor] forState:0];
        }
            break;
        case 3:
        {
            [leftB setTitle:@"" forState:0];
            [rightB setTitle:@"查看物流" forState:0];
            leftB.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = GRAYBACKCOLOR;
    [foot addSubview:line1];
    line1.sd_layout
    .leftEqualToView(foot)
    .rightEqualToView(foot)
    .heightIs(1)
    .topEqualToView(foot);
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = GRAYBACKCOLOR;
    [foot addSubview:line3];
    line3.sd_layout
    .leftEqualToView(foot)
    .rightEqualToView(foot)
    .heightIs(1)
    .bottomEqualToView(foot);
    return [model.status integerValue]==1?[UIView new]:foot;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return;
    }
    ZWHOrderModel *ormodel = _dataArray[indexPath.section];
    ShowProgress
    NotAllowUser;
    [HttpHandler getOrderDetail:@{@"orderId":ormodel.id,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            Dismiss;
            [ZWHOrderModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"goods":@"ZWHGoodsModel"};
            }];
            ZWHOrderModel *model = [ZWHOrderModel mj_objectWithKeyValues:obj[@"data"]];
            ZWHOrderDetailViewController *vc = [[ZWHOrderDetailViewController alloc]init];
            vc.model = model;
            vc.ordermodel = ormodel;
            vc.title = @"订单详情";
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
}

#pragma mark - 左右按钮点击事件
-(void)leftClicked:(UIButton *)sender{
    ZWHOrderModel *model = _dataArray[sender.tag];
    ZWHGoodsModel *goodsmodel = model.goodsList[0];
    switch ([model.status integerValue]) {
        case 0:
            [self cancelOrder:model];
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

-(void)rightClicked:(UIButton *)sender{
    ZWHOrderModel *model = _dataArray[sender.tag];
    ZWHGoodsModel *goodsmodel = model.goodsList[0];
    switch ([model.status integerValue]) {
        case 0:
            [self topay:model];
            break;
        case 2:
            [self sureOrder:model];
            break;
        case 3:
            [self showLogistics:model withgoodsmodel:goodsmodel];
            break;
        default:
            break;
    }
}

//取消订单
-(void)cancelOrder:(ZWHOrderModel *)model{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.id forKey:@"orderId"];
    [dict setValue:[UserManager token] forKey:@"v_weichao"];
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),model.id);
    MJWeakSelf
    [HttpHandler getcancelOrder:dict Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"取消成功");
            [weakSelf.tableView.mj_header beginRefreshing];
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
    [_paywayView removeFromSuperview];
    [_backgroundBtn removeFromSuperview];
    [_pdView removeFromSuperview];
}



//查看物流
-(void)showLogistics:(ZWHOrderModel *)model withgoodsmodel:(ZWHGoodsModel *)goodsmodel{
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),model.id);
    ZWHLogisticsViewController *vc = [[ZWHLogisticsViewController alloc]init];
    vc.orderId = model.id;
    goodsmodel.goodslogNum = model.goodsList.count;
    vc.goodsmodel = goodsmodel;
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
                    if (payway!=1) {
                        ShowSuccessWithStatus(@"支付成功");
                        [weakSelf.tableView.mj_header beginRefreshing];
                    }else{
                        [weakSelf aliPay:obj[@"data"][@"payBody"] urlScheme:@"com.ZWHWXHL.cn.WXHL"];
                    }
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
                [weakSelf.tableView.mj_header beginRefreshing];
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
        [weakSelf dismisChooseView];
        NSLog(@"忘记密码");
        ZWHPayPasViewController *vc = [[ZWHPayPasViewController alloc]init];
        vc.title = @"支付密码";
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
     [window addSubview:_pdView];
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


                             
#pragma mark - 评价
-(void)evlClicked:(ZWHGoodsModel *)model{
    ZWHJudgeViewController *vc = [[ZWHJudgeViewController alloc]init];
    vc.goodmodel = model;
    vc.title = @"评价晒单";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
-(EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
        _emptyView.image = ImageNamed(@"wujilu");
        _emptyView.text = @"您暂无此类记录";
    }
    return _emptyView;
}




@end
