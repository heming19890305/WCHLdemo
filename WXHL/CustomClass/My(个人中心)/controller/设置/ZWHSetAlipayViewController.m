//
//  ZWHSetAlipayViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSetAlipayViewController.h"

#import "KJChangeUserInfoTableViewCell.h"

#define KJCHCELL @"KJChangeUserInfoTableViewCell"

@interface ZWHSetAlipayViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_titleArray;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *footView;

@property(nonatomic,copy)NSString *idcard;
@property(nonatomic,copy)NSString *alicard;
@property(nonatomic,copy)NSString *onepas;
@property(nonatomic,copy)NSString *twopas;

@end

@implementation ZWHSetAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"身份证号:",@"支付宝账号:",@"支付密码:",@"确认密码:"];
    [self creatView];
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = GRAYBACKCOLOR;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[KJChangeUserInfoTableViewCell class] forCellReuseIdentifier:KJCHCELL];
    self.tableView.tableFooterView = self.footView;
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

#pragma mark - uitableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KJChangeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KJCHCELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.leftLable textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    if (indexPath.section == 0) {
        cell.leftTitleStr = _titleArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                cell.contentTex.clearButtonMode = UITextFieldViewModeAlways;
                cell.contentTex.text = self.idcard;
                [cell didEndInput:^(NSString *input) {
                    self.idcard = input;
                }];
            }
                break;
            case 1:
            {
                cell.contentTex.text = self.alicard;
                [cell didEndInput:^(NSString *input) {
                    self.alicard = input;
                }];
            }
                break;
            default:
                break;
        }
    }else{
        cell.leftTitleStr = _titleArray[indexPath.row+2];
        switch (indexPath.row) {
            case 1:
            {
                cell.contentTex.text = self.onepas;
                cell.contentTex.secureTextEntry = YES;
                [cell didEndInput:^(NSString *input) {
                    self.onepas = input;
                }];
            }
                break;
            case 0:
            {
                cell.contentTex.text = self.twopas;
                cell.contentTex.secureTextEntry = YES;
                [cell didEndInput:^(NSString *input) {
                    self.twopas = input;
                }];
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return HEIGHT_TO(10);
    }
    return HEIGHT_TO(49);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(40))];
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        lab.text = @"支付密码不是支付宝密码";
        [view addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(view, WIDTH_TO(15))
        .rightSpaceToView(view, WIDTH_TO(15))
        .centerYEqualToView(view)
        .autoHeightRatio(0);
        return view;
    }
    return nil;
}

-(void)saveClicked:(UIButton *)sender{
    if (![_onepas isEqualToString:_twopas]) {
        ShowInfoWithStatus(@"两次密码不相同");
        return;
    }
    if (_idcard.length == 0 || _alicard.length == 0) {
        return;
    }
    [HttpHandler getbindAliPay:@{@"idCard":_idcard,@"aliAccount":_alicard,@"payPassword":_onepas,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"绑定成功");
            NOTIFY_POST(@"myinfodata");
            ONEPOP
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
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(150))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn setTitle:@"保存" forState:0];
        [btn addTarget:self action:@selector(saveClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = MAINCOLOR;
        [_footView addSubview:btn];
        btn.sd_layout
        .leftSpaceToView(_footView, WIDTH_TO(20))
        .rightSpaceToView(_footView, WIDTH_TO(20))
        .topSpaceToView(_footView, HEIGHT_TO(30))
        .heightIs(HEIGHT_TO(50));
    }
    return _footView;
}

@end
