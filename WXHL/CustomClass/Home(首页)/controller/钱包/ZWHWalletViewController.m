//
//  ZWHWalletViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHWalletViewController.h"
#import "ZWHRecharDetailViewController.h"
#import "KJUserInfoOneTableViewCell.h"
#import "ZWHRechargeViewController.h"
#import "ZWHCashViewController.h"
#import "ZWHWalletModel.h"


#define ONECELL @"KJUserInfoOneTableViewCell"

@interface ZWHWalletViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titleArray;
}

@property(nonatomic,strong)UIView *midview;
@property(nonatomic,strong)UILabel *money;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ZWHWalletViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];
    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    titleArray = @[@"充值",@"提现"];
    [super viewDidLoad];
    [self creatView];
    [self setrefresh];
   // [self getData];
}

#pragma mark - 首页数据
-(void)getData{
    MJWeakSelf
    [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
            weakSelf.money.text = model.cashRemain;
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
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)creatView{
    self.view.backgroundColor = ZWHCOLOR(@"f6f6f6");
    [self.backBtn setImage:ImageNamed(@"left") forState:0];
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(showDetail:)];
    self.navigationItem.rightBarButtonItem = more;
    //[self.view addSubview:self.midview];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.tableView registerClass:[KJUserInfoOneTableViewCell class] forCellReuseIdentifier:ONECELL];
    self.tableView.tableHeaderView = self.midview;
    self.tableView.bounces = NO;
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

#pragma mark - uitableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KJUserInfoOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ONECELL forIndexPath:indexPath];
    cell.title = titleArray[indexPath.row];
    cell.image = titleArray[indexPath.row];
    cell.inputTex.enabled = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
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
    }else if (indexPath.row == 1){
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

#pragma mark - 查看明细
-(void)showDetail:(UIButton *)sender{
    ZWHRecharDetailViewController *vc = [[ZWHRecharDetailViewController alloc]init];
    vc.state = @"2";
    vc.title = @"余额明细";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getter
-(UIView *)midview{
    if (!_midview) {
        _midview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(230)-64)];
        _midview.backgroundColor = MAINCOLOR;
        
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:15 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        lab.text = @"我的余额(元)";
        [_midview addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(_midview, WIDTH_TO(15))
        .topSpaceToView(_midview, HEIGHT_TO(25))
        .autoHeightRatio(0)
        .widthIs(200);
        
        _money = [[UILabel alloc]init];
        [_money textFont:46 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _money.text = _model.cashRemain;
        [_midview addSubview:_money];
        _money.sd_layout
        .leftSpaceToView(_midview, WIDTH_TO(15))
        .topSpaceToView(lab, HEIGHT_TO(25))
        .autoHeightRatio(0)
        .rightSpaceToView(_midview, WIDTH_TO(15));
    }
    return _midview;
}
@end
