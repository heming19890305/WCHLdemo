//
//  ZWHDrinkViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHDrinkViewController.h"
#import "ZWHDrinkHeaderView.h"
#import "ZWHDrinkTableViewCell.h"
#import "ZWHDrinkDetailViewController.h"
#import "ZWHDrinkModel.h"
#import "ZWHC2fGoodViewController.h"

#define DRINKCELL @"ZWHDrinkTableViewCell"

@interface ZWHDrinkViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)ZWHDrinkHeaderView *headerView;

@property(nonatomic,strong)UIView *footerView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ZWHDrinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    switch ([_state integerValue]) {
        case 1:
            self.title = @"封坛酒";
            break;
        case 2:
            self.title = @"智能微超";
            break;
        case 3:
            self.title = @"个性定制";
            break;
        default:
            break;
    }
    [self createRightNavButton];
    [self creatView];
    [self setrefresh];
    [self getData];
}

#pragma mark - 数据 刷新
-(void)setrefresh{
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataArray = [NSMutableArray array];
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(void)getData{
    MJWeakSelf
    [HttpHandler getC2FbuyRecord:@{@"v_weichao":[UserManager token],@"type":_state} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            if ([obj[@"data"] count] > 0) {
                [_dataArray addObjectsFromArray:[ZWHDrinkModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
                [weakSelf.tableView reloadData];
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

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -HEIGHT_TO(70)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ZWHDrinkTableViewCell class] forCellReuseIdentifier:DRINKCELL];
    self.tableView.tableHeaderView = self.headerView;
    //self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.footerView];
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
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(15);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHDrinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DRINKCELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        cell.model = _dataArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHDrinkModel *model = _dataArray[indexPath.row];
    if ([_state integerValue]>1) {
        return;
    }
    MJWeakSelf
    [HttpHandler getWineHid:@{@"v_weichao":[UserManager token],@"orderNo":model.orderNo} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHDrinkModel *model = [ZWHDrinkModel mj_objectWithKeyValues:obj[@"data"]];
            ZWHDrinkDetailViewController *vc = [[ZWHDrinkDetailViewController alloc]init];
            vc.model = model;
            vc.title = @"详情";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - 立刻购买
-(void)buyClicked:(UIButton *)sender{
    NSLog(@"购买");
    MJWeakSelf
    [HttpHandler getC2fInfo:@{@"type":@"1"} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHGoodsModel *mo = [ZWHGoodsModel mj_objectWithKeyValues:obj[@"data"]];
            NSLog(@"%@",mo);
            ZWHC2fGoodViewController *vc = [[ZWHC2fGoodViewController alloc]init];
            vc.state = weakSelf.state;
            vc.model = mo;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - getter
-(ZWHDrinkHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZWHDrinkHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(100))];
    }
    return _headerView;
}


-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHIGHT-64-HEIGHT_TO(70), SCREENWIDTH, HEIGHT_TO(70))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(buyClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = MAINCOLOR.CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitle:@"立即购买" forState:0];
        [btn setTitleColor:MAINCOLOR forState:0];
        [_footerView addSubview:btn];
        btn.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(20))
        .rightSpaceToView(_footerView, WIDTH_TO(20))
        .topSpaceToView(_footerView, HEIGHT_TO(0))
        .heightIs(HEIGHT_TO(50));
    }
    return _footerView;
}

@end
