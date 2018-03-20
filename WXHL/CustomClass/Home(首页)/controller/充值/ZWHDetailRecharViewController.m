//
//  ZWHDetailRecharViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHDetailRecharViewController.h"
#import "ZWHWorkModel.h"
#import "ZWHBalaeceModel.h"
#import "ZWHLeRiTableViewCell.h"
#import "ZWHRechargeModel.h"

#define LRCELL @"ZWHLeRiTableViewCell"

@interface ZWHDetailRecharViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,assign)NSInteger rowNum;

@end

@implementation ZWHDetailRecharViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rowNum = 0;
    if ([_state integerValue] == 4) {
        _titleArray = @[@"记录编号",@"提货券来源",@"提货券数量",@"创建时间"];
        _rowNum = _titleArray.count;
    }
    if ([_state integerValue] == 3) {
        _titleArray = @[@"交易编号",@"工分交易数量",@"工分当日单价",@"创建时间",@"转换金额",@"交易类型",@"交易时间"];
        _rowNum = _titleArray.count;
    }
    if ([_state integerValue] == 2) {
        ZWHBalaeceModel *model = (ZWHBalaeceModel *)_model;
        switch ([model.changeType integerValue]) {
            case 1:
                _titleArray = @[@"订单号",@"交易金额",@"当前余额",@"创建时间"];
                break;
            case 2:
                _titleArray = @[@"订单号",@"交易金额",@"当前余额",@"创建时间"];
                break;
            case 3:
                _titleArray = @[@"商品名称",@"商品数量",@"支付方式",@"支付金额",@"货柜编号",@"商品数量",@"赠送工分市值",@"赠送工分个数",@"当日工分单价",@"货到",@"编号",@"交易流水号",@"交易时间"];
                break;
            case 4:
                _titleArray = @[@"交易编号",@"工分交易数量",@"工分当日单价",@"交易类型",@"转换金额",@"交易时间"];
                break;
            case 5:
                _titleArray = @[@"提现编号",@"提现金额",@"交易税",@"到账金额",@"提现状态",@"到账银行",@"银行卡号",@"审计员",@"交易时间"];
                break;
            case 6:
                _titleArray = @[@"提成金额",@"计算对象",@"提成源",@"到账时间",@"提成比例",@"时间"];
                break;
            case 7:
                _titleArray = @[@"提现编号",@"提现金额",@"交易税",@"到账金额",@"体现状态",@"失败原因",@"退款时间",@"审计员",@"交易时间"];
                break;
            default:
                break;
        }
        _rowNum = _titleArray.count;
    }
    
    [self creatView];
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.tableView registerClass:[ZWHLeRiTableViewCell class] forCellReuseIdentifier:LRCELL];
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

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _rowNum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHLeRiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRCELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type.text = _titleArray[indexPath.row];
    if ([_state integerValue]==4) {
        ZWHRechargeModel *model = (ZWHRechargeModel *)_model;
        switch (indexPath.row) {
            case 0:
                cell.yue.text = model.consumerNo;
                break;
            case 1:
                cell.yue.text = model.changeTypeName;
                break;
            case 2:
                cell.yue.text = model.money;
                break;
            case 3:
                cell.yue.text = model.createDate;
                break;
            default:
                break;
        }
    }else if ([_state integerValue]==3) {
        ZWHWorkModel *mo = (ZWHWorkModel *)_model;
        switch (indexPath.row) {
            case 0:
                cell.yue.text = mo.tradeNo;
                break;
            case 1:
                cell.yue.text = [NSString stringWithFormat:@"+%@",mo.changeNum];
                cell.yue.textColor = [UIColor greenColor];
                break;
            case 2:
                cell.yue.text = mo.unitPrice;
                break;
            case 3:
                cell.yue.text = mo.createDate;
                break;
            case 4:
                cell.yue.text = mo.money;
                break;
            case 5:
                cell.yue.text = mo.changeType;
                break;
            case 6:
                cell.yue.text = mo.createDate;
                break;
            default:
                break;
        }
    }else if ([_state integerValue] == 2){
        ZWHBalaeceModel *mo = (ZWHBalaeceModel *)_model;
        NSArray *valueArray;
        switch ([mo.changeType integerValue]) {
            case 1:
            {
                valueArray = @[mo.consumerNo,mo.money,mo.afterMoney,mo.createDate];
                cell.yue.text = valueArray[indexPath.row];
            }
                break;
            case 2:
            {
                valueArray = @[mo.consumerNo,mo.money==nil?@"":mo.money,mo.afterMoney,mo.createDate];
                cell.yue.text = valueArray[indexPath.row];
            }
                break;
                /*    _titleArray = @[@"商品名称",@"商品数量",@"支付方式",@"支付金额",@"货柜编号",@"商品数量",@"赠送工分市值",@"赠送工分个数",@"当日工分单价",@"货到",@"编号",@"交易流水号",@"交易时间"];
                 break;
                 case 4:
                 _titleArray = @[@"交易编号",@"工分交易数量",@"工分单日单价",@"交易类型",@"转换金额",@"交易时间"];
                 break;
                 case 5:
                 _titleArray = @[@"提现编号",@"提现金额",@"交易税",@"到账金额",@"提现状态",@"到账银行",@"银行卡号",@"审计员",@"交易时间"];
                 break;
                 case 6:
                 _titleArray = @[@"提成金额",@"计算对象",@"提成源",@"到账时间",@"提成比例",@"时间"];*/
            case 4:
            {
                valueArray = @[mo.orderNo,mo.scoreNum==nil?@"":mo.scoreNum,mo.scorePrice==nil?@"":mo.scorePrice,mo.changeTypeName==nil?@"":mo.changeTypeName,mo.money,mo.createDate];
                cell.yue.text = valueArray[indexPath.row];
            }
                break;
            case 5:
            {
                valueArray = @[mo.orderNo,mo.money==nil?@"":mo.money,mo.tradeTax==nil?@"":mo.tradeTax,mo.endingMoney==nil?@"":mo.endingMoney,mo.status==nil?@"":mo.status,mo.bankName==nil?@"":mo.bankName,mo.bankCard==nil?@"":mo.bankCard,mo.operater==nil?@"":mo.operater,mo.createDate];
                cell.yue.text = valueArray[indexPath.row];
            }
                break;
            case 6:
            {
                /*_titleArray = @[@"提成金额",@"计算对象",@"提成源",@"到账时间",@"提成比例",@"时间"];*/
                valueArray = @[mo.money,mo.computeObject==nil?@"":mo.computeObject,mo.source==nil?@"":mo.source,mo.createDate,mo.rate==nil?@"":mo.rate,mo.createDate];
                cell.yue.text = valueArray[indexPath.row];
            }
                break;
            case 7:
            {
                /*@[@"提现编号",@"提现金额",@"交易税",@"到账金额",@"体现状态",@"失败原因",@"退款时间",@"审计员",@"交易时间"];*/
                valueArray = @[mo.orderNo,mo.money,mo.tradeTax==nil?@"":mo.tradeTax,mo.endingMoney==nil?@"":mo.endingMoney==nil?@"":mo.endingMoney,mo.status==nil?@"":mo.status,mo.content==nil?@"":mo.content,mo.refundTime==nil?@"":mo.refundTime,mo.operater==nil?@"":mo.operater,mo.createDate];
                cell.yue.text = valueArray[indexPath.row];
            }
                break;
            default:
                break;
        }
        
    }
    return cell;
}

@end
