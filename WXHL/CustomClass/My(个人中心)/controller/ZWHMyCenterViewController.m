//
//  ZWHMyCenterViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/6.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHMyCenterViewController.h"
#import "ZWHJoinBuiViewController.h"
#import "ZWHBonusViewController.h"
#import "ZWHCollectViewController.h"
#import "ZWHSetIdCardViewController.h"
#import "ZWHMyWorkModel.h"
#import "ZWHBuinessViewController.h"
#import "ZWHMyOrderViewController.h"

#import "ZWHC2FViewController.h"
#import "ZWHMyheaderView.h"
#import "KJUserInfoOneTableViewCell.h"
#import "ZWHSettingViewController.h"
#import "ZWHAddressViewController.h"
#import "ZWHPayPasViewController.h"
#import "ZWHMessageViewController.h"

#define ONECELL @"KJUserInfoOneTableViewCell"


@interface ZWHMyCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *titleArray;
    NSString * phoneStr;
}


@property(nonatomic,strong)ZWHMyheaderView *headerView;

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation ZWHMyCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_headerView.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],[UserManager face]]] placeholderImage:ImageNamed(@"logo")];
    MJWeakSelf
    [HttpHandler getOrderStatusNum:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"+++++++++++%@",obj);
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:obj[@"data"][@"payNum"]];
            [arr addObject:obj[@"data"][@"deliveryNum"]];
            [arr addObject:obj[@"data"][@"commentNum"]];
            if (weakSelf.headerView) {
                _headerView.upview.redArray = arr;
            }
            [weakSelf endrefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf endrefresh];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet)
        [weakSelf endrefresh];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray = @[@"收藏",@"地址",@"密码"];
    NOTIFY_ADD(getData, @"mycenter")
    [self creatView];
    [self setrefresh];
    [self getData];
}

-(void)dealloc{
    NOTIFY_REMOVE(@"mycenter");
}

#pragma mark - 加载视图  跳转方法

-(void)creatView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.headerView;
    
    MJWeakSelf
    /*订单*/
    self.headerView.getindex = ^(NSInteger idx) {
        NSLog(@"%ld",idx);
        ZWHMyOrderViewController *vc = [[ZWHMyOrderViewController alloc]init];
        vc.toidx = idx-10;
        vc.title = @"我的订单";
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    /*专区 商脉圈*/
    self.headerView.getbottomindex = ^(NSInteger idx) {
        NSLog(@"%ld",idx);
        switch (idx) {
            case 10:
                {
                    ZWHC2FViewController *vc = [[ZWHC2FViewController alloc]init];
                    vc.title = @"C2F专区";
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                break;
            case 11:
            {
                if ([UserManager token].length == 0) {
                    [weakSelf getLogin];
                    return;
                }
                if ([[UserManager areaNo] length] == 0) {
                    ZWHJoinBuiViewController *vc = [[ZWHJoinBuiViewController alloc]init];
                    vc.title = @"加入商脉圈";
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    ZWHBuinessViewController *vc = [[ZWHBuinessViewController alloc]init];
                    vc.title = @"商脉圈";
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 12:
            {
                ZWHBonusViewController *vc = [[ZWHBonusViewController alloc]init];
                vc.title = @"我的工分";
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 13:
            {
                ZWHMessageViewController *vc = [[ZWHMessageViewController alloc]init];
                vc.title = @"消息中心";
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    };
    
    self.headerView.downview.text = @"asd";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[KJUserInfoOneTableViewCell class] forCellReuseIdentifier:ONECELL];
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
    [HttpHandler getCurrentUser:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"*********%@",obj);
            phoneStr = obj[@"data"][@"phone"];
            [UserManager sharedData].mymodel = [ZWHMyModel mj_objectWithKeyValues:obj[@"data"]];
            [UserManager sharedData].userDict = obj[@"data"];
            weakSelf.headerView.model = [UserManager sharedData].mymodel;
            [weakSelf endrefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf endrefresh];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
        [weakSelf endrefresh];
    }];
    
    [HttpHandler getMyWorkpoints:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"++========%@",obj);
            ZWHMyWorkModel *model = [ZWHMyWorkModel mj_objectWithKeyValues:obj[@"data"]];
            weakSelf.headerView.downview.workmodel = model;
            NSLog(@"******&&&&######= %@", weakSelf.headerView.downview.workmodel.scoreNumber);

            [weakSelf endrefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf endrefresh];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
        [weakSelf endrefresh];
    }];
    
    [HttpHandler getOrderStatusNum:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:obj[@"data"][@"payNum"]];
            [arr addObject:obj[@"data"][@"deliveryNum"]];
            [arr addObject:obj[@"data"][@"commentNum"]];
            _headerView.upview.redArray = arr;
            [weakSelf endrefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf endrefresh];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet)
         [weakSelf endrefresh];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(5);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(55);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KJUserInfoOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ONECELL forIndexPath:indexPath];
    cell.title = titleArray[indexPath.row];
    cell.image = titleArray[indexPath.row];
    if (indexPath.row==0) {
        cell.image = @"收藏_1";
    }
    cell.inputTex.enabled = NO;
    [cell.callB setImage:ImageNamed(@"right_t") forState:0];
    cell.callB.userInteractionEnabled = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            ZWHCollectViewController *vc = [[ZWHCollectViewController alloc]init];
            vc.title = @"我的收藏(11)";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ZWHAddressViewController *vc = [[ZWHAddressViewController alloc]init];
            vc.title = @"地址管理";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ZWHPayPasViewController *vc = [[ZWHPayPasViewController alloc]init];
            vc.title = @"支付密码";
            vc.phoneStr = phoneStr;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 设置 和 右上
-(void)settingClicked:(UIButton *)sender{
    NSLog(@"设置");
    ZWHSettingViewController *vc = [[ZWHSettingViewController alloc]init];
    vc.title = @"设置";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 实名认证
-(void)setCertifyClicked{
    if ([UserManager idCard].length>0) {
        return;
    }
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

#pragma mark - getter
-(ZWHMyheaderView *)headerView{
    if (!_headerView) {
        CGFloat wid = (SCREENWIDTH)/4;
        CGFloat hig = wid*0.8;
        _headerView = [[ZWHMyheaderView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(160) + HEIGHT_TO(10)*3+hig*3 + HEIGHT_TO(5))];
        [_headerView.settingBtn addTarget:self action:@selector(settingClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.rigBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.certify addTarget:self action:@selector(setCertifyClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

@end
