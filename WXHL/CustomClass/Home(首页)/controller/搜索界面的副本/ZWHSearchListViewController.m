//
//  ZWHSearchListViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/30.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSearchListViewController.h"
#import "ZWHGoodDetailViewController.h"
#import "ZWHGoodsModel.h"


#import "ZWHHomeCollectionViewCell.h"

#define HomeCollect @"ZWHHomeCollectionViewCell"
#define NORCELL @"uitablecell"

@interface ZWHSearchListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)EmptyView *emptyView;

@end

@implementation ZWHSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    [self setrefresh];
    [self getHomeData];
}



-(void)creatView{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[ZWHHomeCollectionViewCell class] forCellWithReuseIdentifier:HomeCollect];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
}


#pragma mark - 首页数据
-(void)getHomeData{
    MJWeakSelf
    [HttpHandler getGoodsList:@{@"showType":@2,@"pageNo":@(_index),@"pageSize":@20,@"name":_text} Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"] count] == 0) {
                weakSelf.index -- ;
            }
            [weakSelf.dataArray addObjectsFromArray:[ZWHGoodsModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
            if (weakSelf.dataArray.count == 0) {
                [weakSelf.view addSubview:weakSelf.emptyView];
            }
            [weakSelf.collectionView reloadData];
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
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.dataArray = [NSMutableArray array];
        [weakSelf getHomeData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index ++ ;
        [weakSelf getHomeData];
    }];
}

-(void)endrefresh{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - collection

// 返回多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每组返回多少个格子
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZWHHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollect forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.item];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MJWeakSelf
    ZWHGoodsModel *model = _dataArray[indexPath.item];
    NSLog(@"%@",model.id);
    [HttpHandler getGoodInfo:@{@"goodsId":model.id} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHGoodsModel *mo = [ZWHGoodsModel mj_objectWithKeyValues:obj[@"data"]];
            NSLog(@"%@",mo);
            ZWHGoodDetailViewController *vc = [[ZWHGoodDetailViewController alloc]init];
            vc.state = @"0";
            vc.model = mo;
            vc.goodId = model.id;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}



#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        // 初始化一个布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset =UIEdgeInsetsMake(0,0,0, 0);
        // 设置最小行距
        flowLayout.minimumLineSpacing = HEIGHT_PRO(1);
        // 设置最小间距
        flowLayout.minimumInteritemSpacing = WIDTH_PRO(1);
        // 设置格子大小
        flowLayout.itemSize = CGSizeMake(SCREENWIDTH/2 - 1, HEIGHT_TO(215));
        // 设置组边界
        flowLayout.sectionInset = UIEdgeInsetsMake(HEIGHT_PRO(0), WIDTH_PRO(0), 0, WIDTH_PRO(0));
        // 设置头部和底部视图高度
        // flowLayout.headerReferenceSize = CGSizeMake(0, 100);
        //flowLayout.footerReferenceSize = CGSizeMake(0, 100);
        //        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 初始化集合视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT-64) collectionViewLayout:flowLayout];
        // 设置背景色
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 设置代理和数据源
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = LINECOLOR;
    }
    return _collectionView;
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
