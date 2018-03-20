//
//  ZWHCashViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHCashViewController.h"
#import "ZWHRecharDetailViewController.h"
#import "ZWHCashTableViewCell.h"
#import "PasswordView.h"
#import "ZWHRecharSuccessViewController.h"
#import "ZWHRateModel.h"
#import "ZWHPayPasViewController.h"

#define CASHCELL @"ZWHCashTableViewCell"

@interface ZWHCashViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *bottomV;

@property(nonatomic,strong)PasswordView *pdView;

@property(nonatomic,strong)UIButton *backgroundBtn;

//底部视图属性
@property(nonatomic,strong)UILabel *rate;//服务费比例
@property(nonatomic,strong)UILabel *yue;//余额
@property(nonatomic,strong)UITextField *moneyF;//输入框

@property(nonatomic,strong)UIButton *cashB;
@property(nonatomic,strong)UIButton *takeAll;
@property(nonatomic,strong)ZWHRateModel *reteMo;


@end

@implementation ZWHCashViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
    [self getData];
}

#pragma mark - 各数据
-(void)getData{
    MJWeakSelf
    [HttpHandler getRate:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            weakSelf.reteMo = [ZWHRateModel mj_objectWithKeyValues:obj[@"data"]];
            weakSelf.yue.text = [NSString stringWithFormat:@"余额¥%@",weakSelf.reteMo.cashMoney];
            weakSelf.rate.text = [NSString stringWithFormat:@"提现金额(收取%@%%交易税,最低收取%@元)",weakSelf.reteMo.taxRatio,weakSelf.reteMo.cashCost];
        }else{
            ShowErrorWithStatus(ErrorMessage);
            ONEPOP
        }
    } failed:^(id obj) {
        ShowErrorWithStatus(ErrorNet);
        ONEPOP
    }];
}

#pragma mark - 加载视图
-(void)creatView{
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(showDetail:)];
    self.navigationItem.rightBarButtonItem = more;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.tableView registerClass:[ZWHCashTableViewCell class] forCellReuseIdentifier:CASHCELL];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = GRAYBACKCOLOR;
    self.tableView.tableFooterView = self.bottomV;
    self.tableView.tableFooterView.height = 500;
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return HEIGHT_TO(20);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(20);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHCashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CASHCELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)dismisChooseView{
    [_backgroundBtn removeFromSuperview];
    [_pdView removeFromSuperview];
}

#pragma mark - 支付
-(void)nextClicked:(UIButton *)sender{
    if (_moneyF.text.length == 0) {
        return;
    }
    [self.view endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundBtn.backgroundColor = [UIColor blackColor];
    _backgroundBtn.alpha = 0.5;
    [_backgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_backgroundBtn];
    _backgroundBtn.sd_layout
    .topEqualToView(window)
    .leftEqualToView(window)
    .rightEqualToView(window)
    .bottomEqualToView(window);
    MJWeakSelf
    _pdView = [[PasswordView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(210), self.view.bounds.size.width, SCREENHIGHT - HEIGHT_TO(210))];
    _pdView.returnPasswordStringBlock = ^(NSString *password){
        [weakSelf dismisChooseView];
        [HttpHandler getsponsorWithdrawDeposit:@{@"money":weakSelf.moneyF.text,@"paypwd":password,@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                ShowSuccessWithStatus(@"提现成功");
                weakSelf.moneyF.text = @"";
                [weakSelf getData];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    };
    _pdView.dismissV = ^{
        [weakSelf.backgroundBtn removeFromSuperview];
        [weakSelf.pdView removeFromSuperview];
    };
    
    _pdView.findpw = ^{
        NSLog(@"忘记密码");
        NSLog(@"忘记密码");
        [weakSelf dismisChooseView];
        ZWHPayPasViewController *vc = [[ZWHPayPasViewController alloc]init];
        vc.title = @"支付密码";
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    [window addSubview:_pdView];
}

#pragma mark - 查看明细
-(void)showDetail:(UIButton *)sender{
    ZWHRecharDetailViewController *vc = [[ZWHRecharDetailViewController alloc]init];
    vc.state = @"4";
    vc.title = @"提现明细";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 限制位数和小数点
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(((string.intValue<0) || (string.intValue>9))){
        //MyLog(@"====%@",string);
        if ((![string isEqualToString:@"."])) {
            return NO;
        }
        return NO;
    }
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger dotNum = 0;
    NSInteger flag=0;
    const NSInteger limited = 2;
    if((int)futureString.length>=1){
        
        if([futureString characterAtIndex:0] == '.'){//the first character can't be '.'
            return NO;
        }
        if((int)futureString.length>=2){//if the first character is '0',the next one must be '.'
            if(([futureString characterAtIndex:1] != '.'&&[futureString characterAtIndex:0] == '0')){
                return NO;
            }
        }
    }
    NSInteger dotAfter = 0;
    for (int i = (int)futureString.length-1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            dotNum ++;
            dotAfter = flag+1;
            if (flag > limited) {
                return NO;
            }
            if(dotNum>1){
                return NO;
            }
        }
        flag++;
    }
    if(futureString.length - dotAfter > 10){
        return NO;
    }
    NSLog(@"%@--%@",textField.text,string);
    _yue.text = [NSString stringWithFormat:@"额外扣除交易税%.2f",[_moneyF.text floatValue]*[_reteMo.taxRatio floatValue]];
    if ([_moneyF.text floatValue]*[_reteMo.taxRatio floatValue]<[_reteMo.cashCost floatValue]) {
        _yue.text = [NSString stringWithFormat:@"额外扣除交易税%.2f",[_reteMo.cashCost floatValue]];
    }
    if (textField.text.length == 1 && string.length == 0) {
        _yue.text = [NSString stringWithFormat:@"余额¥%@",_reteMo.cashMoney];
        _cashB.enabled = NO;
        _cashB.backgroundColor = [UIColor grayColor];
    }else{
        _cashB.enabled = YES;
        _cashB.backgroundColor = MAINCOLOR;
    }
    return YES;
}

#pragma mark - 全部提现
-(void)tabkeAllClicked{
    NSNumber *nnum = [NSNumber numberWithString:_reteMo.cashMoney];
    _moneyF.text = [NSString stringWithFormat:@"%ld",[nnum integerValue]];
    _yue.text = [NSString stringWithFormat:@"额外扣除交易税%.2f",[_moneyF.text floatValue]*[_reteMo.taxRatio floatValue]];
    _cashB.enabled = YES;
    _cashB.backgroundColor = MAINCOLOR;
}


#pragma mark - getter
-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 500)];
        _bottomV.backgroundColor = GRAYBACKCOLOR;
        
        UIView *contexV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(152))];
        contexV.backgroundColor = [UIColor whiteColor];
        [_bottomV addSubview:contexV];
        
        
        _rate = [[UILabel alloc]init];
        [_rate textFont:13 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _rate.text = @"提现金额";
        [contexV addSubview:_rate];
        _rate.sd_layout
        .leftSpaceToView(contexV, WIDTH_TO(15))
        .topSpaceToView(contexV, HEIGHT_TO(15))
        .rightSpaceToView(contexV, WIDTH_TO(15))
        .autoHeightRatio(0);
        
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:40 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        lab.text = @"¥";
        [contexV addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(contexV, WIDTH_TO(15))
        .topSpaceToView(_rate, HEIGHT_TO(12))
        .autoHeightRatio(0);
        [lab setSingleLineAutoResizeWithMaxWidth:200];
        
        [lab updateLayout];
        
        _moneyF = [[UITextField alloc]init];
        _moneyF.font = FontWithSize(30);
        _moneyF.textColor = [UIColor blackColor];
        _moneyF.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyF.delegate = self;
        [contexV addSubview:_moneyF];
        _moneyF.sd_layout
        .leftSpaceToView(lab, WIDTH_TO(5))
        .centerYEqualToView(lab)
        .rightSpaceToView(contexV, WIDTH_TO(15))
        .heightRatioToView(lab, 1);
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LINECOLOR;
        [contexV addSubview:line];
        line.sd_layout
        .leftSpaceToView(contexV, 0)
        .rightSpaceToView(contexV, 0)
        .topSpaceToView(lab, HEIGHT_TO(12))
        .heightIs(1);
        
        _yue = [[UILabel alloc]init];
        [_yue textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _yue.text = @"余额¥988.00";
        [contexV addSubview:_yue];
        _yue.sd_layout
        .leftSpaceToView(contexV, WIDTH_TO(15))
        .topSpaceToView(line, 0)
        .rightSpaceToView(contexV, WIDTH_TO(15))
        .bottomSpaceToView(contexV, 0);
        
        
        _takeAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takeAll setTitle:@"全部提现" forState:0];
        [_takeAll setTitleColor:MAINCOLOR forState:0];
        _takeAll.backgroundColor = [UIColor clearColor];
        [_takeAll addTarget:self action:@selector(tabkeAllClicked) forControlEvents:UIControlEventTouchUpInside];
        _takeAll.titleLabel.font = FontWithSize(15);
        [contexV addSubview:_takeAll];
        _takeAll.sd_layout
        .rightSpaceToView(contexV, WIDTH_TO(15))
        .centerYEqualToView(_yue)
        .widthIs(HEIGHT_TO(80))
        .heightRatioToView(_yue, 1);
        
        [_takeAll setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        _cashB = [UIButton buttonWithType:UIButtonTypeCustom];
        _cashB.backgroundColor = [UIColor grayColor];
        _cashB.enabled = NO;
        [_cashB setTitleColor:[UIColor whiteColor] forState:0];
        [_cashB setTitle:@"两天内到账，确认提现" forState:0];
        _cashB.layer.cornerRadius = 5;
        _cashB.layer.masksToBounds = YES;
        [_cashB addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomV addSubview:_cashB];
        _cashB.sd_layout
        .leftSpaceToView(_bottomV, WIDTH_TO(20))
        .rightSpaceToView(_bottomV, WIDTH_TO(20))
        .heightIs(HEIGHT_TO(60))
        .topSpaceToView(contexV, HEIGHT_TO(30));
    }
    return _bottomV;
}
@end
