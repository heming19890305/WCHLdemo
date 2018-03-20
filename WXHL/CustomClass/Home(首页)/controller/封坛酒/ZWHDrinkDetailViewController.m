//
//  ZWHDrinkDetailViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHDrinkDetailViewController.h"
#import "ZWHDrinkHeaderView.h"
#import "ZWHLeRiTableViewCell.h"
#import "ZWHDrinkModel.h"
#import "ZWHTextTableViewCell.h"

#define LRCELL @"ZWHLeRiTableViewCell"
#define TEXTCELL @"ZWHTextTableViewCell"

@interface ZWHDrinkDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titleArray;
    NSArray *valueArray;
}

@property(nonatomic,strong)ZWHDrinkHeaderView *headerView;

@property(nonatomic,strong)UIView *footerView;

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ZWHDrinkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray = @[@"酒窖规格",@"封坛编号",@"酒窖周期",@"酒窖类型",@"封坛日期",@"酒窖重量",@"备注",];
    valueArray = @[_model.couponNo==nil?@"":_model.couponNo,_model.cycle==nil?@"":_model.cycle,_model.type==nil?@"":_model.type,_model.createDate==nil?@"":_model.createDate,_model.weight==nil?@"":_model.weight,_model.remark==nil?@"":_model.remark];
    [self createRightNavButton];
    [self creatView];
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ZWHLeRiTableViewCell class] forCellReuseIdentifier:LRCELL];
    [self.tableView registerClass:[ZWHTextTableViewCell class] forCellReuseIdentifier:TEXTCELL];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return titleArray.count - 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(15);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return [tableView cellHeightForIndexPath:indexPath model:[[ZWHDrinkModel alloc]init] keyPath:@"model" cellClass:[ZWHTextTableViewCell class] contentViewWidth:SCREEN_WIDTH - WIDTH_TO(30)];
    }
    return HEIGHT_TO(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ZWHLeRiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRCELL forIndexPath:indexPath];
        [cell.type textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        if (indexPath.row == 0) {
            [cell.type textFont:17 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
            cell.yue.text = @"";
        }
        if (indexPath.section==0) {
            cell.type.text = titleArray[indexPath.row];
        }
        if (indexPath.row>0) {
            cell.yue.text = valueArray[indexPath.row-1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            ZWHLeRiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRCELL forIndexPath:indexPath];
            [cell.type textFont:17 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
            cell.yue.text = @"";
            cell.type.text = [titleArray lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ZWHTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXTCELL forIndexPath:indexPath];
            cell.model = _model;;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
}

#pragma mark - 立刻购买
-(void)awayClicked:(UIButton *)sender{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_model.url]];
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
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(100))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(awayClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = MAINCOLOR.CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitle:@"远程数字酒窖" forState:0];
        [btn setTitleColor:MAINCOLOR forState:0];
        [_footerView addSubview:btn];
        btn.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(20))
        .rightSpaceToView(_footerView, WIDTH_TO(20))
        .topSpaceToView(_footerView, HEIGHT_TO(25))
        .heightIs(HEIGHT_TO(50));
    }
    return _footerView;
}

@end
