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
#import "HMSellScoreViewViewController.h"
//#import "HMPasswordAlertView.h"

#define TOP_CELL @"HMScoreTopViewTableViewCell"
#define MID_CELL @"HMScoreMidViewTableViewCell"
@interface HMScoreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
//顶部工分数据

//订单数据

//分成数据


@property (nonatomic, strong) UIView * headerView;
@end

@implementation HMScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工分";
    self.backBtn.hidden = YES;
    self.view.backgroundColor = [UIColor yellowColor];
    //1.登陆状态判断
    //2.初始化子控件
    [self setupView];
    //3.刷新数据
    [self setRefresh];
    //4.获取数据
    [self getData];
    
}
//初始化子控件
- (void)setupView
{
    self.view.backgroundColor = [UIColor greenColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -TAB_HEIGHT - 150) style:UITableViewStylePlain];
//    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 400, 200);
    self.tableView.backgroundColor = LINECOLOR;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = self.headerView;
//    注册 TabbleViewcell

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
//    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tableView];
   
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self getData];
    }];
    //订单和分成数据
}
//刷新数据
- (void)setRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
//获取数据

- (void)getData
{
    MJWeakSelf
//    NSLog(@"获取数据");
    [HttpHandler getMyWorkpoints:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"+++++++++++%@",obj);
            ZWHMyWorkModel *model = [ZWHMyWorkModel mj_objectWithKeyValues:obj[@"data"]];
            weakSelf.gotScore.text = [NSString stringWithFormat:@"¥%@",model.scorePrice];
            weakSelf.unGotScore.text = [NSString stringWithFormat:@"¥%@",model.userBalance];

            [weakSelf setRefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf setRefresh];
        }
    } failed:^(id obj) {
//        NSLog(@"error = %@",obj);
        ShowInfoWithStatus(ErrorNet);
        [weakSelf setRefresh];
    }];
//     private String consumerNo;
//        private String businessNo
    NSString * urlString = @"http://192.168.2.99:8087/api/workpoints/v1/vipWkpList";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"成功");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败");
    }];
}

//headerView
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(200))];
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"xf_top_bj")];
        [_headerView addSubview:img];
        img.sd_layout
        .leftSpaceToView(_headerView, 0)
        .rightSpaceToView(_headerView, 0)
        .topSpaceToView(_headerView, 0)
        .heightIs(HEIGHT_TO(200));
        //2.添加已获得工分个数
        UILabel *gotScoreLabel = [UILabel new];
        gotScoreLabel.textColor = [UIColor whiteColor];
        NSString * labelText = @"当前工分";
        gotScoreLabel.text = labelText;
        gotScoreLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        //自适应UILabel 大小
        CGSize labelSize = [self addLabel:gotScoreLabel string:labelText];
        [_headerView addSubview:gotScoreLabel];
        gotScoreLabel.sd_layout
        .topSpaceToView(_headerView, 15)
        .centerXEqualToView(_headerView)
        .widthIs(labelSize.width)
        .heightIs(labelSize.height);
        //2.1工分个数
       _gotScore = [UILabel new];
        _gotScore.textColor = [UIColor whiteColor];
        double c = 3628428;
        NSString * str ;
        if (c > 10000) {
            c = c / 10000;
            str = [NSString stringWithFormat:@"%0.2f 万",c];
        }else
        {
            str = [NSString stringWithFormat:@"%0.f",c];
        }
        _gotScore.font = [UIFont systemFontOfSize:28.0];
        //自适应UILabel 大小
        CGSize gotScoreSize = [self addLabel:_gotScore string:str];
        
        _gotScore.numberOfLines = 0;
        [_headerView addSubview:_gotScore];
        _gotScore.sd_layout
        .topSpaceToView(gotScoreLabel, 3)
        .centerXEqualToView(_headerView)
        .widthIs(gotScoreSize.width)
        .heightIs(gotScoreSize.height);
        
        //3.添加未获得工分个数
        //3.0 未获得工分label
        UILabel * unGotSoreLabel = [UILabel new];
        unGotSoreLabel.textColor = [UIColor whiteColor];
        NSString * unGotStr = @"未获得工分";
        unGotSoreLabel.text = unGotStr;
        unGotSoreLabel.font =[UIFont boldSystemFontOfSize:14.f];
        CGSize unGotLabelSize = [self addLabel:unGotSoreLabel string:unGotStr];
        [_headerView addSubview:unGotSoreLabel];
        unGotSoreLabel.sd_layout
        .topSpaceToView(_gotScore, 15)
        .centerXEqualToView(_headerView)
        .widthIs(unGotLabelSize.width)
        .heightIs(unGotLabelSize.height);
        //3.1未获得工分num
      _unGotScore = [UILabel new];
        _unGotScore.textColor = [UIColor whiteColor];
        double d = 12345678;
        NSString * unStr;
        if (d > 10000) {
            d = d / 10000;
            unStr = [NSString stringWithFormat:@"%0.2f 万",d];
        }else{
            unStr = [NSString stringWithFormat:@"%0.f",d];
        }
        _unGotScore.font = [UIFont systemFontOfSize:16.0];
        CGSize unGotScoreSize = [self addLabel:_unGotScore string:unStr];
        _unGotScore.text = unStr;
        _unGotScore.numberOfLines = 0;
        [_headerView addSubview:_unGotScore];
        _unGotScore.sd_layout
        .topSpaceToView(unGotSoreLabel, 3)
        .centerXEqualToView(_headerView)
        .widthIs(unGotScoreSize.width)
        .heightIs(unGotScoreSize.height);
        //4.卖出按钮
        UIButton *sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sellBtn.backgroundColor = [UIColor clearColor];
        [sellBtn addTarget:self action:@selector(sellClick) forControlEvents:UIControlEventTouchUpInside];
        [sellBtn setTitleColor:[UIColor whiteColor] forState:0];
        [sellBtn setTitle:@"卖出工分" forState:0];
        sellBtn.layer.cornerRadius = 5;
        sellBtn.layer.masksToBounds = YES;
        sellBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        sellBtn.layer.borderWidth = 1;
        [_headerView addSubview:sellBtn];
        //        sellBtn.sd_layout.topEqualToView(_num, HEIGHT_TO(31)).lefts
        sellBtn.sd_layout
        .topSpaceToView(_unGotScore, HEIGHT_TO(31))
        .centerXEqualToView(_headerView)
        .widthIs(WIDTH_TO(120))
        .heightIs(HEIGHT_TO(38));
        
        //5.明细
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"明细" forState:0];
        //    [btn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:btn];
        btn.sd_layout
        .topSpaceToView(_headerView, 10)
        .rightSpaceToView(_headerView,0)
        .heightIs(25)
        .widthIs(WIDTH_TO(60));

    }
    return _headerView;
}
//工分卖出按钮
- (void)sellClick
{
    NSLog(@"卖出工分");
    HMSellScoreViewViewController *sellScoreView = [[HMSellScoreViewViewController alloc] init];
    sellScoreView.title = @"卖出工分";
    [self setHidesBottomBarWhenPushed:YES];
    UIBarButtonItem * backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationController pushViewController:sellScoreView animated:YES];
}
//自适应UILabel 大小
- (CGSize)addLabel:(UILabel *)label string:(NSString *)string {
    CGSize widthSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    return widthSize;
}
//数据长度
- (NSString *)data:(float) data{
    NSString * dataStr;
    if (data > 10000) {
        data = data / 10000;
        dataStr = [NSString stringWithFormat:@"%0.2f 万",data];
    }else{
        dataStr = [NSString stringWithFormat:@"%0.f ",data];
    }
    return dataStr;
}
#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    self.tableView.footer.hidden = (self.topics.count == 0);
//    return self.topics.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    HMWordCell *cell = [tableView dequeueReusableCellWithIdentifier:HMWordCellID];
//
//    cell.word = self.topics[indexPath.row];
    //    cell.textLabel.text = word.name;
    //    cell.detailTextLabel.text = word.text;
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:word.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    //    HMLog(@"cellForRowAtIndexPat--------");
//    return cell;
    HMScoreMidViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MID_CELL];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出帖子模型
//    HMWord * word = self.topics[indexPath.row];
    //      HMLog(@"heightForRowAtIndexPath++++++++");
//    return word.cellHeight;
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HMCommentViewController * commentVC = [[HMCommentViewController alloc] init];
//    commentVC.topic = self.topics[indexPath.row];
//    [self.navigationController pushViewController:commentVC animated:YES];
}

@end
