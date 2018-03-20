//
//  ZWHConsumeViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHConsumeViewController.h"
#import "ZWHConsumeDetailViewController.h"

#import "ZWHComsumModel.h"

#import "ZWHConsumeTableViewCell.h"

#define CONCELL @"ZWHConsumeTableViewCell"
#define NORCELL @"uitableviewcell"

@interface ZWHConsumeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation ZWHConsumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _index = 1;
    //[self creatView];
    //[self setrefresh];
    [self getHomeData];
}

- (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *dang = [NSDate date];
    dateStr = [format stringFromDate:dang];
    
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingMonths:1];
        lastDate = [firstDate dateByAddingTimeInterval:interval - 60];
    }else {
        return @[@"",@""];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstString = [myDateFormatter stringFromDate: firstDate];
    NSString *lastString = [myDateFormatter stringFromDate: lastDate];
    return @[firstString, lastString];
}


#pragma mark - 首页数据
-(void)getHomeData{
    NSArray *timearr = [self getMonthFirstAndLastDayWith:@""];
    MJWeakSelf
    [HttpHandler getConsumptionList:@{@"startDate":timearr[0],@"endDate":timearr[1],@"pageNo":@(_index),@"pageSize":@20,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"] count] == 0) {
                weakSelf.index -- ;
            }
            [weakSelf.dataArray addObjectsFromArray:[ZWHComsumModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[ZWHConsumeTableViewCell class] forCellReuseIdentifier:CONCELL];
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


#pragma mark - uitableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

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
    return HEIGHT_TO(70);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
        return CGFLOAT_MIN;
    }
    return HEIGHT_TO(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.emptyView];
        return  cell;
    }else{
    ZWHConsumeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CONCELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return;
    }
    ZWHConsumeDetailViewController *vc = [[ZWHConsumeDetailViewController alloc]init];
    vc.model = _dataArray[indexPath.row];
    vc.title = @"消费详情";
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(40))];
    view.backgroundColor = GRAYBACKCOLOR;
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"本月消费记录";
    [lab textFont:17 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .centerYEqualToView(view)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(200));
    if (_dataArray.count == 0) {
        return nil;
    }else{
        return view;
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
