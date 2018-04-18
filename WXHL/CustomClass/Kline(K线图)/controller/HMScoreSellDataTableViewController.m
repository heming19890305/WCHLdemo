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
#import "PasswordView.h"

#import "HMScoreModel.h"
#import "HMScoreTableViewCell.h"
#import "HMSellScoreViewViewController.h"

#import "HMScoreDetailFrame.h"


#define norCell @"ZWHOrderTableViewCell.h"
#define speCell @"ZWHSpeOrderTableViewCell.h"

#define EMPCELL @"uitableview"

@interface HMScoreSellDataTableViewController ()<UITableViewDelegate,UITableViewDataSource, SellScoreBtnDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)PasswordView *pdView;

@property(nonatomic,strong)UIButton *backgroundBtn;
@property(nonatomic,strong)ZWHChoosePayWayView *paywayView;
@property(nonatomic,strong)EmptyView *emptyView;

@property (nonatomic, assign) float cellHeight;

@property(nonatomic,strong)UIButton *chbackgroundBtn;

@property(nonatomic,assign)NSInteger idx;

@property(nonatomic,assign)NSInteger way;


@property (nonatomic, assign, ) BOOL isButtonSelected;
//@property(nonatomic,strong)PasswordView *pdView;
@end

@implementation HMScoreSellDataTableViewController
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
//    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self creatView];
    //[self setrefresh];
    [self getData];
    NOTIFY_ADD(refresh, @"orderlist");
    NOTIFY_ADD(refresh,@"paySuccessAliPay");
    NOTIFY_ADD(payfaild, @"cancelOrderWayChat");
    _isButtonSelected = NO;
    //筛选按钮
    [self addSelectBtn];

}
//筛选按钮
- (void)addSelectBtn
{
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 0, 40, 30);
    selectBtn.selected = NO;
    [selectBtn setTitle:@"卖" forState:0];
    [selectBtn setTitle:@"全部" forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor blueColor] forState:0];
    [selectBtn addTarget:self action:@selector(selecctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    [self.navigationItem setRightBarButtonItem:rightBtn];
                                  
    
    
}

- (void)selecctBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    _isButtonSelected = !_isButtonSelected;
    [self.tableView reloadData];
    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbb = %d",_isButtonSelected);
    
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
    }else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return SCREENHIGHT - 64 - 40;
    }
    HMScoreModel *model = _dataArray[indexPath.section];
    if ([model.status isEqualToString:@"0"] ) {
        if (_isButtonSelected)
        {
            return 0;
        }
        return  150;
    }else
    {
        return  200;
    }
}
/**调整两个cell之间的间距***/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    HMScoreModel *model = _dataArray[section];
    if ([model.status isEqualToString:@"0"] ) {
        if (_isButtonSelected)
        {
            return 0.01;
        }
        return  10;
    }else
    {
        return  12;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
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
        cell.degegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        scoreModel = _dataArray[indexPath.section];

        cell.model = scoreModel;
        if ([scoreModel.status isEqualToString:@"0"]) {
            if (_isButtonSelected) {
//
                cell.hidden = YES;
            }
            cell.sellScore_Btn.hidden = YES;
            cell.diveLine.hidden = YES;
        }else
        {
//
            cell.sellScore_Btn.hidden = NO;
            cell.diveLine.hidden = NO;
        }
        
        
        return cell;
    }

}

#pragma mark - 实现SellScoreBtnDelegate 代理
- (void)sellScoreBtn:(HMScoreModel*)btn
{
    MJWeakSelf
  
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _chbackgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _chbackgroundBtn.backgroundColor = [UIColor blackColor];
    _chbackgroundBtn.alpha = 0.5;
    [_chbackgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_chbackgroundBtn];
    _chbackgroundBtn.sd_layout
    .topEqualToView(window)
    .leftEqualToView(window)
    .rightEqualToView(window)
    .bottomEqualToView(window);
    _pdView = [[PasswordView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(210), self.view.bounds.size.width, SCREENHIGHT - HEIGHT_TO(210))];
    _pdView.returnPasswordStringBlock = ^(NSString *password){
//        NSLog(@"密码------- =%@",btn);
        [weakSelf dismisChooseView];
        ShowProgress
        NotAllowUser
        NSString *paywaystr = [NSString stringWithFormat:@"%ld",weakSelf.idx+1];
        [weakSelf.view endEditing:true];

        [HttpHandler sellScoreData:@{@"wkpId":btn, @"payPwd":password, @"v_weichao":[UserManager token]} Success:^(id obj) {
//             NSLog(@"工分卖出 --------====== %@",obj);
            if (ReturnValue == 200) {
//                NSLog(@"工分卖出 --------====== %@",obj);
                ShowSuccessWithStatus(@"支付成功");
                //   [weakSelf successClicked];
            }
        } failed:^(id obj) {
             ShowInfoWithStatus(ErrorNet);
        }];
    };
            _pdView.dismissV = ^{
                [weakSelf.chbackgroundBtn removeFromSuperview];
                [weakSelf.pdView removeFromSuperview];
            };
        
            _pdView.findpw = ^{
                NSLog(@"忘记密码");
                [weakSelf dismisChooseView];
                ZWHPayPasViewController *vc = [[ZWHPayPasViewController alloc]init];
                vc.title = @"支付密码";
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        
            [window addSubview:_pdView];
    
}

-(void)dismisChooseView{
    [_chbackgroundBtn removeFromSuperview];
    [_pdView removeFromSuperview];
}

@end



