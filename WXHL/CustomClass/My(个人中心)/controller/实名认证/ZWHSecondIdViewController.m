//
//  ZWHSecondIdViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSecondIdViewController.h"
#import "ZWHThridViewController.h"


#import "KJChangeUserInfoTableViewCell.h"


#define KJCHCELL @"KJChangeUserInfoTableViewCell"

@interface ZWHSecondIdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UIView *footerView;

@property(nonatomic,strong)UIButton *nextB;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *idnum;

@end

@implementation ZWHSecondIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
}

-(void)creatView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"拍照指南" style:UIBarButtonItemStylePlain target:self action:@selector(editClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[KJChangeUserInfoTableViewCell class] forCellReuseIdentifier:KJCHCELL];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KJChangeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KJCHCELL forIndexPath:indexPath];
    cell.isWidTitle = YES;
    cell.view.hidden = NO;
    cell.contentTex.textColor = [UIColor grayColor];
    cell.contentTex.font = FontWithSize(14);
    cell.contentTex.textAlignment = NSTextAlignmentLeft;
    MJWeakSelf
    switch (indexPath.row) {
        case 0:
            {
                cell.leftTitleStr = @"本人姓名";
                [cell didEndInput:^(NSString *input) {
                    weakSelf.name = input;
                }];
            }
            break;
        case 1:
        {
            cell.leftTitleStr = @"本人身份证";
            cell.contentTex.keyboardType = UIKeyboardTypeNumberPad;
            [cell didEndInput:^(NSString *input) {
                weakSelf.idnum = input;
            }];
        }
            break;
        default:
            break;
    }
    cell.leftLable.textColor = [UIColor grayColor];
    cell.leftLable.font = FontWithSize(14);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 拍照指南
-(void)editClicked:(UIBarButtonItem *)sender{
    MJWeakSelf
    [HttpHandler getArticleInfo:@{@"code":@"pzzn"} Success:^(id obj) {
        if (ReturnValue == 200) {
            BasicWebViewController *vc = [[BasicWebViewController alloc]init];
            vc.htmlStr = obj[@"data"][@"content"];
            vc.title = @"拍照指南";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - 下一步
-(void)nextClicked:(UIButton *)sender{
    NSLog(@"下一步");
    [self.view endEditing:YES];
    if (_name.length == 0 || _name.length>10) {
        ShowInfoWithStatus(@"请输入正确的姓名");
        return;
    }
    if (![NSString accurateVerifyIDCardNumber:_idnum]) {
        ShowInfoWithStatus(@"请输入正确的身份证号");
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_name forKey:@"name"];
    [dict setValue:_idnum forKey:@"idCard"];
    ZWHThridViewController *vc = [[ZWHThridViewController alloc]init];
    vc.imgArray = self.imgArray;
    vc.dict = dict;
    vc.title = self.title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        lab.text = @"请上传本人身份证信息，一经提交不可修改";
        [_footerView addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(15))
        .rightSpaceToView(_footerView, WIDTH_TO(15))
        .autoHeightRatio(0)
        .topSpaceToView(_footerView, HEIGHT_TO(20));
        
        
        _nextB = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextB.layer.cornerRadius = 5;
        _nextB.layer.masksToBounds = YES;
        _nextB.enabled = YES;
        [_nextB addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_nextB setBackgroundImage:[UIImage imageWithColor:MAINCOLOR] forState:UIControlStateNormal];
        [_nextB setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [_nextB setTitle:@"下一步" forState:0];
        [_nextB setTitle:@"下一步" forState:UIControlStateDisabled];
        [_nextB setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_nextB setTitleColor:[UIColor whiteColor] forState:0];
        
        [_footerView addSubview:_nextB];
        _nextB.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(20))
        .rightSpaceToView(_footerView, WIDTH_TO(20))
        .topSpaceToView(lab, HEIGHT_TO(20))
        .heightIs(HEIGHT_TO(50));
        
        [_nextB updateLayout];
        
        CGFloat footY = CGRectGetMaxY(_nextB.frame);
        
        _footerView.frame = CGRectMake(0, 0, SCREENWIDTH,footY + HEIGHT_TO(20));
    }
    return _footerView;
}


-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(500))];
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"lc_02")];
        [_headerView addSubview:img];
        img.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(50))
        .topSpaceToView(_headerView, HEIGHT_TO(6));
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = LINECOLOR;
        [_footerView addSubview:view];
        view.sd_layout
        .leftEqualToView(_footerView)
        .rightEqualToView(_footerView)
        .bottomEqualToView(_footerView)
        .heightIs(1);
        
       // CGFloat headerY = CGRectGetMaxY(labf.frame);
        _headerView.frame = CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(86));
    }
    return _headerView;
}

@end
