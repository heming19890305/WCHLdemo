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
        self.topScoreDataArr = [NSMutableArray array];
        self.midOrderDataArr = [NSMutableArray array];
        self.BottomBoundsDataArr = [NSMutableArray array];
        [self getData];
    }];
}
//获取数据

- (void)getData
{
    
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_TO(45);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(45))];
    view.backgroundColor = GRAYBACKCOLOR;
    UILabel * leftLabel = [[UILabel alloc] init];
    [leftLabel textFont:16 textColor:MAINCOLOR backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [view addSubview:leftLabel];
    leftLabel.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .centerXEqualToView(view)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(80));
    leftLabel.text = section == 1? @"订单" : @"分成";
    
    UILabel *rig = [[UILabel alloc]init];
    [rig textFont:14 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    [view addSubview:rig];
    rig.sd_layout
    .rightSpaceToView(view, WIDTH_TO(15))
    .centerYEqualToView(view)
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(80));
    rig.text = @"单位:元/个";
    rig.hidden = section==0?NO:YES;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 && indexPath.section == 0) {
        return HEIGHT_TO(100);
    }else if(indexPath.row == 0 && indexPath.section == 0){
        return HEIGHT_TO(80);
    }
    return HEIGHT_TO(40);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
            HMScoreTopViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOP_CELL forIndexPath:indexPath];
            cell.initroColor = [UIColor grayColor];
            cell.titleArray = @[@"当前工分", @"未获得工分"];
            if (_topScoreDataArr.count > 0) {
                cell.dataArray = _topScoreDataArr;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }else {
        HMScoreMidViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MID_CELL forIndexPath:indexPath];
        cell.orderCount.text = @"";
        cell.orderAmount.text = @"";
        [cell.orderCount textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        [cell.orderAmount textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        if (_midOrderDataArr.count == 2) {
            cell.orderCount.text = [NSString stringWithFormat:@"今日订单（笔）%@,", _midOrderDataArr[0]];
            cell.orderAmount.text = [NSString stringWithFormat:@"订单金额（y）%@,", _midOrderDataArr[1]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
        

}
@end
