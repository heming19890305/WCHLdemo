//
//  ZWHAllViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHAllViewController.h"
#import "ZWHBuinessNorTableViewCell.h"
#import "ZWHBuinessModel.h"

#define NORCELL @"ZWHBuinessNorTableViewCell"

@interface ZWHAllViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ZWHAllViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    [self setrefresh];
    [self getData];
}

#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    [HttpHandler getAllVencircle:@{@"pageNo":@(_index),@"pageSize":@20,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"][@"list"] count] == 0) {
                weakSelf.index -- ;
            }
            [weakSelf.dataArray addObjectsFromArray:[ZWHBuinessModel mj_objectArrayWithKeyValuesArray:obj[@"data"][@"list"]]];
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

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 106) style:UITableViewStylePlain];

    [self.tableView registerClass:[ZWHBuinessNorTableViewCell class] forCellReuseIdentifier:NORCELL];
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
    return _dataArray.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(50);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHBuinessNorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labnumber = 4;
    if (indexPath.row == 0) {
        cell.textArray = [NSMutableArray arrayWithArray:@[@"商圈编号",@"人数",@"消费笔",@"等级"]];
        cell.topline.hidden = NO;
    }else{
        ZWHBuinessModel *mo = _dataArray[indexPath.row - 1];
        NSArray *arr = @[mo.code,mo.peopleNum,mo.consumptionNum,mo.rank];
        cell.textArray = [NSMutableArray arrayWithArray:arr];
    }
    return cell;
}

@end
