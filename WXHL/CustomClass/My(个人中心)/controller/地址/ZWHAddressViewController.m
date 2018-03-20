//
//  ZWHAddressViewController.m
//  WLStore
//
//  Created by Syrena on 2017/10/31.
//  Copyright © 2017年 yuanSheng. All rights reserved.
//

#import "ZWHAddressViewController.h"
#import "ZWHAddressTableViewCell.h"
#import "ZWHEditAddressViewController.h"
#import "ZWHAddressModel.h"


#define ADRCELL @"ZWHAddressTableViewCell"
#define EMPCEll @"uitableviewcell"

@interface ZWHAddressViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _page;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger selectSect;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UIView *footView;
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation ZWHAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    //[self creatView];
    //[self setrefresh];
    [self getData];
    NOTIFY_ADD(getData, @"address");
    UIBarButtonItem *rigB = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addDriverClicked:)];
    [rigB setTintColor:[UIColor grayColor]];
    self.navigationController.navigationItem.rightBarButtonItem = rigB;
    self.navigationItem.rightBarButtonItem = rigB;
}

-(void)dealloc{
    NOTIFY_REMOVE(@"address");
}



#pragma mark - 加载视图
-(void)creatView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - HEIGHT_TO(60)) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.tableFooterView = self.footView;;
    
    
    [self.tableView registerClass:[ZWHAddressTableViewCell class] forCellReuseIdentifier:ADRCELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EMPCEll];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footView];
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        } else {
        }
    }
}

#pragma mark - 数据
-(void)getData{
    MJWeakSelf
    [HttpHandler getConsignees:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            if (obj[@"data"]) {
                weakSelf.dataArray = [ZWHAddressModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            }
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
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}




#pragma mark - 添加
-(void)addDriverClicked:(UIBarButtonItem *)sender{
    NSLog(@"添加");
    ZWHEditAddressViewController *vc = [[ZWHEditAddressViewController alloc]init];
    vc.state = @"0";
    vc.title = @"添加地址";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设为默认
-(void)setNorAddress:(UIButton *)sender{
    if (sender.selected == YES) {
        return;
    }
    ZWHAddressModel *mo = _dataArray[sender.tag - 10];
    MJWeakSelf
    [HttpHandler getsetDefaultAddress:@{@"id":mo.id,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}
#pragma mark - 编辑
-(void)editAddress:(UIButton *)sender{
    NSLog(@"%ld编辑",sender.tag);
    ZWHAddressModel *mo = _dataArray[sender.tag - 10];
    ZWHEditAddressViewController *vc = [[ZWHEditAddressViewController alloc]init];
    vc.state = @"1";
    vc.model = mo;
    vc.title = @"编辑地址";
    [self.navigationController pushViewController:vc animated:YES];
    /*[HttpHandler getConsigneeInfo:@{@"id":mo.id,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            ZWHAddressModel *model = [ZWHAddressModel mj_objectWithKeyValues:obj[@"data"]];
            NSLog(@"%@",model.id);
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];*/
}
#pragma mark - 删除
-(void)deleteAddress:(UIButton *)sender{
    NSLog(@"%ld删除 ",sender.tag);
    MJWeakSelf
    UIAlertController *switchAlertController = [UIAlertController alertControllerWithTitle:@"是否删除该收货地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    ZWHAddressModel *mo = _dataArray[sender.tag - 10];
    UIAlertAction *sureAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HttpHandler getdelConsignee:@{@"dataId":mo.id,@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                ShowSuccessWithStatus(@"删除成功");
                [weakSelf.tableView.mj_header beginRefreshing];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }];
    [switchAlertController addAction:sureAction];
    [switchAlertController addAction:cancelAction];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window.rootViewController presentViewController:switchAlertController animated:YES completion:nil];
}

#pragma mark - tableview

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray.count==0) {
        return 1;
    }
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return SCREENHIGHT-64;
    }
    ZWHAddressModel *mo = _dataArray[indexPath.section];
    //return HEIGHT_PRO(90);
    return [tableView cellHeightForIndexPath:indexPath model:mo keyPath:@"model" cellClass:[ZWHAddressTableViewCell class] contentViewWidth:SCREENWIDTH];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        return CGFLOAT_MIN;
    }
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return HEIGHT_TO(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        return CGFLOAT_MIN;
    }
    return HEIGHT_PRO(40);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_dataArray.count==0) {
        return  [UIView new];
    }
    ZWHAddressModel *mo = _dataArray[section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(50))];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 10 + section;
    [btn addTarget:self action:@selector(setNorAddress:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = NO;
    if ([mo.defaultFlag integerValue]==1) {
        btn.selected = YES;
    }
    [btn setTitle:@"设为默认" forState:0];
    [btn setTitleColor:ZWHCOLOR(@"6f6f6f") forState:0];
    //[btn setBackgroundImage:ImageNamed(@"a") forState:UIControlStateNormal];
   //[btn setBackgroundImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
    [btn setImage:ImageNamed(@"a") forState:UIControlStateNormal];
    [btn setImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
    [btn setTitleColor:ZWHCOLOR(@"6f6f6f") forState:0];
    btn.titleLabel.font = FontWithSize(12);
    [view addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(view, WIDTH_PRO(15))
    .heightIs(HEIGHT_PRO(25))
    .centerYEqualToView(view)
    .widthIs(WIDTH_PRO(25+60));
    [btn layoutButtonWithEdgeInsetsStyle:TWButtonEdgeInsetsStyleLeft imageTitleSpace:WIDTH_PRO(7)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:12 textColor:ZWHCOLOR(@"6f6f6f") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab.text = @"设为默认";
    [view addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(btn, WIDTH_TO(6))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(80))
    .centerYEqualToView(btn);
    lab.hidden = YES;
    
    /*UIButton *set = [UIButton buttonWithType:UIButtonTypeCustom];
    set.backgroundColor = [UIColor clearColor];
    [view addSubview:set];
    set.sd_layout
    .leftEqualToView(lab)
    .bottomEqualToView(lab)
    .*/
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.tag = 10 + section;
    [deleteBtn addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitle:@"删除" forState:0];
    [deleteBtn setImage:ImageNamed(@"lajit") forState:UIControlStateNormal];
    [deleteBtn setTitleColor:ZWHCOLOR(@"6f6f6f") forState:0];
    deleteBtn.titleLabel.font = FontWithSize(12);
    [view addSubview:deleteBtn];
    deleteBtn.sd_layout
    .rightSpaceToView(view, WIDTH_PRO(15))
    .heightIs(HEIGHT_PRO(25))
    .centerYEqualToView(view)
    .widthIs(WIDTH_PRO(60));
    [deleteBtn layoutButtonWithEdgeInsetsStyle:TWButtonEdgeInsetsStyleLeft imageTitleSpace:WIDTH_PRO(7)];
    deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    
    UIButton *editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.tag = 10 + section;
    [editbtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    [editbtn setTitle:@"编辑" forState:0];
    [editbtn setImage:ImageNamed(@"bianji") forState:UIControlStateNormal];
    [editbtn setTitleColor:ZWHCOLOR(@"6f6f6f") forState:0];
    editbtn.titleLabel.font = FontWithSize(12);
    [view addSubview:editbtn];
    editbtn.sd_layout
    .rightSpaceToView(deleteBtn,WIDTH_PRO(22.5))
    .heightIs(HEIGHT_PRO(25))
    .centerYEqualToView(view)
    .widthIs(WIDTH_PRO(60));
    [editbtn layoutButtonWithEdgeInsetsStyle:TWButtonEdgeInsetsStyleLeft imageTitleSpace:WIDTH_PRO(7)];
    editbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMPCEll forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.emptyView];
        return cell;
    }else{
        ZWHAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADRCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArray[indexPath.section];
        return cell;
    }
}

-(void)backClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count==0) {
        return;
    }
    ZWHAddressModel *model = _dataArray[indexPath.section];
    if (_clicked) {
        _clicked(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 新建
-(void)creatAddress{
    ZWHEditAddressViewController *vc = [[ZWHEditAddressViewController alloc]init];
    vc.state = @"0";
    vc.title = @"新建地址";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHIGHT-HEIGHT_TO(60)-64, SCREENWIDTH, HEIGHT_TO(60))];
        _footView.backgroundColor = [UIColor whiteColor];
        
        /*UIView *lineview = [[UIView alloc]init];
        lineview.backgroundColor = GRAYBACKCOLOR;
        [_footView addSubview:lineview];
        lineview.sd_layout
        .leftSpaceToView(_footView, 0)
        .rightSpaceToView(_footView, 0)
        .topSpaceToView(_footView, 0)
        .heightIs(HEIGHT_TO(10));*/
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn addTarget:self action:@selector(creatAddress) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"新建地址" forState:0];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = MAINCOLOR;
        [_footView addSubview:btn];
        btn.sd_layout
        .leftSpaceToView(_footView, WIDTH_TO(20))
        .rightSpaceToView(_footView, WIDTH_TO(20))
        .topSpaceToView(_footView, HEIGHT_TO(0))
        .heightIs(HEIGHT_TO(50));
    }
    return _footView;
}

#pragma mark - getter
-(EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _emptyView.image = ImageNamed(@"wujilu");
        _emptyView.text = @"您暂无此类记录";
    }
    return _emptyView;
}
@end
