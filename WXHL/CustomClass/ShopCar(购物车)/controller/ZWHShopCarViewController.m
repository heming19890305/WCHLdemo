//
//  ZWHShopCarViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/6.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHShopCarViewController.h"
#import "ZWHSureOrderViewController.h"

#import "ZWHGoodsModel.h"

#import "ZWHShopCarTableViewCell.h"
#import "ZWHPaySuccessViewController.h"
#import "ZWHOrderModel.h"
#import "ZWHOrderDetailViewController.h"

#define CARCELL @"ZWHShopCarTableViewCell"
#define EMPCELL @"uitableviewcell"

@interface ZWHShopCarViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary * dicTT;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;

//合计金额
@property(nonatomic,strong)UILabel *sumMoney;

@property(nonatomic,strong)UILabel *workMoney;

//选择数组
@property(nonatomic,strong)NSMutableArray *selectArray;

@property(nonatomic,strong)UIButton *selectAllB;

@property(nonatomic,strong)EmptyView *emptyView;




@end

@implementation ZWHShopCarViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
//    self.navigationController.navigationBarHidden = NO;
    if (self.tableView) {
        self.dataArray = [NSMutableArray array];
        [_selectArray removeAllObjects];
        [self getSelectAll];
        [self getSumMoney];
        [self getData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    dicTT = [NSDictionary dictionary];
    self.backBtn.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    //[self creatView];
    [self setButton];
    //[self setrefresh];
    [self getData];
    NOTIFY_ADD(getSumMoney, @"shopSum");
    NOTIFY_ADD(refreshData, @"shopcar");
    NOTIFY_ADD(refreshDataSuccess, @"shopcarsuccess");
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAliPay:) name:@"QcancelOrder" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAli) name:@"qyCancel" object:nil];

}
//- (void)getAli{
//    NSLog(@"22222---%@",dicTT);
//    [HttpHandler getOrderDetail:@{@"orderId":dicTT[@"orderId"],@"v_weichao":[UserManager token]} Success:^(id obj) {
//        if (ReturnValue == 200) {
//            NSLog(@"%@",obj);
//            Dismiss;
//            [ZWHOrderModel mj_setupObjectClassInArray:^NSDictionary *{
//                return @{@"goods":@"ZWHGoodsModel"};
//            }];
//            ZWHOrderModel *model = [ZWHOrderModel mj_objectWithKeyValues:obj[@"data"]];
//            ZWHOrderDetailViewController *vc = [[ZWHOrderDetailViewController alloc]init];
//            vc.model = model;
//            vc.title = @"订单详情";
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }else{
//            ShowInfoWithStatus(ErrorMessage);
//        }
//    } failed:^(id obj) {
//        ShowInfoWithStatus(ErrorNet);
//    }];
//}
//- (void)getAliPay:(NSNotification *)notification{
//    NSDictionary * infoDic = [notification object];
//    dicTT = infoDic;
//    NSLog(@"111111----%@",dicTT);

//    [HttpHandler getOrderDetail:@{@"orderId":infoDic[@"orderId"],@"v_weichao":[UserManager token]} Success:^(id obj) {
//        if (ReturnValue == 200) {
//            NSLog(@"%@",obj);
//            Dismiss;
//            [ZWHOrderModel mj_setupObjectClassInArray:^NSDictionary *{
//                return @{@"goods":@"ZWHGoodsModel"};
//            }];
//            ZWHOrderModel *model = [ZWHOrderModel mj_objectWithKeyValues:obj[@"data"]];
//            ZWHOrderDetailViewController *vc = [[ZWHOrderDetailViewController alloc]init];
//            vc.model = model;
//            vc.title = @"订单详情";
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }else{
//            ShowInfoWithStatus(ErrorMessage);
//        }
//    } failed:^(id obj) {
//        ShowInfoWithStatus(ErrorNet);
//    }];

//}
-(void)dealloc{
    NOTIFY_REMOVE(@"shopSum");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)refreshData{
    self.dataArray = [NSMutableArray array];
    [_selectArray removeAllObjects];
    [self getSelectAll];
    [self getSumMoney];
    [self getData];
//    [self.tableView.mj_header beginRefreshing];
}
-(void)refreshDataSuccess{
    //ShowSuccessWithStatus(@"订单支付成功");
//    [self.tableView.mj_header beginRefreshing];
//    ZWHPaySuccessViewController *vc = [[ZWHPaySuccessViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    [HttpHandler getShoppingCartList:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            if (obj[@"data"]) {
                weakSelf.dataArray = [ZWHGoodsModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            }
            if (weakSelf.tableView) {
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf creatView];
                [weakSelf setrefresh];
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
        [_selectArray removeAllObjects];
        [weakSelf getSelectAll];
        [weakSelf getSumMoney];
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)creatView{
    self.view.backgroundColor = ZWHCOLOR(@"f6f6f6");
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    self.navigationItem.rightBarButtonItem = more;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - TAB_HEIGHT - HEIGHT_TO(50)) style:UITableViewStylePlain];

    if (_isSpe) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - HEIGHT_TO(50)) style:UITableViewStylePlain];
        self.backBtn.hidden = NO;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[ZWHShopCarTableViewCell class] forCellReuseIdentifier:CARCELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EMPCELL];

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray.count == 0) {
        return 1;
    }
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return HEIGHT_TO(5);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count==0) {
        return  self.emptyView.height;
    }
    return HEIGHT_TO(119);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMPCELL forIndexPath:indexPath];
        [cell.contentView addSubview:self.emptyView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ZWHShopCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CARCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_dataArray.count > 0) {
            cell.model = _dataArray[indexPath.section];
            cell.selectBtn.tag = indexPath.section;
            [cell.selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectBtn.selected = NO;
            if (_selectArray.count > 0) {
                for (NSString *str in _selectArray) {
                    if ([str isEqualToString:ZWHINTTOSTR(cell.selectBtn.tag)]) {
                        cell.selectBtn.selected = YES;
                    }
                }
            }
        }
        return cell;
    }
}
#pragma mark - 选择
-(void)selectBtnClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_selectArray addObject:ZWHINTTOSTR(sender.tag)];
    }else{
        [_selectArray removeObject:ZWHINTTOSTR(sender.tag)];
    }
    [self getSelectAll];
    [self getSumMoney];
    NSLog(@"%@",_selectArray);
}

//判断是否全选
-(void)getSelectAll{
    if (_dataArray.count == 0) {
        _selectAllB.selected = NO;
        return;
    }
    if (_selectArray.count == _dataArray.count) {
        _selectAllB.selected = YES;
    }else{
        _selectAllB.selected = NO;
    }
}

#pragma mark - 全选方法
-(void)selectAllClicked:(UIButton *)sender{
    if (_dataArray.count > 0) {
        sender.selected = !sender.selected;
        if(sender.selected){
            [_selectArray removeAllObjects];
            for (NSInteger i = 0; i < _dataArray.count; i++) {
                [_selectArray addObject:ZWHINTTOSTR(i)];
            }
            [self getSumMoney];
            [self.tableView reloadData];
        }else{
            [_selectArray removeAllObjects];
            [self getSumMoney];
            [self.tableView reloadData];
        }
    }
    
}

#pragma mark - 底部视图
-(void)setButton{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = LINECOLOR.CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
    [self.view addSubview:view];
    if (_isSpe) {
        view.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view,0)
        .heightIs(HEIGHT_PRO(50));
    }else{
        view.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, TAB_HEIGHT)
        .heightIs(HEIGHT_PRO(50));
    }
    
    _selectAllB = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_selectAllB setTitle:@"全选" forState:0];
    [_selectAllB setImage:ImageNamed(@"a") forState:0];
    [_selectAllB setImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
    [_selectAllB addTarget:self action:@selector(selectAllClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_selectAllB];
    _selectAllB.sd_layout
    .leftSpaceToView(view, WIDTH_PRO(15))
    .centerYEqualToView(view)
    .widthIs(WIDTH_PRO(18.5))
    .heightIs(HEIGHT_PRO(18.5));
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:17 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab.text = @"全选";
    [view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(_selectAllB, WIDTH_TO(3))
    .centerYEqualToView(_selectAllB)
    .autoHeightRatio(0);
    [lab setSingleLineAutoResizeWithMaxWidth:100];
    [lab updateLayout];
    
    
    //[_selectAllB layoutButtonWithEdgeInsetsStyle:TWButtonEdgeInsetsStyleLeft imageTitleSpace:WIDTH_PRO(5)];
    
    UIButton *payB = [UIButton buttonWithType:UIButtonTypeCustom];
    payB.backgroundColor = ZWHCOLOR(@"ff5555");
    [payB setTitle:@"结算" forState:0];
    [payB addTarget:self action:@selector(payClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:payB];
    payB.sd_layout
    .rightSpaceToView(view, 0)
    .topSpaceToView(view, 0)
    .bottomSpaceToView(view, 0)
    .widthIs(WIDTH_PRO(124));
    
    _sumMoney = [[UILabel alloc]init];
    [_sumMoney textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    _sumMoney.text = @"合计：¥0.00";
    [view addSubview:_sumMoney];
    _sumMoney.sd_layout
    .leftSpaceToView(lab, WIDTH_PRO(5))
    .topSpaceToView(view, HEIGHT_TO(5))
    .autoHeightRatio(0)
    .rightSpaceToView(payB, WIDTH_PRO(5));
    
    _workMoney = [[UILabel alloc]init];
    [_workMoney textFont:16 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    _workMoney.text = @"工分：¥0.00";
    [view addSubview:_workMoney];
    _workMoney.sd_layout
    .leftSpaceToView(lab, WIDTH_PRO(5))
    .bottomSpaceToView(view, HEIGHT_TO(5))
    .autoHeightRatio(0)
    .rightSpaceToView(payB, WIDTH_PRO(5));
}

#pragma mark - 购买
-(void)payClicked:(UIButton *)sender{
    if (_selectArray.count == 0) {
        return;
    }
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSString *idx in _selectArray) {
        [arrayM addObject:_dataArray[[idx integerValue]]];
    }
    ZWHSureOrderViewController *vc = [[ZWHSureOrderViewController alloc]init];
    vc.dataArray = [NSArray arrayWithArray:arrayM];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"确认订单";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 删除
-(void)doneClicked:(UIButton *)sender{
    if(_selectArray.count > 0){
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSString *str in _selectArray) {
            for (NSInteger i=0; i < _dataArray.count ; i ++) {
                if ([str integerValue] == i) {
                    ZWHGoodsModel *model = _dataArray[i];
                    [arrayM addObject:model.id];
                }
            }
        }
        [HttpHandler getdelShoppingCartGoods:@{@"id":[UserManager dealWith:arrayM with:@","],@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                for (NSString *str in _selectArray) {
                    [_dataArray removeObjectAtIndex:[str integerValue]];
                }
                [_selectArray removeAllObjects];
                [self getSelectAll];
                [self getSumMoney];
                [self.tableView reloadData];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }
}

//计算金额
-(void)getSumMoney{
    CGFloat sum = 0;
    CGFloat work = 0;
    if (_selectArray.count == 0) {
        _sumMoney.text = @"合计：¥0.00";
        _workMoney.text = @"工分：¥0.00";
        
    }else{
        for (NSString *str in _selectArray) {
            ZWHGoodsModel *model = _dataArray[[str integerValue]];
            sum = sum + [model.price floatValue]*[model.num integerValue];
            work = work + [model.givescore floatValue]*[model.num integerValue];
        }
        _sumMoney.text = [NSString stringWithFormat:@"合计：¥%.2f",sum];
        _workMoney.text = [NSString stringWithFormat:@"工分：¥%.2f",work];
        NSString *label_text2 = _workMoney.text;
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
        [attributedString2 addAttribute:NSFontAttributeName value:FontWithSize(16) range:NSMakeRange(0, label_text2.length)];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3, label_text2.length - 3)];
        _workMoney.attributedText = attributedString2;
    }
}

#pragma mark - getter
-(EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64- HEIGHT_TO(50))];
        if (_isSpe) {
            _emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64- HEIGHT_TO(50));
        }else{
            _emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64- HEIGHT_TO(50)-TAB_HEIGHT);
        }
        _emptyView.image = ImageNamed(@"wujilu");
        _emptyView.text = @"您暂无此类记录";
    }
    return _emptyView;
}

@end
