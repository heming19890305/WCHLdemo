//
//  HMScoreViewController.m
//  WXHL
//
//  Created by tomorrow on 2018/3/15.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreViewController.h"
#import "HMScoreTopViewTableViewCell.h"
#import "HMScoreMidViewTableViewCell.h"

#define TOP_CELL @"HMScoreTopViewTableViewCell"
#define MID_CELL @"HMScoreMidViewTableViewCell"
@interface HMScoreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
//顶部工分数据
@property (nonatomic, strong) NSMutableArray * topScoreDataArr;
//订单数据
@property (nonatomic, strong) NSMutableArray * midOrderDataArr;
//分成数据
@property (nonatomic, strong) NSMutableArray * BottomBoundsDataArr;
@end

@implementation HMScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backBtn.hidden = YES;
    //1.登陆状态判断
    //2.初始化子控件
    [self setupView];
    //3.获取数据
    [self getData];
    
}
//初始化子控件
- (void)setupView
{
    self.view.backgroundColor = [UIColor greenColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -TAB_HEIGHT) style:UITableViewStylePlain];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 400, 200);
   
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册 TabbleViewcell
    [self.tableView registerClass:[HMScoreTopViewTableViewCell class] forCellReuseIdentifier:TOP_CELL];
    [self.tableView registerClass:[HMScoreMidViewTableViewCell class] forCellReuseIdentifier:MID_CELL];
    
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)){
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        }else
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    [self.view addSubview:self.tableView];
    
   
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getData];
    }];
}
//获取数据

- (void)getData
{
    
}


@end
