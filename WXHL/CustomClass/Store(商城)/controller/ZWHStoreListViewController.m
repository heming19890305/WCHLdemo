//
//  ZWHStoreListViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHStoreListViewController.h"
#import "ZWHGoodDetailViewController.h"
#import "ZWHGoodsModel.h"


#import "ZWHHomeCollectionViewCell.h"

#define HomeCollect @"ZWHHomeCollectionViewCell"
@interface ZWHStoreListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)EmptyView *emptyView;


@end

@implementation ZWHStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _dataArray = [NSMutableArray array];
    //[self creatView];
    //[self setrefresh];
    [self getHomeData];
}

-(void)creatView{
    // 初始化一个布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset =UIEdgeInsetsMake(0,0,0, 0);
    
    // 设置最小行距
    flowLayout.minimumLineSpacing = HEIGHT_PRO(0);
    // 设置最小间距
    flowLayout.minimumInteritemSpacing = WIDTH_PRO(0);
    // 设置格子大小
    flowLayout.itemSize = CGSizeMake(SCREENWIDTH/2, HEIGHT_TO(215));
    // 设置组边界
    flowLayout.sectionInset = UIEdgeInsetsMake(HEIGHT_PRO(0), WIDTH_PRO(0), 0, WIDTH_PRO(0));
    // 初始化集合视图
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT-64-40-HEIGHT_TO(150)) collectionViewLayout:flowLayout];
    // 设置背景色
    _collectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理和数据源
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[ZWHHomeCollectionViewCell class] forCellWithReuseIdentifier:HomeCollect];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
}


#pragma mark - 首页数据
-(void)getHomeData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@2 forKey:@"showType"];
    if ([_state integerValue]>0) {
        [dict setValue:_dict[@"code"] forKey:@"goodType"];
    }
    [dict setValue:@(_index) forKey:@"pageNo"];
    [dict setValue:@20 forKey:@"pageSize"];
    
    MJWeakSelf
    [HttpHandler getGoodsList:dict Success:^(id obj) {
        if (ReturnValue == 200) {
            if ([obj[@"data"] count] == 0) {
                weakSelf.index -- ;
            }
            [weakSelf.dataArray addObjectsFromArray:[ZWHGoodsModel mj_objectArrayWithKeyValuesArray:obj[@"data"]]];
            if (weakSelf.collectionView) {
                [weakSelf.collectionView reloadData];
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

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return CGSizeMake(SCREENWIDTH, SCREENHIGHT-64-40-HEIGHT_TO(150));
    }
    return CGSizeMake(SCREENWIDTH/2 , HEIGHT_TO(215));
}

// 返回多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每组返回多少个格子
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataArray.count == 0) {
        return 1;
    }
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        [cell addSubview:self.emptyView];
        return cell;
    }else{
        ZWHHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollect forIndexPath:indexPath];
        cell.model = _dataArray[indexPath.item];
        cell.layer.borderColor = LINECOLOR.CGColor;
        cell.layer.borderWidth = 0.5;
        return cell;
        
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count==0) {
        return;
    }
    MJWeakSelf
    ZWHGoodsModel *model = _dataArray[indexPath.item];
    NSLog(@"%@",model.id);
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    if ([UserManager token].length>0) {
        [dictM setValue:[UserManager token] forKey:@"v_weichao"];
    }
    [dictM setValue:model.id forKey:@"goodsId"];
    [HttpHandler getGoodInfo:dictM Success:^(id obj) {
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
/*- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
    }
    return _collectionView;
}*/

-(EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHIGHT-64-40-HEIGHT_TO(150))];
        _emptyView.image = ImageNamed(@"wujilu");
        _emptyView.text = @"您暂无此类记录";
    }
    return _emptyView;
}


@end
