//
//  ZWHConsumeDetailViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHConsumeDetailViewController.h"
#import "ZWHConsumeView.h"


#import "ZWHLeRiTableViewCell.h"

#define LRCELL @"ZWHLeRiTableViewCell"

@interface ZWHConsumeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)ZWHConsumeView *headerView;

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *valueArr;
@property(nonatomic, strong)ZWHLeRiTableViewCell * payWayCell;

@end

@implementation ZWHConsumeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"付款方式",@"商品说明",@"收货地址",@"物流信息",@"创建时间",@"订单号"];
    MJWeakSelf;
    [HttpHandler getConsumptionDetail:@{@"id":_model.id,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            weakSelf.payWayCell.yue.text = obj[@"data"][@"payWayName"];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
    _valueArr = @[@"",[UserManager dealWith:_model.goodsName with:@","],_model.address,_model.logisticsName==nil?@"":_model.logisticsName,_model.createDate,_model.orderNo];
    [self creatView];
    _headerView.money.text = [NSString stringWithFormat:@"-%@",_model.payMoney];
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[ZWHLeRiTableViewCell class] forCellReuseIdentifier:LRCELL];
    self.tableView.tableHeaderView = self.headerView;
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

#pragma marl - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(50);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHLeRiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRCELL forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.type.text = _titleArr[indexPath.row];
        cell.yue.text = _valueArr[indexPath.row];
        if (indexPath.row == 0) {
            self.payWayCell = cell;
        }
    }else{
        cell.type.text = _titleArr[indexPath.row+4];
        cell.yue.text = _valueArr[indexPath.row+4];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - getter

-(ZWHConsumeView *)headerView{
    if (!_headerView) {
        _headerView = [[ZWHConsumeView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(124))];
    }
    return _headerView;
}


@end
