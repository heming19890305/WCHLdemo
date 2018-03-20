//
//  ZWHBangBankViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHBangBankViewController.h"
#import "ZWHBankModel.h"
#import "KJSexChooseView.h"

#import "KJChangeUserInfoTableViewCell.h"

#define KJCHCELL @"KJChangeUserInfoTableViewCell"

@interface ZWHBangBankViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_titleArray;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)NSMutableArray *bankArray;

@property (nonatomic, strong) UIButton *backgroundBtn;
@property (nonatomic,strong)KJSexChooseView * stylechoose;
@property(nonatomic,strong)ZWHBankModel *model;

/*持卡人 卡号*/
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *banknum;

@end

@implementation ZWHBangBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"持卡人:",@"卡号:",@"选择银行:"];
    self.tableView.backgroundColor = GRAYBACKCOLOR;
    [self creatView];
    
}
-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = GRAYBACKCOLOR;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[KJChangeUserInfoTableViewCell class] forCellReuseIdentifier:KJCHCELL];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footView;
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

#pragma mark - uitableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KJChangeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KJCHCELL forIndexPath:indexPath];
    cell.isWidTitle = YES;
    [cell showRightImage:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftTitleStr = _titleArray[indexPath.row];
    [cell.leftLable textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    cell.contentTex.textAlignment = NSTextAlignmentLeft;
    cell.contentTex.enabled = YES;
    cell.contentTex.keyboardType = UIKeyboardTypeDefault;
    MJWeakSelf
    switch (indexPath.row) {
        case 0:
        {
            if ([UserManager name].length>0) {
                cell.contentTex.text = [UserManager name];
                weakSelf.name = [UserManager name];
            }
            [cell didEndInput:^(NSString *input) {
                weakSelf.name = input;
            }];
        }
            break;
        case 1:
        {
            cell.contentTex.keyboardType = UIKeyboardTypeNumberPad;
            [cell didEndInput:^(NSString *input) {
                weakSelf.banknum = input;
            }];
        }
            break;
        case 2:
        {
            cell.contentTex.enabled = NO;
            cell.contentTex.textAlignment = NSTextAlignmentRight;
            [cell showRightImage:YES];
            if (_model) {
                cell.contentTex.text = _model.name;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(20);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        MJWeakSelf
        [HttpHandler getDictInfo:@{@"type":@"banktype"} Success:^(id obj) {
            if (ReturnValue == 200) {
                weakSelf.bankArray = [ZWHBankModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
                NSMutableArray *arrayM = [NSMutableArray array];
                for (ZWHBankModel *mo in weakSelf.bankArray) {
                    [arrayM addObject:mo.name];
                }
                [weakSelf showChooseWithArry:arrayM changeKey:@"bank" changeIndex:indexPath];
            }else{
                ShowInfoWithStatus(ErrorMessage);
                ONEPOP
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
            ONEPOP
        }];
    }
}

#pragma mark - 保存
-(void)saveClicked{
    [self.view endEditing:YES];
    MJWeakSelf
    if (_name.length == 0 || _name.length > 10) {
        ShowInfoWithStatus(@"请输入正确昵称(昵称不能过长或没有)");
        return;
    }
    if (![_banknum bankCardluhmCheck]) {
        ShowInfoWithStatus(@"请输入正确的银行卡账号");
        return;
    }
    if (!_model) {
        ShowInfoWithStatus(@"请选择对应银行");
        return;
    }
    ShowProgress
    NotAllowUser
    [HttpHandler getaddBankCard:@{@"v_weichao":[UserManager token],@"owner":_name,@"cardNo":_banknum,@"bank":_model.name} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"绑定成功");
            NOTIFY_POST(@"myinfodata");
            [UserManager sharedData].cardNo = _banknum;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToViewController:weakSelf.navigationController.childViewControllers[weakSelf.navigationController.childViewControllers.count -3] animated:YES];
            });
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - getter
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(100))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn setTitle:@"保存" forState:0];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = MAINCOLOR;
        [_footView addSubview:btn];
        btn.sd_layout
        .leftSpaceToView(_footView, WIDTH_TO(20))
        .rightSpaceToView(_footView, WIDTH_TO(20))
        .topSpaceToView(_footView, HEIGHT_TO(30))
        .heightIs(HEIGHT_TO(50));
        [btn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

#pragma mark - 选择器

//选择
-(void)showChooseWithArry:(NSArray *)arry changeKey:(NSString *)key changeIndex:(NSIndexPath *)index{
    
    [self.view endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backgroundBtn.alpha = 0;
    self.backgroundBtn.backgroundColor = [UIColor blackColor];
    [self.backgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:self.backgroundBtn];
    self.backgroundBtn.sd_layout
    .topEqualToView(window)
    .leftEqualToView(window)
    .rightEqualToView(window)
    .bottomEqualToView(window);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundBtn.alpha = 0.5;
    }];
    self.stylechoose = [[KJSexChooseView alloc]init];
    [window addSubview:self.stylechoose];
    MJWeakSelf
    [self.stylechoose showInView:window withAllSelects:arry didselect:^(NSString *choose,NSInteger selectIndex) {
        [weakSelf.backgroundBtn removeFromSuperview];
        [weakSelf.stylechoose removeFromSuperview];
        if(choose.length>0){
            if([key isEqualToString:@"bank"]){
                NSLog(@"%ld",selectIndex);
                weakSelf.model = weakSelf.bankArray[selectIndex];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

-(void)dismisChooseView{
    [self.backgroundBtn removeFromSuperview];
    [self.stylechoose removeFromSuperview];
}

@end
