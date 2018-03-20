//
//  ZWHSettingViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSettingViewController.h"
#import "ZWHMyInfoViewController.h"
#import "BaseTabBarController.h"
#import "BaseNavigationViewController.h"

#import "ZWHLeRiTableViewCell.h"

#define LRCELL @"ZWHLeRiTableViewCell"

@interface ZWHSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *footView;

@property(nonatomic,strong)UISwitch *swith;

@end

@implementation ZWHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
}
#pragma mark - 加载视图

-(void)creatView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = GRAYBACKCOLOR;
    [self.tableView registerClass:[ZWHLeRiTableViewCell class] forCellReuseIdentifier:LRCELL];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = self.footView;
    //self.tableView.tableFooterView.height = HEIGHT_TO(200);
    // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHLeRiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRCELL forIndexPath:indexPath];
    cell.type.textColor = [UIColor blackColor];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                {
                    cell.type.text = @"个人信息";
                    cell.yue.text = @"";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                break;
            case 1:
            {
                cell.type.text = @"我的账户";
                cell.yue.text = @"已保护";
            }
                break;
            case 2:
            {
                cell.type.text = @"消息提醒";
                cell.yue.text = @"";
                _swith = [[UISwitch alloc]init];
                [cell.contentView addSubview:_swith];
                [_swith addTarget:self action:@selector(isgetmessage:) forControlEvents:UIControlEventValueChanged];
                _swith.sd_layout
                .rightSpaceToView(cell.contentView, WIDTH_TO(15))
                .centerYEqualToView(cell.contentView)
                .heightIs(HEIGHT_TO(30))
                .widthIs(WIDTH_TO(60));
            }
                break;
            default:
                break;
        }
    }else{
        cell.type.text = @"关于消费商";
        cell.yue.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MJWeakSelf
    if ( indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([UserManager sharedData].mymodel) {
                ZWHMyInfoViewController *vc = [[ZWHMyInfoViewController alloc]init];
                vc.title = @"个人信息";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    if (indexPath.section == 1) {
        [HttpHandler getArticleInfo:@{@"code":@"gyxfs"} Success:^(id obj) {
            if (ReturnValue == 200) {
                BasicWebViewController *vc = [[BasicWebViewController alloc]init];
                vc.htmlStr = obj[@"data"][@"content"];
                vc.title = @"关于消费商";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }
}

#pragma mark - 是否提醒消息
-(void)isgetmessage:(UISwitch *)sender{
    if (sender.on) {
        NSLog(@"开")
    }else{
        NSLog(@"关");
    }
}

#pragma mark - 退出账号
-(void)letout{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"微超红利提示" message:@"确认退出当前账号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[UserManager sharedData] logOut];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[BaseTabBarController alloc]init]];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}


#pragma mark - getter
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(200))];
        UIButton *oubtn = [UIButton buttonWithType:UIButtonTypeCustom];
        oubtn.layer.cornerRadius = 5;
        oubtn.layer.masksToBounds = YES;
        oubtn.backgroundColor = [UIColor whiteColor];
        [oubtn setTitle:@"退出账号" forState:0];
        [oubtn setTitleColor:[UIColor grayColor] forState:0];
        [oubtn addTarget:self action:@selector(letout) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:oubtn];
        oubtn.sd_layout
        .leftSpaceToView(_footView, WIDTH_TO(20))
        .rightSpaceToView(_footView, WIDTH_TO(20))
        .topSpaceToView(_footView, HEIGHT_TO(20))
        .heightIs(HEIGHT_TO(50));
    }
    return _footView;
}
@end
