//
//  ZWHCollectViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHCollectViewController.h"

#import "ZWHCollectTableViewCell.h"
#import "ZWHCollectModel.h"
#import "ZWHGoodsModel.h"
#import "ZWHGoodDetailViewController.h"

#define COLLCELL @"ZWHCollectTableViewCell"
#define NORCELL @"uitableviewcell"

@interface ZWHCollectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIBarButtonItem *item;

@property(nonatomic,assign)BOOL isedit;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)EmptyView *emptyView;

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *selectArray;

@end

@implementation ZWHCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收藏(0)";
    _index = 1;
    _dataArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    //[self creatView];
    [self getHomeData];
}


-(void)creatView{
    self.view.backgroundColor = [UIColor whiteColor];
    _item = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(editClicked:)];
    
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"menu")  style:UIBarButtonItemStylePlain target:self action:@selector(showMore)];
    self.navigationItem.rightBarButtonItems = @[more,_item];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[ZWHCollectTableViewCell class] forCellReuseIdentifier:COLLCELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NORCELL];
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

#pragma mark - 数据
-(void)getHomeData{
    MJWeakSelf
    [HttpHandler getMyCollection:@{@"v_weichao":[UserManager token],@"pageNo":@(_index),@"pageSize":@20} Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"] count] == 0) {
                weakSelf.index -- ;
            }
            [weakSelf.dataArray addObjectsFromArray:[ZWHCollectModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
            weakSelf.title = [NSString stringWithFormat:@"我的收藏(%ld)",(unsigned long)weakSelf.dataArray.count];
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

-(void)setrefresh{
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isedit = NO;
        weakSelf.selectArray = [NSMutableArray array];
        weakSelf.dataArray = [NSMutableArray array];
        [weakSelf getHomeData];
    }];
    /*self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index ++ ;
        [weakSelf getHomeData];
    }];*/
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 删除
-(void)editClicked:(UIBarButtonItem *)sender{
    _isedit = !_isedit;
    if (_isedit) {
        [_item setTitle:@"删除"];
        [_item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:0];
        [self.tableView reloadData];
    }else{
        if (_selectArray.count > 0) {
            NSString *delstr = @"";
            for (NSString *str in _selectArray) {
                ZWHCollectModel *model = _dataArray[[str integerValue]];
                delstr = [NSString stringWithFormat:@"%@,%@",delstr,model.id];
            }
            [HttpHandler getdelConllection:@{@"id":delstr,@"v_weichao":[UserManager token]} Success:^(id obj) {
                if (ReturnValue == 200) {
                    [_item setTitle:@"删除"];
                    [_item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:0];
                    for (NSString *str in _selectArray) {
                        [_dataArray removeObjectAtIndex:[str integerValue]];
                        [self.tableView reloadData];
                    }
                    [_selectArray removeAllObjects];
                }else{
                    _isedit = !_isedit;
                    ShowInfoWithStatus(ErrorMessage);
                }
            } failed:^(id obj) {
                _isedit = !_isedit;
                ShowInfoWithStatus(ErrorNet);
            }];
        }else{
            [_item setTitle:@"删除"];
            [_item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:0];
            [self.tableView reloadData];
        }
    }
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
        return SCREEN_HEIGHT-64;
    }
    return HEIGHT_TO(120);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.emptyView];
        return cell;
    }else{
        ZWHCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COLLCELL forIndexPath:indexPath];
        cell.isedit = _isedit;
        cell.model = _dataArray[indexPath.row];
        cell.selectB.tag = indexPath.row + 10;
        cell.selectB.selected = NO;
        [cell.selectB addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_selectArray.count > 0) {
            for (NSString *idx in _selectArray) {
                if ([idx integerValue]+10 == cell.selectB.tag) {
                    cell.selectB.selected = YES;
                }
            }
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return;
    }
    MJWeakSelf
    ZWHCollectModel *model = _dataArray[indexPath.item];
    NSLog(@"%@",model.id);
    NSString *str = [NSString stringWithString:model.goodid];
    [HttpHandler getGoodInfo:@{@"goodsId":str} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHGoodsModel *mo = [ZWHGoodsModel mj_objectWithKeyValues:obj[@"data"]];
            NSLog(@"%@",mo);
            ZWHGoodDetailViewController *vc = [[ZWHGoodDetailViewController alloc]init];
            vc.state = @"0";
            vc.model = mo;
            vc.goodId = model.id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - 多选
-(void)selectClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_selectArray addObject:ZWHINTTOSTR(sender.tag - 10)];
    }else{
        [_selectArray removeObject:ZWHINTTOSTR(sender.tag - 10)];
    }
}



#pragma mark - getter
-(EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
        _emptyView.image = ImageNamed(@"wujilu");
        _emptyView.text = @"您暂无此类记录";
    }
    return _emptyView;
}


@end
