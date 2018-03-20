//
//  ZWHSearchWordViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSearchWordViewController.h"

#import "ZWHSearchListViewController.h"

#define NORCELL @"uitablecell"

#define EMP @"uitablecellemp"

@interface ZWHSearchWordViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)UITextField *textf;

@property(nonatomic,strong)UIView *titleV;
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)EmptyView *emptyView;
@property(nonatomic,strong)UIView *footerView;

@end

@implementation ZWHSearchWordViewController

- (void)viewWillDisappear:(BOOL)animated
{
    //在视图即将消失的时候判断searchController的活跃状态 ,如果不活跃  则将searchController从视图中移除
    //解决返回时  searchController 不消失的问题
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
    // 返回时结束tableView的编辑状态
    [super setEditing:NO animated:animated];
    [self.tableView setEditing:NO animated:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //searchController创建
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //创建显示搜索结果的控制器
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    //设置开始搜索时背景是否显示
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"搜索";
    //设置位置自适应
    [self.searchController.searchBar sizeToFit];
    //搜索时是否隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.barTintColor =  [ZSColor hexStringToColor:@"f3f3f3"];
    UISearchBar *searchBar = self.searchController.searchBar;
    UIImageView *barImageView = [[[searchBar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor = [ZSColor hexStringToColor:@"f3f3f3"].CGColor;
    barImageView.layer.borderWidth = 1;
    [self creatView];
    
    //self.backBtn.hidden = YES;
    //self.navigationItem.titleView = self.searchController.searchBar;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    _array = [NSMutableArray arrayWithArray:[UserManager searchArr]];
}

-(void)creatNav{
    _textf = [[UITextField alloc]init];
    _textf.backgroundColor = GRAYBACKCOLOR;
    _textf.textColor = [UIColor blackColor];
    [self.view addSubview:_textf];
    _textf.sd_layout
    .topSpaceToView(self.view, HEIGHT_TO(0))
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .widthIs(WIDTH_TO(300))
    .heightIs(HEIGHT_TO(30));
    
    [_textf becomeFirstResponder];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    [btn addTarget:self action:@selector(gettoSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.sd_layout
    .leftSpaceToView(_textf, WIDTH_TO(6))
    .heightIs(HEIGHT_TO(30))
    .widthIs(WIDTH_TO(60))
    .centerYEqualToView(_textf);
}

#pragma mark - 搜索
-(void)gettoSearch{
    if (_textf.text.length == 0) {
        return;
    }
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:_array];
    [arrayM insertObject:_textf.text atIndex:0];
    if (arrayM.count>0) {
        for (NSInteger i=0;i<arrayM.count; i++) {
            if (i>9) {
                [arrayM removeObjectAtIndex:i];
            }
        }
    }
    [UserManager sharedData].searchArr = [NSArray arrayWithArray:arrayM];
    
    ZWHSearchListViewController *vc = [[ZWHSearchListViewController alloc]init];
    vc.text = _textf.text;
    vc.title = @"搜索结果";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64 - HEIGHT_TO(70)) style:UITableViewStylePlain];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NORCELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:EMP];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return HEIGHT_TO(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
    cell.textLabel.text = _array[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHSearchListViewController *vc = [[ZWHSearchListViewController alloc]init];
    vc.text = _array[indexPath.row];
    vc.title = @"搜索结果";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 编辑模式相关方法
//开启和关闭编辑模式，默认可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_array.count == 0) {
        return NO;
    }
    return YES;
}

//开启或关闭移动功能
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//设置编辑的方式(删除或插入)
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置插入
    //默认是删除
    return UITableViewCellEditingStyleDelete;
}

//监听编辑按钮的事件回调方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_array removeObjectAtIndex:indexPath.row];
    [UserManager sharedData].searchArr = _array;
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0) {
        return;
    }
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:_array];
    NSInteger i=0;
    if (arrayM.count > 0) {
        for (NSString *str in arrayM) {
            if ([str isEqualToString:searchBar.text]) {
            }else{
                i++;
            }
        }
    }
    if (i==arrayM.count) {
        [arrayM insertObject:searchBar.text atIndex:0];
    }
    if (arrayM.count>0) {
        for (NSInteger i=0;i<arrayM.count; i++) {
            if (i>9) {
                [arrayM removeObjectAtIndex:i];
            }
        }
    }
    [UserManager sharedData].searchArr = [NSArray arrayWithArray:arrayM];
    _array =  [NSMutableArray arrayWithArray:[UserManager searchArr]];
    [self.tableView reloadData];
    
    ZWHSearchListViewController *vc = [[ZWHSearchListViewController alloc]init];
    vc.text = searchBar.text;
    vc.title = @"搜索结果";
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    [self.view layoutSubviews];
    
    NSString *text = searchController.searchBar.text;
    
    NSLog(@"%@",text);
    
    /*if (self.searchResultArray != nil) {
     [self.searchResultArray removeAllObjects];
     }
     
     self.searchResultArray= [NSMutableArray arrayWithArray:[self.searchArray filteredArrayUsingPredicate:predicate]];
     
     if (self.searchResultArray != NULL && self.searchResultArray.count > 0) {
     [self DataBinWithDataArry:self.searchResultArray];
     }
     
     if ([searchController.searchBar.text isEqualToString:@""]) {
     [self DataBinWithDataArry:self.searchArray];
     }*/
    
}

-(void)buyClicked:(UIButton *)sender{
    _array = [NSMutableArray array];
    [UserManager sharedData].searchArr = _array;
    [self.tableView reloadData];
}

#pragma mark - getter
-(UIView *)titleV{
    if (!_titleV) {
        _titleV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_TO(300), 35)];
        _titleV.backgroundColor = GRAYBACKCOLOR;
    }
    return _titleV;
}

-(EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _emptyView.image = ImageNamed(@"wujilu");
        _emptyView.text = @"您暂无此类记录";
    }
    return _emptyView;
}


-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(100))];
        _footerView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(buyClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = LINECOLOR.CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitle:@"清除历史记录" forState:0];
        [btn setImage:ImageNamed(@"ljq") forState:0];
        [btn setTitleColor:MAINCOLOR forState:0];
        [btn setTitleColor:[UIColor grayColor] forState:0];
        btn.titleLabel.font = FontWithSize(12);
        [_footerView addSubview:btn];
        btn.sd_layout
        .widthIs(HEIGHT_TO(200))
        .topSpaceToView(_footerView, HEIGHT_TO(30))
        .centerXEqualToView(_footerView)
        .heightIs(HEIGHT_TO(HEIGHT_TO(40)));
    }
    return _footerView;
}

@end
