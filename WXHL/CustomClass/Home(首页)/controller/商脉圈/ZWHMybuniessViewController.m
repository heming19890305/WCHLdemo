//
//  ZWHMybuniessViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHMybuniessViewController.h"
#import "ZWHBuinessNorTableViewCell.h"
#import "ZWHBuiIconTableViewCell.h"
#import "ZWHBuinessModel.h"

#define NORCELL @"ZWHBuinessNorTableViewCell"
#define ICONCELL @"ZWHBuiIconTableViewCell"

@interface ZWHMybuniessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *bottomV;

/*****底部视图*******/
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UILabel *mynum;
@property(nonatomic,strong)UILabel *money;


@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;

@end

@implementation ZWHMybuniessViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
    [self creatView];
    [self creatBottom];
    [self setrefresh];
    [self getData];
}

-(void)creatBottom{
    _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - HEIGHT_TO(80) - 104, SCREENWIDTH, HEIGHT_TO(80))];
    _bottomV.layer.shadowColor = LINECOLOR.CGColor;//shadowColor阴影颜色
    _bottomV.layer.shadowOffset = CGSizeMake(0,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _bottomV.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    _bottomV.layer.shadowRadius = 3;//阴影半径，默认3
    _bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomV];
    
    _icon = [[UIImageView alloc]init];
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],[UserManager face]]] placeholderImage:ImageNamed(DefautImageName)];
    _icon.layer.cornerRadius = HEIGHT_TO(60)/2;
    _icon.layer.masksToBounds = YES;
    [_bottomV addSubview:_icon];
    _icon.sd_layout
    .leftSpaceToView(_bottomV, WIDTH_TO(10))
    .topSpaceToView(_bottomV, HEIGHT_TO(10))
    .heightIs(HEIGHT_TO(60))
    .widthEqualToHeight();
    
    _num = [[UILabel alloc]init];
    [_num textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _num.text = @"消费商号：666666";
    [_bottomV addSubview:_num];
    _num.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(9))
    .topSpaceToView(_bottomV, HEIGHT_TO(20))
    .autoHeightRatio(0)
    .widthIs(150);
    
    _money = [[UILabel alloc]init];
    [_money textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _money.text = @"消费(元)：666666";
    [_bottomV addSubview:_money];
    _money.sd_layout
    .leftSpaceToView(_icon, WIDTH_TO(9))
    .topSpaceToView(_num, HEIGHT_TO(10))
    .autoHeightRatio(0)
    .widthIs(150);
    
    _mynum = [[UILabel alloc]init];
    [_mynum textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    _mynum.text = @"本圈¥666666";
    [_bottomV addSubview:_mynum];
    _mynum.sd_layout
    .rightSpaceToView(_bottomV, WIDTH_TO(15))
    .topSpaceToView(_bottomV, HEIGHT_TO(20))
    .autoHeightRatio(0)
    .widthIs(150);
    
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 106 - HEIGHT_TO(80)) style:UITableViewStylePlain];
    [self.tableView registerClass:[ZWHBuinessNorTableViewCell class] forCellReuseIdentifier:NORCELL];
    [self.tableView registerClass:[ZWHBuiIconTableViewCell class] forCellReuseIdentifier:ICONCELL];
    
    
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

#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    [HttpHandler getMyVencircle:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            weakSelf.num.text = [NSString stringWithFormat:@"消费商号：%@",obj[@"data"][@"consumerNo"]];
            weakSelf.mynum.text = [NSString stringWithFormat:@"本圈：¥%@",obj[@"data"][@"areaMoney"]];
            weakSelf.money.text = [NSString stringWithFormat:@"消费(元)：%@",obj[@"data"][@"ownMoney"]];
            [weakSelf endrefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
            [weakSelf endrefresh];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
        [weakSelf endrefresh];
    }];
    
    [HttpHandler getMyVencircleMember:@{@"pageNo":@(_index),@"pageSize":@20,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"][@"list"] count] == 0) {
                _index--;
            }
            [_dataArray addObjectsFromArray:[ZWHBuinessModel mj_objectArrayWithKeyValuesArray:obj[@"data"][@"list"]]];
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
        [weakSelf getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _index++;
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(50);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        ZWHBuinessNorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labnumber = 3;
        cell.textArray = [NSMutableArray arrayWithArray:@[@"消费商号",@"消费(元)",@"NO."]];
        cell.topline.hidden = NO;
        return cell;
    }else{
        ZWHBuinessModel *mo = _dataArray[indexPath.row - 1];
        ZWHBuiIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICONCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = mo;
        return cell;
    }
}


@end
