//
//  HMScoreSellDataTableViewController.m
//  WXHL
//
//  Created by tomorrow on 2018/4/8.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "HMScoreSellDataTableViewController.h"

//
//  ZWHBaseOrderListViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHBaseOrderListViewController.h"


#import "ZWHLogisticsViewController.h"
#import "ZWHPayPasViewController.h"
#import "ZWHOrderTableViewCell.h"
#import "ZWHSpeOrderTableViewCell.h"
#import "ZWHJudgeViewController.h"
#import "PasswordView.h"
#import "ZWHOrderModel.h"
#import "ZWHGoodsModel.h"
#import "ZWHRecharSuccessViewController.h"
#import "ZWHOrderDetailViewController.h"
#import "ZWHChoosePayWayView.h"

#import "HMScoreModel.h"
#import "HMScoreTableViewCell.h"


#define norCell @"ZWHOrderTableViewCell.h"
#define speCell @"ZWHSpeOrderTableViewCell.h"

#define EMPCELL @"uitableview"

@interface HMScoreSellDataTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)PasswordView *pdView;

@property(nonatomic,strong)UIButton *backgroundBtn;
@property(nonatomic,strong)ZWHChoosePayWayView *paywayView;
@property(nonatomic,strong)EmptyView *emptyView;

@property (nonatomic, assign) float cellHeight;
@end

@implementation HMScoreSellDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self creatView];
    //[self setrefresh];
    [self getData];
    NOTIFY_ADD(refresh, @"orderlist");
    NOTIFY_ADD(refresh,@"paySuccessAliPay");
    NOTIFY_ADD(payfaild, @"cancelOrderWayChat");
}

-(void)refresh{
    [self.tableView.mj_header beginRefreshing];
}

-(void)payfaild{
    //ShowSuccessWithStatus(@"支付取消");
}

-(void)dealloc{
    NOTIFY_REMOVE(@"orderlist");
    NOTIFY_REMOVE(@"paySuccessAliPay");
    NOTIFY_REMOVE(@"cancelOrderWayChat");
}

#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ZWHINTTOSTR(_index) forKey:@"pageNo"];
    [dict setValue:@"20" forKey:@"pageSize"];
    [dict setValue:[UserManager token] forKey:@"v_weichao"];
    switch ([_state integerValue]) {
        case 1:
            [dict setValue:@"0" forKey:@"status"];
            break;
        case 2:
            [dict setValue:@"2" forKey:@"status"];
            break;
        case 3:
            [dict setValue:@"3" forKey:@"status"];
            break;
        default:
            break;
    }
    
    [HttpHandler getScoreData:dict Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"+++obj+++%@",obj);
            if ([obj[@"data"] count] == 0) {
                weakSelf.index -- ;
            }
//            [ZWHOrderModel mj_setupObjectClassInArray:^NSDictionary *{
//                return @{@"goodsList":@"ZWHGoodsModel"};
//            }];
            [weakSelf.dataArray addObjectsFromArray:[HMScoreModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
            //            for (int i = 0; i < weakSelf.dataArray.count; i++) {
            //                NSLog(@"++++dataArray+++=%@",weakSelf.dataArray[i]);
            //            }
          
            [weakSelf.tableView reloadData];
            NSLog(@"在这里呀！在这里呀！在这里呀！在这里呀！在这里呀！")
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
        [weakSelf getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index ++ ;
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 加载视图  跳转方法

-(void)creatView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = ORDERBACK;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HMScoreTableViewCell class] forCellReuseIdentifier:norCell];
//    [self.tableView registerClass:[ZWHSpeOrderTableViewCell class] forCellReuseIdentifier:speCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EMPCELL];
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
    if (_dataArray.count ==0) {
        return 1;
    }
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count > 0) {
        return 1;
    }
//    if (_dataArray.count > 0) {
//        ZWHOrderModel *model = _dataArray[section];
//        return model.goodsList.count;
//    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_dataArray.count == 0) {
//        return SCREENHIGHT - 64 - 40;
//    }
//    ZWHOrderModel *model = _dataArray[indexPath.section];
//    if ([model.status integerValue] ==3) {
//        //ZWHGoodsModel *ordermodel = model.goodsList[indexPath.row];
//        /*if ([ordermodel.commentFlag integerValue]==1) {
//         return HEIGHT_TO(120);
//         }*/
//        return HEIGHT_TO(160);
//    }
    return  _cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMPCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.emptyView];
        return cell;
    }else
    {
        HMScoreModel * scoreModel;
        HMScoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:norCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        scoreModel = _dataArray[indexPath.section];
        _cellHeight = cell.cellHeight;
        cell.model = scoreModel;
        
        return cell;
    }
//    else{
//        ZWHOrderModel *order;
//        if (_dataArray.count > 0) {
//            order = _dataArray[indexPath.section];
//        }
//        if ([order.status integerValue]==3) {
            ZWHSpeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:speCell forIndexPath:indexPath];
//            cell.num.hidden = NO;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (_dataArray.count > 0) {
//                MJWeakSelf
//                ZWHOrderModel *model = _dataArray[indexPath.section];
//                cell.ordermodel = model.goodsList[indexPath.row];
//                cell.clicked = ^(ZWHGoodsModel *model) {
//                    [weakSelf evlClicked:model];
//                };
//            }
//            return cell;
//        }else{
//            ZWHOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:norCell forIndexPath:indexPath];
//            cell.num.hidden = NO;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (_dataArray.count > 0) {
//                ZWHOrderModel *model = _dataArray[indexPath.section];
//                cell.ordermodel = model.goodsList[indexPath.row];
//            }
//            return cell;
//        }
//    }
}



@end



