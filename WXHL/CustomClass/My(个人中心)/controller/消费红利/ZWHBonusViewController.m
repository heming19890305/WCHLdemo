//
//  ZWHBonusViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHBonusViewController.h"

#import "ZWHCashViewController.h"
#import "ZWHRechargeViewController.h"
#import "ZWHRecharDetailViewController.h"
#import "ZWHSetBankViewController.h"
#import "ZWHBalanceViewController.h"
#import "ZWHConsumeViewController.h"
#import "ZWHSetIdCardViewController.h"


#import "ZWHToCertifyTableViewCell.h"
#import "KJUserInfoOneTableViewCell.h"
#import "ZWHMyWorkModel.h"
#import "ZWHWalletModel.h"
#import "ZWHWalletModel.h"


#define ONECELL @"KJUserInfoOneTableViewCell"
#define NORCELL @"uitableviewcell"
#define TOCELL @"ZWHToCertifyTableViewCell.h"

@interface ZWHBonusViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_titleArray;
}

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *midView;

@property(nonatomic,strong)UILabel *price;//价格
@property(nonatomic,strong)UILabel *yue;//余额
@property(nonatomic,strong)UILabel *num;//工分数量
@property(nonatomic,strong)UILabel *value;//工分市值
@property(nonatomic,copy)NSString *tihuoM;

@end

@implementation ZWHBonusViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.contentMode = UIViewContentModeScaleAspectFill;
    //self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"提货券",@"我的银行卡",@"消费记录"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    [self setrefresh];
    [self getData];
}
#pragma mark - 数据 刷新
-(void)setrefresh{
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)getData{
    MJWeakSelf
    [HttpHandler getMyWorkpoints:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHMyWorkModel *model = [ZWHMyWorkModel mj_objectWithKeyValues:obj[@"data"]];
//            weakSelf.price.text = [NSString stringWithFormat:@"¥%@",model.scorePrice];
            weakSelf.yue.text = [NSString stringWithFormat:@"¥%@",model.userBalance];
            weakSelf.num.text = [NSString stringWithFormat:@"¥%@",model.scoreNumber];
            weakSelf.value.text = [NSString stringWithFormat:@"¥%@",model.scoreMarket];
            [weakSelf endrefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf endrefresh];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
        [weakSelf endrefresh];
    }];
    
    [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
            weakSelf.tihuoM = model.coupon;
            [weakSelf.tableView reloadData];
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

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerClass:[ZWHToCertifyTableViewCell class] forCellReuseIdentifier:TOCELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NORCELL];
    [self.tableView registerClass:[KJUserInfoOneTableViewCell class] forCellReuseIdentifier:ONECELL];
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
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([[UserManager idCard] length]==0) {
            return 1;
        }
        return 0;
    }
    if (section == 1) {
        return 1;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return HEIGHT_TO(5);
    }
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ZWHToCertifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
        [cell.contentView addSubview:self.midView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        KJUserInfoOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ONECELL forIndexPath:indexPath];
        cell.image = _titleArray[indexPath.row];
        cell.title = _titleArray[indexPath.row];
        [cell.callB setImage:ImageNamed(@"right_t") forState:0];
        cell.inputTex.enabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.inputTex.textAlignment = NSTextAlignmentRight;
        if (indexPath.row == 0) {
            cell.inputTex.text = [NSString stringWithFormat:@"%@元",self.tihuoM];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HEIGHT_TO(40);
    }
    if (indexPath.section == 1) {
        return HEIGHT_TO(80);
    }
    return HEIGHT_TO(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([[UserManager idCard] length] == 0) {
            if ([[UserManager idStatus] isEqualToString:@"0"]) {
                ShowInfoWithStatus(@"正在审核中");
                return;
            }
            ZWHSetIdCardViewController *vc = [[ZWHSetIdCardViewController alloc]init];
            vc.title = @"实名认证";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if ([[UserManager idStatus] isEqualToString:@"0"]) {
                ShowInfoWithStatus(@"正在审核");
            }
        }
    }
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
                    if (ReturnValue == 200) {
                        NSLog(@"%@",obj);
                        ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
                        ZWHBalanceViewController *vc = [[ZWHBalanceViewController alloc]init];
                        vc.state = @"2";
                        vc.model = model;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        ShowInfoWithStatus(ErrorMessage);
                    }
                } failed:^(id obj) {
                    ShowInfoWithStatus(ErrorNet);
                }];
            }
                break;
            case 1:
            {
                ZWHSetBankViewController *vc = [[ZWHSetBankViewController alloc]init];
                vc.title = @"银行卡";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                ZWHConsumeViewController *vc = [[ZWHConsumeViewController alloc]init];
                vc.title = @"消费记录";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}


#pragma mark - 买入
-(void)buyClick{
    NSLog(@"买");
    ZWHStoreViewController *vc = [[ZWHStoreViewController alloc]init];
    vc.title = @"商城";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma -工分卖出
-(void)sellClick{
    NSLog(@"工分卖出");
}

#pragma mark - 查看明细
-(void)showDetail{
    NSLog(@"看");
    ZWHRecharDetailViewController *vc = [[ZWHRecharDetailViewController alloc]init];
    vc.state = @"3";
    vc.title = @"工分明细";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 充值 提现

-(void)midClicked:(UIButton *)sender{
    if (sender.tag == 10) {
        [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                NSLog(@"%@",obj);
                ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
                ZWHRechargeViewController *vc = [[ZWHRechargeViewController alloc]init];
                vc.model = model;
                vc.title = @"充值";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }else{
        if ([[UserManager token]length] == 0) {
            [self getLogin];
            return;
        }
        [HttpHandler getBindBankCard:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                NSLog(@"%@",obj);
                if (obj[@"data"]) {
                    [UserManager sharedData].bankname = obj[@"data"][@"bank"];
                    [UserManager sharedData].cardNo = obj[@"data"][@"cardNo"];
                    ZWHCashViewController *vc = [[ZWHCashViewController alloc]init];
                    vc.title = @"提现";
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    ShowInfoWithStatus(@"还未绑定银行卡");
                }
            }else{
                ShowErrorWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowErrorWithStatus(ErrorNet);
        }];
    }
}



#pragma mark - getter

-(UIView *)midView{
    if (!_midView) {
        _midView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(80))];
        UIImageView *reimg = [[UIImageView alloc]initWithImage:ImageNamed(@"充值")];
        [_midView addSubview:reimg];
        reimg.sd_layout
        .leftSpaceToView(_midView, WIDTH_TO(15))
        .centerYEqualToView(_midView)
        .heightIs(HEIGHT_TO(40))
        .widthEqualToHeight();
        
        UIButton *reB = [UIButton buttonWithType:UIButtonTypeCustom];
        reB.tag = 10;
        [reB addTarget:self action:@selector(midClicked:) forControlEvents:UIControlEventTouchUpInside];
        reB.backgroundColor = [UIColor clearColor];
        [_midView addSubview:reB];
        reB.sd_layout
        .leftSpaceToView(_midView, 0)
        .topSpaceToView(_midView, 0)
        .widthIs(SCREENWIDTH/2)
        .bottomSpaceToView(_midView, 0);
        
        UIButton *cashB = [UIButton buttonWithType:UIButtonTypeCustom];
        cashB.tag = 11;
        [cashB addTarget:self action:@selector(midClicked:) forControlEvents:UIControlEventTouchUpInside];
        cashB.backgroundColor = [UIColor clearColor];
        [_midView addSubview:cashB];
        cashB.sd_layout
        .rightSpaceToView(_midView, 0)
        .topSpaceToView(_midView, 0)
        .widthIs(SCREENWIDTH/2)
        .bottomSpaceToView(_midView, 0);
        
        
        UILabel *relab = [[UILabel alloc]init];
        [relab textFont:16 textColor:ZWHCOLOR(@"666666") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        relab.text = @"充值";
        [_midView addSubview:relab];
        relab.sd_layout
        .leftSpaceToView(reimg, WIDTH_TO(6))
        .topSpaceToView(_midView, HEIGHT_TO(20))
        .autoHeightRatio(0)
        .widthIs(150);
        
        UILabel *reintro = [[UILabel alloc]init];
        [reintro textFont:12 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        reintro.text = @"支付宝/银行卡绑定充值";
        [_midView addSubview:reintro];
        reintro.sd_layout
        .leftSpaceToView(reimg, WIDTH_TO(6))
        .bottomSpaceToView(_midView, HEIGHT_TO(20))
        .autoHeightRatio(0)
        .widthIs(150);
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LINECOLOR;
        [_midView addSubview:line];
        line.sd_layout
        .leftSpaceToView(_midView, SCREENWIDTH/2)
        .topSpaceToView(_midView, 0)
        .bottomSpaceToView(_midView, 0)
        .widthIs(1);
        
        UIImageView *cashimg = [[UIImageView alloc]initWithImage:ImageNamed(@"提现")];
        [_midView addSubview:cashimg];
        cashimg.sd_layout
        .leftSpaceToView(_midView, WIDTH_TO(15) + SCREENWIDTH/2)
        .centerYEqualToView(_midView)
        .heightIs(HEIGHT_TO(40))
        .widthEqualToHeight();
        
        UILabel *cashlab = [[UILabel alloc]init];
        [cashlab textFont:16 textColor:ZWHCOLOR(@"666666") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        cashlab.text = @"提现";
        [_midView addSubview:cashlab];
        cashlab.sd_layout
        .leftSpaceToView(cashimg, WIDTH_TO(6))
        .topSpaceToView(_midView, HEIGHT_TO(20))
        .autoHeightRatio(0)
        .widthIs(150);
        
        UILabel *cashintro = [[UILabel alloc]init];
        [cashintro textFont:12 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        cashintro.text = @"账户余额提现";
        [_midView addSubview:cashintro];
        cashintro.sd_layout
        .leftSpaceToView(cashimg, WIDTH_TO(6))
        .bottomSpaceToView(_midView, HEIGHT_TO(20))
        .autoHeightRatio(0)
        .widthIs(150);
    }
    return _midView;
}


-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(346))];
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"xf_top_bj")];
        [_headerView addSubview:img];
        img.sd_layout
        .leftSpaceToView(_headerView, 0)
        .rightSpaceToView(_headerView, 0)
        .topSpaceToView(_headerView, 0)
        .heightIs(HEIGHT_TO(346));
        
        UIView *nav = [[UIView alloc]init];
        nav.userInteractionEnabled = YES;
        nav.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:nav];
        nav.sd_layout
        .widthIs(SCREENWIDTH)
        .centerXEqualToView(_headerView)
        .topSpaceToView(_headerView, 20)
        .heightIs(44);
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setImage:ImageNamed(@"left") forState:0];
        [back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [nav addSubview:back];
        back.sd_layout
        .leftSpaceToView(nav, WIDTH_TO(15))
        .centerYEqualToView(nav)
        .heightIs(HEIGHT_TO(17.5))
        .widthEqualToHeight();
        
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:17 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        lab.text = self.title;
        [nav addSubview:lab];
        lab.sd_layout
        .centerYEqualToView(nav)
        .autoHeightRatio(0)
        .centerXEqualToView(nav);
        [lab setSingleLineAutoResizeWithMaxWidth:100];
        [lab updateLayout];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"明细" forState:0];
        [btn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.backgroundColor = [UIColor clearColor];
        [nav addSubview:btn];
        btn.sd_layout
        .rightSpaceToView(nav, WIDTH_TO(15))
        .centerYEqualToView(nav)
        .heightIs(25)
        .widthIs(WIDTH_TO(80));
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        
        UILabel *pricelab = [[UILabel alloc]init];
        [pricelab textFont:14 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        pricelab.text = @"当前价格(元/个)";
        [_headerView addSubview:pricelab];
        pricelab.sd_layout
        .topSpaceToView(nav, HEIGHT_TO(36))
        .leftSpaceToView(_headerView, WIDTH_TO(56))
        .autoHeightRatio(0)
        .widthIs(WIDTH_TO(150));
        
        _price = [[UILabel alloc]init];
        [_price textFont:18 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _price.text = @"¥1";
        [_headerView addSubview:_price];
        _price.sd_layout
        .topSpaceToView(pricelab, HEIGHT_TO(6))
        .leftSpaceToView(_headerView, WIDTH_TO(56))
        .autoHeightRatio(0)
        .widthIs(WIDTH_TO(150));
        
        UILabel *yuelab = [[UILabel alloc]init];
        [yuelab textFont:14 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        yuelab.text = @"账户余额(元)";
        [_headerView addSubview:yuelab];
        yuelab.sd_layout
        .topSpaceToView(nav, HEIGHT_TO(36))
        .leftSpaceToView(_headerView, WIDTH_TO(40) + SCREENWIDTH/2)
        .autoHeightRatio(0)
        .widthIs(WIDTH_TO(150));
        
        _yue = [[UILabel alloc]init];
        [_yue textFont:18 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _yue.text = @"19292314.41";
        [_headerView addSubview:_yue];
        _yue.sd_layout
        .topSpaceToView(yuelab, HEIGHT_TO(6))
        .leftSpaceToView(_headerView, WIDTH_TO(40) + SCREENWIDTH/2)
        .autoHeightRatio(0)
        .widthIs(WIDTH_TO(150));
        
        UILabel *numlab = [[UILabel alloc]init];
        [numlab textFont:14 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        numlab.text = @"工分数量(个)";
        [_headerView addSubview:numlab];
        numlab.sd_layout
        .topSpaceToView(_headerView, HEIGHT_TO(30) + HEIGHT_TO(346)/2)
        .leftSpaceToView(_headerView, WIDTH_TO(56))
        .autoHeightRatio(0)
        .widthIs(WIDTH_TO(150));
        
        _num = [[UILabel alloc]init];
        [_num textFont:18 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _num.text = @"22";
        [_headerView addSubview:_num];
        _num.sd_layout
        .topSpaceToView(numlab, HEIGHT_TO(6))
        .leftSpaceToView(_headerView, WIDTH_TO(56))
        .autoHeightRatio(0)
        .widthIs(WIDTH_TO(150));
        
        UILabel *valuelab = [[UILabel alloc]init];
        [valuelab textFont:14 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        valuelab.text = @"工分市值(元)";
        [_headerView addSubview:valuelab];
        valuelab.sd_layout
        .topSpaceToView(_headerView,HEIGHT_TO(30) + HEIGHT_TO(346)/2)
        .leftSpaceToView(_headerView, WIDTH_TO(40) + SCREENWIDTH/2)
        .autoHeightRatio(0)
        .widthIs(WIDTH_TO(150));
        
        _value = [[UILabel alloc]init];
        [_value textFont:18 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _value.text = @"¥0.00";
        [_headerView addSubview:_value];
        _value.sd_layout
        .topSpaceToView(valuelab,HEIGHT_TO(6))
        .leftSpaceToView(_headerView, WIDTH_TO(40) + SCREENWIDTH/2)
        .autoHeightRatio(0)
        .widthIs(WIDTH_TO(150));
        
        
        UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
        buy.backgroundColor = [UIColor clearColor];
        [buy addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
        [buy setTitleColor:[UIColor whiteColor] forState:0];
        [buy setTitle:@"买入" forState:0];
        buy.layer.cornerRadius = 5;
        buy.layer.masksToBounds = YES;
        buy.layer.borderColor = [[UIColor whiteColor] CGColor];
        buy.layer.borderWidth = 1;
        [_headerView addSubview:buy];
        buy.sd_layout
        .topSpaceToView(_value, HEIGHT_TO(31)).rightSpaceToView(_headerView, 45.0)
        .widthIs(WIDTH_TO(120))
        .heightIs(HEIGHT_TO(38));
//        .centerXEqualToView(_headerView)
    //工分卖出
        UIButton *sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sellBtn.backgroundColor = [UIColor clearColor];
        [sellBtn addTarget:self action:@selector(sellClick) forControlEvents:UIControlEventTouchUpInside];
        [sellBtn setTitleColor:[UIColor whiteColor] forState:0];
        [sellBtn setTitle:@"买入" forState:0];
        sellBtn.layer.cornerRadius = 5;
        sellBtn.layer.masksToBounds = YES;
        sellBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        sellBtn.layer.borderWidth = 1;
        [_headerView addSubview:sellBtn];
//        sellBtn.sd_layout.topEqualToView(_num, HEIGHT_TO(31)).lefts
        sellBtn.sd_layout
        .topSpaceToView(_value, HEIGHT_TO(31)).leftSpaceToView(_headerView, 45.0)
        .widthIs(WIDTH_TO(120))
        .heightIs(HEIGHT_TO(38));
    }
    return _headerView;
}



@end
