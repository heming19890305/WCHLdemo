//
//  ZWHC2FViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHC2FViewController.h"

#import "ZWHDrinkHeaderView.h"
#import "ZWHDrinkViewController.h"

#import "ZWHC2FCollectionViewCell.h"

#define C2FCELL @"ZWHC2FCollectionViewCell"

@interface ZWHC2FViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)ZWHDrinkHeaderView *headerView;

@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation ZWHC2FViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = @[@"封坛酒",@"智能微超",@"个性定制"];
    [self createRightNavButton];
    [self creatView];
    [self getuserData];
}

#pragma mark - 个人数据（后备）
-(void)getuserData{
    [HttpHandler getCurrentUser:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            [UserManager sharedData].mymodel = [ZWHMyModel mj_objectWithKeyValues:obj[@"data"]];
            [UserManager sharedData].userDict = obj[@"data"];
            self.headerView.model = [ZWHMyModel mj_objectWithKeyValues:obj[@"data"]];

            
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

-(void)creatView{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[ZWHC2FCollectionViewCell class] forCellWithReuseIdentifier:C2FCELL];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];

    
}


#pragma mark - collection
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [header addSubview:self.headerView];
    return header;
}

// 返回多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每组返回多少个格子
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZWHC2FCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:C2FCELL forIndexPath:indexPath];
    cell.title.text = _dataArray[indexPath.item];
    NSString *imgurl = [NSString stringWithFormat:@"%@_1",_dataArray[indexPath.item]];
    cell.img.image = ImageNamed(imgurl);
    cell.layer.borderColor = LINECOLOR.CGColor;
    cell.layer.borderWidth = 0.5;
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZWHDrinkViewController *vc = [[ZWHDrinkViewController alloc]init];
    vc.state = ZWHINTTOSTR(indexPath.item+1);
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
-(ZWHDrinkHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZWHDrinkHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(100))];
    }
    return _headerView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        // 初始化一个布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset =UIEdgeInsetsMake(0,0,0, 0);
        flowLayout.headerReferenceSize =CGSizeMake(SCREENWIDTH,HEIGHT_TO(110));//头视图大小
        // 设置最小行距
        flowLayout.minimumLineSpacing = HEIGHT_PRO(0);
        // 设置最小间距
        flowLayout.minimumInteritemSpacing = WIDTH_PRO(0);
        // 设置格子大小
        flowLayout.itemSize = CGSizeMake(SCREENWIDTH/2, HEIGHT_TO(180));
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
       // _collectionView.backgroundColor = LINECOLOR;
    }
    return _collectionView;
}



@end
