//
//  ZWHLogisticsViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHLogisticsViewController.h"
#import "ZWHLogistModel.h"

#import "ZWHLogisticsTableViewCell.h"
#import "ZWHLogHeaderTableViewCell.h"

#define HECELL @"ZWHLogHeaderTableViewCell"
#define LOCELL @"ZWHLogisticsTableViewCell.h"

@interface ZWHLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)ZWHLogistModel *mymodel;
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation ZWHLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self createRightNavButton];
    [self creatView];
    [self getdata];
}

-(void)getdata{
    MJWeakSelf
    [HttpHandler getlogisticsInfo:@{@"orderId":_orderId,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            weakSelf.mymodel = [ZWHLogistModel mj_objectWithKeyValues:obj[@"data"]];
            [weakSelf.tableView reloadData];
            if (weakSelf.mymodel.list.count == 0) {
                [weakSelf.view addSubview:weakSelf.emptyView];
            }
        }else{
            [weakSelf.view addSubview:weakSelf.emptyView];
            ShowInfoWithStatus(@"暂无物流信息");
        }
    } failed:^(id obj) {
        [weakSelf.view addSubview:weakSelf.emptyView];
        ShowInfoWithStatus(ErrorNet);
    }];
}

-(void)creatView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ZWHLogisticsTableViewCell class] forCellReuseIdentifier:LOCELL];
    
    [self.tableView registerClass:[ZWHLogHeaderTableViewCell class] forCellReuseIdentifier:HECELL];
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
    if (_mymodel.list.count>0) {
        return 2;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (_mymodel) {
        return _mymodel.list.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return HEIGHT_TO(10);
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HEIGHT_TO(120);
    }
    return HEIGHT_TO(70);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ZWHLogHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HECELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.goodsmodel = _goodsmodel;
        if (_mymodel) {
            cell.model = _mymodel;
        }
        return cell;
    }else{
        ZWHLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LOCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.img.backgroundColor = MAINCOLOR;
            cell.intro.textColor = MAINCOLOR;
            cell.topline.hidden = YES;
        }
        if (_mymodel.list.count > 0) {
            NSDictionary *dict = _mymodel.list[indexPath.row];
            cell.intro.text = dict[@"context"];
        }
        return cell;
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
