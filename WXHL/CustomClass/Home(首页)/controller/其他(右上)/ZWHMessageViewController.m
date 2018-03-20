//
//  ZWHMessageViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHMessageViewController.h"
#import "ZWHMessageModel.h"
#import "ZWHMessageDetailViewController.h"

#import "ZWHMessageTableViewCell.h"

#define MECELL @"ZWHMessageTableViewCell"
#define NORCELL @"uitableview"

@interface ZWHMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation ZWHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
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
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index ++;
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(void)getData{
    MJWeakSelf
    [HttpHandler getMessageList:@{@"v_weichao":[UserManager token],@"pageNo":@(_index),@"pageSize":@20} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            if ([obj[@"data"][@"list"] count] == 0) {
                weakSelf.index -- ;
            }
            [weakSelf.dataArray addObjectsFromArray:[ZWHMessageModel mj_objectArrayWithKeyValuesArray:obj[@"data"][@"list"]]];
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NORCELL];
    [self.tableView registerClass:[ZWHMessageTableViewCell class] forCellReuseIdentifier:MECELL];
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
    if (_dataArray.count == 0) {
        return 1;
    }
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return SCREENHIGHT-64;
    }
    return HEIGHT_TO(128);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
        [cell.contentView addSubview:self.emptyView];
        return cell;
    }else{
        ZWHMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MECELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArray[indexPath.row];
        return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count > 0) {
        ZWHMessageModel *model = _dataArray[indexPath.row];
        ShowProgress
        NotAllowUser
        MJWeakSelf
        [HttpHandler getMessageInfo:@{@"dataId":model.id,@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                Dismiss
                ZWHMessageDetailViewController *vc = [[ZWHMessageDetailViewController alloc]init];
                vc.mestitle = model.title;
                vc.time = model.createDate;
                vc.htmlStr = obj[@"data"][@"content"];
                vc.title = @"消息中心";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                ShowInfoWithStatus(ErrorMessage)
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

// 指定编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 默认是删除模式
    return UITableViewCellEditingStyleDelete;
    //    return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 根据编辑模式设置相应的功能代码
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
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
