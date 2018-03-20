
//
//  ZWHSearchBuniViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSearchBuniViewController.h"
#import "ZWHBuinessNorTableViewCell.h"
#import "ZWHBuinessModel.h"

#define NORCELL @"ZWHBuinessNorTableViewCell"
#define EMP @"uitablecell"

@interface ZWHSearchBuniViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UITextField *field;

@property(nonatomic,strong)UIButton *searchB;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation ZWHSearchBuniViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
    //[self creatView];
    //[self setrefresh];
    [self getData];
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 106) style:UITableViewStylePlain];
    [self.tableView registerClass:[ZWHBuinessNorTableViewCell class] forCellReuseIdentifier:NORCELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EMP];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
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

#pragma mark - 数据
-(void)getData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ZWHINTTOSTR(_index) forKey:@"pageNo"];
    [dict setValue:@"20" forKey:@"pageSize"];
    [dict setValue:[UserManager token] forKey:@"v_weichao"];
    if (_field.text.length > 0) {
        [dict setValue:_field.text forKey:@"phone"];
    }
    MJWeakSelf
    [HttpHandler getMyVencircleRelation:dict Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"][@"list"] count] == 0) {
                _index--;
            }
            [_dataArray addObjectsFromArray:[ZWHBuinessModel mj_objectArrayWithKeyValuesArray:obj[@"data"][@"list"]]];
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
        _index++;
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count == 0) {
        return 2;
    }
    return _dataArray.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        if (indexPath.row == 0) {
            return HEIGHT_TO(50);
        }else{
            return SCREENHIGHT-64;
        }
        
    }
    return HEIGHT_TO(50);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(10);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_dataArray.count == 0) {
        if (indexPath.row == 0) {
            ZWHBuinessNorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labnumber = 4;
                cell.textArray = [NSMutableArray arrayWithArray:@[@"商圈编号",@"消费金额",@"提成",@"层级关系"]];
                cell.topline.hidden = NO;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EMP forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.emptyView];
            return cell;
        }
    }else{
        ZWHBuinessNorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labnumber = 4;
        if (indexPath.row == 0) {
            cell.textArray = [NSMutableArray arrayWithArray:@[@"商圈编号",@"消费金额",@"提成",@"层级关系"]];
            cell.topline.hidden = NO;
        }else{
            ZWHBuinessModel *mo = _dataArray[indexPath.row - 1];
            NSArray *array = @[mo.consumerNo,mo.money,mo.deduct,mo.level];
            cell.textArray = [NSMutableArray arrayWithArray:array];
        }
        return cell;
    }
}

#pragma mark - 搜索
-(void)searchClicked{
    [self.view endEditing:YES];
    if (_field.text.length == 0) {
        [self endrefresh];
        return;
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - getter
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH , HEIGHT_TO(60))];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LINECOLOR;
        line.frame = CGRectMake(0, 0, SCREENWIDTH, 1);
        [_headerView addSubview:line];
        _field = [[UITextField alloc]init];
        _field.layer.borderColor = LINECOLOR.CGColor;
        _field.layer.borderWidth = 1;
        _field.placeholder = @"请输入手机号";
        _field.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _field.textColor = ZWHCOLOR(@"666666");
        //设置显示模式为永远显示(默认不显示)
        _field.leftViewMode = UITextFieldViewModeAlways;
        [_headerView addSubview:_field];
        _field.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .widthIs(WIDTH_TO(290))
        .heightIs(HEIGHT_TO(40))
        .topSpaceToView(_headerView, HEIGHT_TO(10));
        
        _searchB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchB setImage:ImageNamed(@"ico") forState:0];
        _searchB.backgroundColor = MAINCOLOR;
        [_searchB addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_searchB];
        _searchB.sd_layout
        .leftSpaceToView(_field, 0)
        .centerYEqualToView(_field)
        .heightRatioToView(_field, 1)
        .widthIs(HEIGHT_TO(50));
        
        
    }
    return _headerView;
}

-(UIImage*)TransformtoSize:(CGSize)Newsize with:(UIImage *)img

{
    
    // 创建一个bitmap的context
    
    UIGraphicsBeginImageContext(Newsize);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0,0, Newsize.width, Newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return TransformedImg;
    
}


-(EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _emptyView.image = ImageNamed(@"wujilu");
        _emptyView.text = @"您暂无此类记录";
    }
    return _emptyView;
}

@end
