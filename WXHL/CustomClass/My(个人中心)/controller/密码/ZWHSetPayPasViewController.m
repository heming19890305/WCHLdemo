//
//  ZWHSetPayPasViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSetPayPasViewController.h"

#import "KJChangeUserInfoTableViewCell.h"

#define KJCHCELL @"KJChangeUserInfoTableViewCell"

@interface ZWHSetPayPasViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_titleArray;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *footView;

@property(nonatomic,copy)NSString *idcard;
@property(nonatomic,copy)NSString *pas;
@property(nonatomic,copy)NSString *repas;

@end

@implementation ZWHSetPayPasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"身份证",@"新密码",@"确认新密码"];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftTitleStr = _titleArray[indexPath.row];
    [cell showRightImage:NO];
    [cell.leftLable textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    MJWeakSelf
    switch (indexPath.row) {
        case 0:
        {
            cell.contentTex.placeholder = @"请输入身份证号";
            cell.contentTex.clearButtonMode = UITextFieldViewModeAlways;
            [cell didEndInput:^(NSString *input) {
                weakSelf.idcard = input;
            }];
        }
            break;
        case 1:
        {
            cell.contentTex.keyboardType = UIKeyboardTypeNumberPad;
            cell.contentTex.placeholder = @"6位数字字符";
            cell.contentTex.secureTextEntry = YES;
            [cell didEndInput:^(NSString *input) {
                weakSelf.pas = input;
            }];
        }
            break;
        case 2:
        {
            cell.contentTex.keyboardType = UIKeyboardTypeNumberPad;
            cell.contentTex.placeholder = @"6位数字字符";
            cell.contentTex.secureTextEntry = YES;
            [cell.rightbtn addTarget:self action:@selector(showpassClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell showRightImage:YES];
            cell.rightImage.image = ImageNamed(@"mima_yc");
            [cell didEndInput:^(NSString *input) {
                weakSelf.repas = input;
            }];
            //cell.rightImage.backgroundColor = MAINCOLOR;
        }
            break;
        default:
            break;
    }
    return cell;
}
#pragma mark - 提交
-(void)sureClicked{
    [self.view endEditing:YES];
    if ([_pas length]!=6) {
        ShowInfoWithStatus(@"请输入正确的密码");
        return;
    }
    if (![_pas isEqualToString:_repas]) {
        ShowInfoWithStatus(@"两次输入密码不同");
        return;
    }
    ShowProgress
    NotAllowUser
    [HttpHandler getchangePayPassword:@{@"code":_phone,@"idCard":_idcard,@"newPass":_pas,@"confirmPass":_repas,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"设置成功");
            [self.navigationController popToViewController:self.navigationController.childViewControllers[0] animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}


#pragma mark - 显示密码
-(void)showpassClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    KJChangeUserInfoTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.contentTex.secureTextEntry = sender.selected;
}


#pragma mark - getter
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(120))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn setTitle:@"提交" forState:0];
        [btn addTarget:self action:@selector(sureClicked) forControlEvents:UIControlEventTouchUpInside];
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
