//
//  ZWHSureOrderViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSureOrderViewController.h"
#import "ZWHAddressModel.h"
#import "ZWHAddressViewController.h"
#import "PasswordView.h"
#import "ZWHPayPasViewController.h"

#import "ZWHOrderAdressTableViewCell.h"
#import "ZWHExpressTableViewCell.h"
#import "ZWHChoseExView.h"
#import "ZWHOrderTableViewCell.h"
#import "KJUserInfoOneTableViewCell.h"
#import "ZWHChoseAdreTableViewCell.h"
#import "ZWHOrderAddressViewController.h"
#import "ZWHPaySuccessViewController.h"
#import "ZWHOrderDetailViewController.h"
#import "ZWHOrderModel.h"


#define CHCELL @"ZWHChoseAdreTableViewCell"
#define ADCELL @"ZWHOrderAdressTableViewCell"
#define EXCELL @"ZWHExpressTableViewCell"
#define ORCELL @"ZWHOrderTableViewCell"
#define KJCELL @"KJUserInfoOneTableViewCell.h"



@interface ZWHSureOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString * orderID;
}
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *postV;

@property(nonatomic,strong)ZWHChoseExView *rigview;

@property(nonatomic,strong)UIButton *backgroundBtn;

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)ZWHAddressModel *addressmodel;

@property(nonatomic,assign)NSInteger idx;

@property(nonatomic,assign)NSInteger way;

@property(nonatomic,strong)ZWHExpressTableViewCell *expcell;

@property(nonatomic,strong)PasswordView *pdView;

@property(nonatomic,strong)UIButton *chbackgroundBtn;
//应付金额
@property(nonatomic,strong)UILabel *paymoneyL;

@property(nonatomic,copy)NSString *sumMoney;

@property(nonatomic,assign)BOOL isnoneAddress;

@end

@implementation ZWHSureOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"支付宝",@"余额支付",@"提货券"];
    _idx = 0;
    _way = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    [self creatBottom];
    [self getdefaultAddress];
    NOTIFY_ADD(successClicked,@"paySuccessAliPay");
    NOTIFY_ADD(payfaild, @"cancelOrderWayChat");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelQy) name:@"qyCancel" object:nil];
}

-(void)payfaild{
    NOTIFY_POST(@"shopcar");
    //ShowSuccessWithStatus(@"支付取消");
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)cancelQy{
    [HttpHandler getOrderDetail:@{@"orderId":orderID,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            Dismiss;
            [ZWHOrderModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"goods":@"ZWHGoodsModel"};
            }];
            
            ZWHOrderModel *model = [ZWHOrderModel mj_objectWithKeyValues:obj[@"data"]];
            ZWHOrderDetailViewController *vc = [[ZWHOrderDetailViewController alloc]init];
            vc.model = model;
            vc.ordermodel = model;
            vc.title = @"订单详情";
            vc.isAlipayfail = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}
-(void)successClicked{
    [UserManager sharedData].payway = ZWHINTTOSTR(self.idx+1);
    [UserManager sharedData].sumoney = _sumMoney;
    ZWHPaySuccessViewController *vc = [[ZWHPaySuccessViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    NOTIFY_POST(@"shopcarsuccess");
}

-(void)paysuccess{
    NOTIFY_POST(@"shopcar");
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)dealloc{
    NOTIFY_REMOVE(@"paySuccessAliPay");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//获取默认地址
-(void)getdefaultAddress{
    MJWeakSelf
    [HttpHandler getDefaultAddress:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            if ([obj[@"data"][@"id"] length] > 0) {
                weakSelf.addressmodel = [ZWHAddressModel mj_objectWithKeyValues:obj[@"data"]];
            }
            [weakSelf.tableView reloadData];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
    [HttpHandler getConsignees:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            if (obj[@"data"]) {
                if ([obj[@"data"] count]==0) {
                    weakSelf.isnoneAddress = YES;
                }else{
                    weakSelf.isnoneAddress = NO;
                }
            }else{
                weakSelf.isnoneAddress = YES;
            }
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - HEIGHT_TO(50)) style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.headerView;
    //self.tableView.tableFooterView = self.footerView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[ZWHChoseAdreTableViewCell class] forCellReuseIdentifier:CHCELL];
    
    [self.tableView registerClass:[ZWHOrderAdressTableViewCell class] forCellReuseIdentifier:ADCELL];
    
    [self.tableView registerClass:[ZWHExpressTableViewCell class] forCellReuseIdentifier:EXCELL];
    
    [self.tableView registerClass:[ZWHOrderTableViewCell class] forCellReuseIdentifier:ORCELL];
    
    [self.tableView registerClass:[KJUserInfoOneTableViewCell class] forCellReuseIdentifier:KJCELL];
    
    
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
}

-(void)creatBottom{
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
    
    UIButton *pay = [UIButton buttonWithType:UIButtonTypeCustom];
    [pay setTitle:@"去付款" forState:0];
    pay.backgroundColor = ZWHCOLOR(@"ff5555");
    [pay.titleLabel textFont:16 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [pay addTarget:self action:@selector(payClicked) forControlEvents:UIControlEventTouchUpInside];
    pay.tag = 140;
    [view addSubview:pay];
    pay.sd_layout
    .widthIs(WIDTH_TO(100))
    .rightSpaceToView(view, 0)
    .heightIs(HEIGHT_PRO(50))
    .bottomSpaceToView(view, 0);
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:18 textColor:[UIColor redColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    CGFloat sum = 0;
    for (ZWHGoodsModel *model in _dataArray) {
        sum = sum + [model.price floatValue]*[model.num integerValue];
    }
    lab.text = @"应付金额：1960元";
    _paymoneyL = lab;
    lab.text = [NSString stringWithFormat:@"应付金额%.2f元",sum];
    _sumMoney = [NSString stringWithFormat:@"%.2f",sum];
    [view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(view, 0)
    .rightSpaceToView(pay, 0)
    .bottomSpaceToView(view, 0)
    .heightIs(HEIGHT_PRO(50));
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if(section ==  1){
        return 1;
    }
    if (section == 2) {
        return _dataArray.count;
    }
    if (section == 3) {
        return _titleArray.count;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HEIGHT_TO(70);
    }else if (indexPath.section == 1){
        return HEIGHT_TO(40);
    }else if (indexPath.section == 2){
        return HEIGHT_TO(100);
    }
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_addressmodel) {
            ZWHOrderAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADCELL forIndexPath:indexPath];
            if (_addressmodel) {
                cell.addressmodel = _addressmodel;
            }
            [cell showright:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ZWHChoseAdreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHCELL forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.addbtn addTarget:self action:@selector(chooseaddress) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }else if(indexPath.section == 1){
        ZWHExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EXCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btn addTarget:self action:@selector(showEX) forControlEvents:UIControlEventTouchUpInside];
        _expcell = cell;
        return cell;
    }else if(indexPath.section == 2){
        ZWHOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ORCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.oldprice.hidden = NO;
        cell.num.hidden = NO;
        cell.model = _dataArray[indexPath.row];
        return cell;
    }else{
        KJUserInfoOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KJCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.image = _titleArray[indexPath.row];
        cell.title = _titleArray[indexPath.row];
        cell.callB.userInteractionEnabled = NO;
        cell.callB.selected = NO;
        [cell.callB setImage:ImageNamed(@"a") forState:0];
        [cell.callB setImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
        cell.callB.tag = indexPath.row;
        cell.inputTex.enabled = NO;
        [cell.callB addTarget:self action:@selector(chosePay:) forControlEvents:UIControlEventTouchUpInside];
        if (_idx == cell.callB.tag) {
            cell.callB.selected = YES;
        }
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self chooseaddress];
    }
    if (indexPath.section == 3) {
        _idx = indexPath.row;
        [self.tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return HEIGHT_TO(10);
    }
    return CGFLOAT_MIN;
}

#pragma mark - 结算
-(void)payClicked{
    if (!_addressmodel) {
        ShowInfoWithStatus(@"请选择收货地址");
        return;
    }
    if (_way == -1) {
        ShowInfoWithStatus(@"请选择收货方式");
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (ZWHGoodsModel *model in self.dataArray) {
        [arr addObject:model.id];
    }
    MJWeakSelf
    if (self.idx+1 == 1) {
        ShowProgress
        NotAllowUser
        NSString *waystr = [NSString stringWithFormat:@"%ld",weakSelf.way];
        NSString *paywaystr = [NSString stringWithFormat:@"%ld",weakSelf.idx+1];
        [HttpHandler getsubmitOrder:@{@"cartIds":[UserManager dealWith:arr with:@","],@"addressId":weakSelf.addressmodel.id,@"way":waystr,@"payWay":paywaystr,@"v_weichao":[UserManager token]} Success:^(id obj) {
            NSLog(@"%@",obj);
            if (ReturnValue == 200) {
                NSLog(@"%@",obj);
                    [weakSelf aliPay:obj[@"data"][@"payBody"] urlScheme:@"com.ZWHWXHL.cn.WXHL" Data:obj[@"data"]];
            }else{
                if ([obj[@"status"] isEqualToString:@"500"]) {
                    ShowErrorWithStatus(obj[@"message"])
                    return;
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ShowInfoWithStatus(ErrorMessage);
                    [weakSelf paysuccess];
                    ShowProgress
                    NotAllowUser;
                    [HttpHandler getOrderDetail:@{@"orderId":obj[@"data"][@"orderId"],@"v_weichao":[UserManager token]} Success:^(id obj) {
                        if (ReturnValue == 200) {
                            NSLog(@"%@",obj);
                            Dismiss;
                            [ZWHOrderModel mj_setupObjectClassInArray:^NSDictionary *{
                                return @{@"goods":@"ZWHGoodsModel"};
                            }];

                            ZWHOrderModel *model = [ZWHOrderModel mj_objectWithKeyValues:obj[@"data"]];
                            ZWHOrderDetailViewController *vc = [[ZWHOrderDetailViewController alloc]init];
                            vc.model = model;
                            vc.ordermodel = model;
                            vc.isAlipayfail = YES;
                            vc.title = @"订单详情";
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }else{
                            ShowInfoWithStatus(ErrorMessage);
                        }
                    } failed:^(id obj) {
                        ShowInfoWithStatus(ErrorNet);
                    }];
                });
                
                
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }else{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _chbackgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chbackgroundBtn.backgroundColor = [UIColor blackColor];
        _chbackgroundBtn.alpha = 0.5;
        [_chbackgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:_chbackgroundBtn];
        _chbackgroundBtn.sd_layout
        .topEqualToView(window)
        .leftEqualToView(window)
        .rightEqualToView(window)
        .bottomEqualToView(window);
        _pdView = [[PasswordView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(210), self.view.bounds.size.width, SCREENHIGHT - HEIGHT_TO(210))];
        _pdView.returnPasswordStringBlock = ^(NSString *password){
            [weakSelf dismisChooseView];
            ShowProgress
            NotAllowUser
            NSString *waystr = [NSString stringWithFormat:@"%ld",weakSelf.way];
            NSString *paywaystr = [NSString stringWithFormat:@"%ld",weakSelf.idx+1];
            [weakSelf.view endEditing:true];
            [HttpHandler getsubmitOrder:@{@"cartIds":[UserManager dealWith:arr with:@","],@"addressId":weakSelf.addressmodel.id,@"way":waystr,@"payWay":paywaystr,@"payPwd":password,@"v_weichao":[UserManager token]} Success:^(id obj) {
                NSLog(@"--支付密码那儿---%@",obj);
                if (ReturnValue == 200) {
                    if (weakSelf.idx+1 == 1) {
                        [weakSelf aliPay:obj[@"data"] urlScheme:@"com.ZWHWXHL.cn.WXHL" Data:obj[@"data"]];
                    }else{
                        ShowSuccessWithStatus(@"支付成功");
                        [weakSelf successClicked];
                    }

                }else{
                    ShowSuccessWithStatus(obj[@"message"]);
                    [HttpHandler getOrderDetail:@{@"orderId":obj[@"data"][@"orderId"],@"v_weichao":[UserManager token]} Success:^(id obj) {
                        if (ReturnValue == 200) {
                            NSLog(@"%@",obj);
                            [ZWHOrderModel mj_setupObjectClassInArray:^NSDictionary *{
                                return @{@"goods":@"ZWHGoodsModel"};
                            }];
                            
                            ZWHOrderModel *model = [ZWHOrderModel mj_objectWithKeyValues:obj[@"data"]];
                            ZWHOrderDetailViewController *vc = [[ZWHOrderDetailViewController alloc]init];
                            vc.model = model;
                            vc.ordermodel = model;
                            vc.title = @"订单详情";
                            vc.isAlipayfail = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                            
                            
                        }else{
                            ShowInfoWithStatus(ErrorMessage);
                        }
                    } failed:^(id obj) {
                        ShowInfoWithStatus(ErrorNet);
                    }];

        
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
            }];
        };
        _pdView.dismissV = ^{
            [weakSelf.chbackgroundBtn removeFromSuperview];
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

#pragma mark - 支付宝支付
- (void)aliPay:(NSString *)url urlScheme:(NSString *)urlScheme Data:(NSDictionary *)data
{
    NSLog(@"%@ -- %@",url,urlScheme);
    orderID = data[@"orderId"];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"QcancelOrder" object:data];
    //[url stringByReplacingOccurrencesOfString:@"——" withString:@""];
    [[AlipaySDK defaultService] payUrlOrder:url fromScheme:urlScheme callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultCode"] isEqualToString:@"6001"]) {
            NSLog(@"------取消支付-------")
            [SVProgressHUD showSuccessWithStatus:@"取消支付"];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"QcancelOrder" object:data];
//            [self.navigationController popViewControllerAnimated:YES];
        }else if ([resultDic[@"resultCode"] isEqualToString:@"4000"]) {
            [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
            NSLog(@"------订单支付失败-------")
            [[NSNotificationCenter defaultCenter]postNotificationName:@"QcancelOrder" object:data];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([resultDic[@"resultCode"] isEqualToString:@"6002"]) {
            [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
            NSLog(@"------网络连接出错-------")

        }if ([resultDic[@"resultCode"] isEqualToString:@"9000"]) {
            NSLog(@"------支付失败-------")

            
        }
    }];
}


#pragma mark - 支付方式
-(void)chosePay:(UIButton *)sender{
    _idx = sender.tag;
    [self.tableView reloadData];
}

#pragma marl - 选择地址
-(void)chooseaddress{
    if (_isnoneAddress) {
        ZWHOrderAddressViewController *vc = [[ZWHOrderAddressViewController alloc]init];
        vc.title = @"添加地址";
        MJWeakSelf
        vc.clicked = ^(ZWHAddressModel *model) {
            weakSelf.addressmodel = model;
            [weakSelf getdefaultAddress];
            weakSelf.isnoneAddress = NO;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZWHAddressViewController *vc = [[ZWHAddressViewController alloc]init];
        vc.title = @"地址管理";
        MJWeakSelf
        vc.clicked = ^(ZWHAddressModel *model) {
            weakSelf.addressmodel = model;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 选择快递


-(void)showEX{
    ZWHOrderAdressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSLog(@"%f",cell.frame.origin.y);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    NSArray *postArray = @[@"快递",@"EMS",@"自提"];
    
    _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundBtn.backgroundColor = [UIColor clearColor];
    [_backgroundBtn addTarget:self action:@selector(dismisEXView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_backgroundBtn];
    _backgroundBtn.sd_layout
    .topEqualToView(window)
    .leftEqualToView(window)
    .rightEqualToView(window)
    .bottomEqualToView(window);
    
    _rigview = [[ZWHChoseExView alloc]init];
    MJWeakSelf
    _rigview.didinput = ^(NSInteger idx) {
        NSLog(@"%ld",idx);
        if (!weakSelf.addressmodel) {
            return;
        }
        NSMutableArray *arr = [NSMutableArray array];
        for (ZWHGoodsModel *model in weakSelf.dataArray) {
            [arr addObject:model.id];
        }
        NSString *code = [weakSelf.addressmodel.zone componentsSeparatedByString:@","][0];
        [HttpHandler getPostage:@{@"cartIds":[UserManager dealWith:arr with:@","],@"cityId":code,@"way":ZWHINTTOSTR(idx),@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                NSLog(@"%@",obj);
                weakSelf.way = idx;
                [weakSelf.expcell.btn setTitle:postArray[idx] forState:0];
                weakSelf.expcell.right.text = [NSString stringWithFormat:@"运费 %@元",obj[@"data"]];
                weakSelf.paymoneyL.text = [NSString stringWithFormat:@"应付金额：%.2f元",[weakSelf.sumMoney floatValue] + [obj[@"data"] floatValue]];
                weakSelf.sumMoney = [NSString stringWithFormat:@"%.2f",[weakSelf.sumMoney floatValue] + [obj[@"data"] floatValue]];
                [weakSelf dismisEXView];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    };
    [window addSubview:_rigview];
    [_rigview showViewWith:cell.frame];
}

-(void)dismisEXView{
    [_backgroundBtn removeFromSuperview];
    [_rigview removeFromSuperview];
}
-(void)dismisChooseView{
    [_chbackgroundBtn removeFromSuperview];
    [_pdView removeFromSuperview];
}

#pragma marl - getter
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(10))];
        _headerView.backgroundColor = GRAYBACKCOLOR;
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"caitiao")];
        [_headerView addSubview:img];
        img.sd_layout
        .bottomEqualToView(_headerView)
        .heightIs(HEIGHT_TO(10))
        .widthIs(SCREENWIDTH)
        .centerXEqualToView(_headerView);
    }
    return _headerView;
}

@end
