//
//  ZWHRecharDetailViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHRecharDetailViewController.h"
#import "ZWHRechrDetailTableViewCell.h"
#import "ZWHDetailRecharViewController.h"
#import "ZWHWorkModel.h"
#import "ZWHBalaeceModel.h"
#import "ZWHRechargeModel.h"

#define RECHCELL @"ZWHRechrDetailTableViewCell"
#define NORCELL @"uitableviewcell"

@interface ZWHRecharDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation ZWHRecharDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _index = 1;
    _dataArray = [NSMutableArray array];
    //[self creatView];
    //[self setrefresh];
    [self getData];
}

#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    if ([_state isEqualToString:@"3"]) {
        [HttpHandler getWorkpointsList:@{@"v_weichao":[UserManager token],@"pageNo":@(_index),@"pageSize":@20} Success:^(id obj) {
            if (ReturnValue == 200) {
                if ([obj[@"data"] count] == 0) {
                    weakSelf.index -- ;
                }
                [weakSelf.dataArray addObjectsFromArray:[ZWHWorkModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
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
    }else if ([_state integerValue] == 2){
        [HttpHandler getBalanceList:@{@"v_weichao":[UserManager token],@"pageNo":@(_index),@"pageSize":@20} Success:^(id obj) {
            if (ReturnValue == 200) {
                if ([obj[@"data"] count] == 0) {
                    weakSelf.index -- ;
                }
                [weakSelf.dataArray addObjectsFromArray:[ZWHBalaeceModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
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
    }else if ([_state integerValue] == 0){
        [HttpHandler getRechargeDetail:@{@"v_weichao":[UserManager token],@"pageNo":@(_index),@"pageSize":@20} Success:^(id obj) {
            if (ReturnValue == 200) {
                if ([obj[@"data"] count] == 0) {
                    weakSelf.index -- ;
                }
                [weakSelf.dataArray addObjectsFromArray:[ZWHRechargeModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
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
    }else if ([_state integerValue] == 1){
        [HttpHandler getCouponList:@{@"v_weichao":[UserManager token],@"pageNo":@(_index),@"pageSize":@20} Success:^(id obj) {
            if (ReturnValue == 200) {
                if ([obj[@"data"] count] == 0) {
                    weakSelf.index -- ;
                }
                [weakSelf.dataArray addObjectsFromArray:[ZWHRechargeModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
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
    }else if ([_state integerValue] == 4){
        [HttpHandler getWithdrawDepositRecordList:@{@"v_weichao":[UserManager token],@"pageNo":@(_index),@"pageSize":@20} Success:^(id obj) {
            if (ReturnValue == 200) {
                if ([obj[@"data"] count] == 0) {
                    weakSelf.index -- ;
                }
                [weakSelf.dataArray addObjectsFromArray:[ZWHRechargeModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
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
    
}

-(NSArray *)removenilforArray:(NSArray *)array{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        NSArray * keys=[dict allKeys];
        NSMutableDictionary *dictD = [NSMutableDictionary dictionary];
        for (NSInteger i=0; i<keys.count; i++) {
            //NSLog(@"%@",[obj[@"data"][@"userInfo"] objectForKey:keys[i]]);
            NSString *str = [dict objectForKey:keys[i]];
            if (str == nil) {
                [dictD setValue:@"" forKey:keys[i]];
            }else{
                [dictD setValue:[dict objectForKey:keys[i]] forKey:keys[i]];
            }
        }
        [arrayM addObject:dictD];
    }
    return [NSArray arrayWithArray:arrayM];
}

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

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.tableView registerClass:[ZWHRechrDetailTableViewCell class] forCellReuseIdentifier:RECHCELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NORCELL];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
        return 1;
    }
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return SCREEN_HEIGHT - 64;
    }
    return HEIGHT_TO(75);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.emptyView];
        return  cell;
    }else{
        ZWHRechrDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RECHCELL forIndexPath:indexPath];
        cell.state = _state;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArray[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return;
    }
    if ([_state integerValue] == 3) {
        ZWHWorkModel *model = _dataArray[indexPath.row];
        /*[HttpHandler getWorkpointsDetail:@{@"id":model.id} Success:^(id obj) {
            if (ReturnValue == 200) {
                NSLog(@"obj");
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];*/
        ZWHDetailRecharViewController *vc = [[ZWHDetailRecharViewController alloc]init];
        vc.state = @"3";
        vc.model = model;
        vc.title = @"工分详情";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_state integerValue] == 2){
        ZWHBalaeceModel *model = _dataArray[indexPath.row];
        if ([model.changeType integerValue] == 3) {
            return;
        }
        ZWHDetailRecharViewController *vc = [[ZWHDetailRecharViewController alloc]init];
        vc.state = @"2";
        vc.model = model;
        vc.title = @"余额详情";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_state integerValue] == 1){
        ZWHRechargeModel *model = _dataArray[indexPath.row];
        ZWHDetailRecharViewController *vc = [[ZWHDetailRecharViewController alloc]init];
        vc.state = @"4";
        vc.model = model;
        vc.title = @"提货券详情";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - getter
-(EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _emptyView.image = ImageNamed(@"wujilu");
        _emptyView.text = @"您暂无此类记录";
    }
    return _emptyView;
}
@end
