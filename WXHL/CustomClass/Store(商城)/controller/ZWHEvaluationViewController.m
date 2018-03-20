//
//  ZWHEvaluationViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/21.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHEvaluationViewController.h"
#import "ZWHEvaModel.h"

#import "ZWHEvaluDetailTableViewCell.h"


#define EVCELL @"ZWHEvaluDetailTableViewCell"

@interface ZWHEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ZWHEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
    [self creatView];
    [self setrefresh];
    [self getHomeData];
}

#pragma mark - 数据
-(void)getHomeData{
    MJWeakSelf
    
    [HttpHandler getCommentList:@{@"id":_goodid==nil?@"":_goodid,@"pageNo":@(_index),@"pageSize":@20,@"type":_state} Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"][@"list"] count] == 0) {
                weakSelf.index -- ;
            }
            [weakSelf.dataArray addObjectsFromArray:[ZWHEvaModel mj_objectArrayWithKeyValuesArray:obj[@"data"][@"list"]]];
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
        [weakSelf getHomeData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index ++ ;
        [weakSelf getHomeData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HEIGHT_TO(50)) style:UITableViewStylePlain];
    [self.tableView registerClass:[ZWHEvaluDetailTableViewCell class] forCellReuseIdentifier:EVCELL];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHEvaModel *mo = _dataArray[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:mo keyPath:@"model" cellClass:[ZWHEvaluDetailTableViewCell class] contentViewWidth:SCREENWIDTH];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHEvaluDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EVCELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    return cell;
}


@end
