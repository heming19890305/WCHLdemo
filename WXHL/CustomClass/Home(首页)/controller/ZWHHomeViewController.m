//
//  ZWHHomeViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/6.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHHomeViewController.h"
#import "ZSHomeTopView.h"
#import "FirstClassifyView.h"
#import "ZWHHomeMidView.h"
#import "ZSHomeScrollBannerView.h"
#import "ZWHHomeCollectionViewCell.h"
#import "ZWHBuinessViewController.h"
#import "ZWHRechargeViewController.h"
#import "ZWHJoinBuiViewController.h"
#import "ZWHDrinkViewController.h"
#import "ZWHWalletViewController.h"
#import "ZWHSpecialViewController.h"
#import "ZWHCashViewController.h"
#import "ZWHNewsViewController.h"
#import "ZWHStoreViewController.h"
#import "ZWHGoodDetailViewController.h"
#import "ZWHNotiModel.h"
#import "ZWHGoodsModel.h"
#import "ZWHWalletModel.h"
#import "JQScanViewController.h"
#import "ZWHC2fGoodViewController.h"
#import "ZWHSearchWordViewController.h"




#define HomeCollect @"ZWHHomeCollectionViewCell"

@interface ZWHHomeViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

@property(nonatomic,strong)ZSHomeTopView *topview;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)ZWHHomeMidView *classifyView;
//顶部轮播图
@property(nonatomic,strong)SDCycleScrollView *topScrView;

//中部轮播图
@property(nonatomic,strong)SDCycleScrollView *midScrViewUp;
//中部轮播图
@property(nonatomic,strong)SDCycleScrollView *midScrViewDown;

//头部视图
@property(nonatomic,strong)UIView *headerView;

//通知数据
@property(nonatomic,strong)NSMutableArray *upArray;
@property(nonatomic,strong)NSMutableArray *dowmArray;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ZWHHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // self.navigationController.navigationBarHidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
    [self setrefresh];
    [self getSystemConfig];
    [self getHomeData];
    /*if ([[UserManager token] length]>0) {
        NSString *account = [UserManager zhanghao];
        NSString *pas = [UserManager password];
        [HttpHandler getlogin:@{@"username":account,@"password":pas} Success:^(id obj) {
            if (ReturnValue == 200) {
                //Dismiss
                NSLog(@"%@",obj);
                //[UserManager sharedData].token = obj[@"data"];
                NSString *token = obj[@"data"];
                NSLog(@"%@",[UserManager token]);
                [HttpHandler getCurrentUser:@{@"v_weichao":token} Success:^(id obj) {
                    if (ReturnValue == 200) {
                        NSLog(@"%@",obj);
                        Dismiss
                        [UserManager sharedData].password = pas;
                        [UserManager sharedData].zhanghao = account;
                        [UserManager sharedData].token = token;
                        [UserManager sharedData].mymodel = [ZWHMyModel mj_objectWithKeyValues:obj[@"data"]];
                        [UserManager sharedData].userDict = obj[@"data"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        ShowInfoWithStatus(ErrorMessage);
                    }
                } failed:^(id obj) {
                    ShowInfoWithStatus(ErrorNet);
                }];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }*/
}

#pragma mark - 获取系统参数
-(void)getSystemConfig{
    [HttpHandler getSysConfig:@{@"key":@"file_server"} Success:^(id obj) {
        NSLog(@"%@",obj)
        if (ReturnValue == 200) {
            [UserManager sharedData].fileSer = obj[@"data"][@"file_server"];
            NSLog(@"%@",[UserManager fileSer]);
        }
    } failed:^(id obj) {
        
    }];
}

#pragma mark - 首页数据
-(void)getHomeData{
    MJWeakSelf
    [HttpHandler getHome:@{@"client":@2} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            //广告
            if ([obj[@"data"][@"banner"] count] > 0) {
                NSMutableArray *arrayM = [NSMutableArray array];
                for (NSDictionary *dict in obj[@"data"][@"banner"]) {
                    [arrayM addObject:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],dict[@"img"]]];
                }
                weakSelf.topScrView.imageURLStringsGroup = arrayM;
            }
            //通知
            if ([obj[@"data"][@"notice"] count] > 0) {
                NSArray *array = [ZWHNotiModel mj_objectArrayWithKeyValuesArray:obj[@"data"][@"notice"]];
                weakSelf.upArray = [NSMutableArray array];
                weakSelf.dowmArray = [NSMutableArray array];
                NSInteger i = 0;
                while (i<array.count) {
                    [weakSelf.upArray addObject:array[i]];
                    if (i+1 < array.count) {
                        [weakSelf.dowmArray addObject:array[i+1]];
                    }
                    i=i+2;
                }
                [weakSelf setNoticeDatasource];
            }
            //特惠
            if ([obj[@"data"][@"goods"] count] > 0) {
                weakSelf.dataArray = [ZWHGoodsModel mj_objectArrayWithKeyValuesArray:obj[@"data"][@"goods"]];
                [weakSelf.collectionView reloadData];
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
        [weakSelf getHomeData];
        [weakSelf getSystemConfig];
    }];
}

-(void)endrefresh{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - 加载通知
-(void)setNoticeDatasource{
    NSMutableArray *up = [NSMutableArray array];
    NSMutableArray *down = [NSMutableArray array];
    if (_upArray.count > 0) {
        for (ZWHNotiModel *mo in _upArray) {
            //[up addObject:[NSString stringWithFormat:@"●%@",mo.title]];
            [up addObject:mo.title];
        }
    }
    if (_dowmArray.count > 0) {
        for (ZWHNotiModel *mo in _dowmArray) {
            //[down addObject:[NSString stringWithFormat:@"●%@",mo.title]];
            [down addObject:mo.title];
        }
    }
    self.midScrViewUp.titlesGroup = down;
    _midScrViewUp.mainView.scrollEnabled = NO;
    self.midScrViewDown.titlesGroup = up;
    _midScrViewDown.mainView.scrollEnabled = NO;
}

#pragma mark - 搜索
-(void)search{
    ZWHSearchWordViewController *vc = [[ZWHSearchWordViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"搜索";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 加载图片
-(void)creatView{
    [self.view addSubview:self.topview];
    [self.topview.searchB addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[ZWHHomeCollectionViewCell class] forCellWithReuseIdentifier:HomeCollect];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
    MJWeakSelf
    self.classifyView.didClicked = ^(NSInteger idx) {
        NSLog(@"%ld",idx);
        switch (idx) {
            case 10:
            {
                ZWHStoreViewController *vc = [[ZWHStoreViewController alloc]init];
                vc.title = @"商城";
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 11:
            {
                if ([[UserManager token] length] == 0) {
                    [weakSelf getLogin];
                    return ;
                }
                [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
                    if (ReturnValue == 200) {
                        NSLog(@"%@",obj);
                        ZWHWalletViewController *vc = [[ZWHWalletViewController alloc]init];
                        ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
                        vc.model = model;
                        vc.title = @"余额";
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        ShowInfoWithStatus(ErrorMessage);
                    }
                } failed:^(id obj) {
                    ShowInfoWithStatus(ErrorNet);
                }];
            }
                break;
            case 12:
            {
                [HttpHandler getC2fInfo:@{@"type":@"1"} Success:^(id obj) {
                    if (ReturnValue == 200) {
                        NSLog(@"%@",obj);
                        ZWHGoodsModel *mo = [ZWHGoodsModel mj_objectWithKeyValues:obj[@"data"]];
                        NSLog(@"%@",mo);
                        ZWHC2fGoodViewController *vc = [[ZWHC2fGoodViewController alloc]init];
                        vc.state = @"1";
                        vc.model = mo;
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        ShowInfoWithStatus(ErrorMessage);
                    }
                } failed:^(id obj) {
                    ShowInfoWithStatus(ErrorNet);
                }];
            }
                break;
            case 13:
                {
                    if ([UserManager token].length == 0) {
                        [weakSelf getLogin];
                        return;
                    }
                    if ([[UserManager areaNo] length] == 0) {
                        ZWHJoinBuiViewController *vc = [[ZWHJoinBuiViewController alloc]init];
                        vc.title = @"加入商脉圈";
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        ZWHBuinessViewController *vc = [[ZWHBuinessViewController alloc]init];
                        vc.title = @"商脉圈";
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
                break;
            case 14:
            {
                [HttpHandler getC2fInfo:@{@"type":@"3"} Success:^(id obj) {
                    if (ReturnValue == 200) {
                        NSLog(@"%@",obj);
                        ZWHGoodsModel *mo = [ZWHGoodsModel mj_objectWithKeyValues:obj[@"data"]];
                        NSLog(@"%@",mo);
                        ZWHC2fGoodViewController *vc = [[ZWHC2fGoodViewController alloc]init];
                        vc.state = @"3";
                        vc.model = mo;
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        ShowInfoWithStatus(ErrorMessage);
                    }
                } failed:^(id obj) {
                    ShowInfoWithStatus(ErrorNet);
                }];
            }
                break;
            case 15:
            {
                if ([[UserManager token]length] ==0) {
                    [self getLogin];
                    return;
                }
                [HttpHandler getWalletInfo:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
                    if (ReturnValue == 200) {
                        NSLog(@"%@",obj);
                        ZWHWalletModel *model = [ZWHWalletModel mj_objectWithKeyValues:obj[@"data"]];
                        ZWHRechargeViewController *vc = [[ZWHRechargeViewController alloc]init];
                        vc.model = model;
                        vc.title = @"充值";
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        ShowInfoWithStatus(ErrorMessage);
                    }
                } failed:^(id obj) {
                    ShowInfoWithStatus(ErrorNet);
                }];
                
            }
                break;
            case 16:
            {
                if ([[UserManager token]length] == 0) {
                    [weakSelf getLogin];
                    return;
                }
                [HttpHandler getBindBankCard:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
                    if (ReturnValue == 200) {
                        NSLog(@"%@",obj);
                        if (obj[@"data"]) {
                            [UserManager sharedData].bankname = obj[@"data"][@"bank"];
                            [UserManager sharedData].cardNo = obj[@"data"][@"cardNo"];
                            ZWHCashViewController *vc = [[ZWHCashViewController alloc]init];
                            vc.title = @"提现";
                            vc.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }else{
                            ShowInfoWithStatus(@"还未绑定银行卡");
                        }
                    }else{
                        ShowErrorWithStatus(ErrorMessage);
                    }
                } failed:^(id obj) {
                    ShowErrorWithStatus(ErrorNet);
                }];
            }
                break;
            case 17:
            {
                
                [HttpHandler getC2fInfo:@{@"type":@"2"} Success:^(id obj) {
                    if (ReturnValue == 200) {
                        NSLog(@"%@",obj);
                        ZWHGoodsModel *mo = [ZWHGoodsModel mj_objectWithKeyValues:obj[@"data"]];
                        NSLog(@"%@",mo);
                        ZWHC2fGoodViewController *vc = [[ZWHC2fGoodViewController alloc]init];
                        vc.state = @"2";
                        vc.model = mo;
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        ShowInfoWithStatus(ErrorMessage);
                    }
                } failed:^(id obj) {
                    ShowInfoWithStatus(ErrorNet);
                }];
            }
                break;

            default:
                break;
        }
    };
    
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
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZWHHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollect forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.item];
    cell.layer.borderColor = LINECOLOR.CGColor;
    cell.layer.borderWidth = 0.5;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MJWeakSelf
    ZWHGoodsModel *model = _dataArray[indexPath.item];
    NSLog(@"%@",model.id);
    NSString *str = [NSString stringWithString:model.id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([UserManager token].length>0) {
        [dict setValue:[UserManager token] forKey:@"v_weichao"];
    }
    [dict setValue:str forKey:@"goodsId"];
    [HttpHandler getGoodInfo:dict Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            ZWHGoodsModel *mo = [ZWHGoodsModel mj_objectWithKeyValues:obj[@"data"]];
            NSLog(@"%@",mo);
            ZWHGoodDetailViewController *vc = [[ZWHGoodDetailViewController alloc]init];
            vc.state = @"0";
            vc.model = mo;
            vc.goodId = model.id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}


#pragma mark - 扫码
-(void)scanPressed:(UIButton *)sender{
    JQScanViewController *vc = [JQScanViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - getter
-(ZSHomeTopView *)topview{
    if (!_topview) {
        _topview = [[ZSHomeTopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        [_topview.moreB addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
        [_topview.cityBtn addTarget:self action:@selector(scanPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topview;
}

-(SDCycleScrollView *)topScrView{
    if (!_topScrView) {
        NSArray *array = @[[UIImage imageWithColor:[UIColor whiteColor]]];
        _topScrView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(150)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _topScrView.delegate = self;
        _topScrView.localizationImageNamesGroup = array;
        _topScrView.backgroundColor = [UIColor whiteColor];
        _topScrView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _topScrView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _topScrView.pageControlBottomOffset = 5;
        _topScrView.pageControlDotSize = CGSizeMake(WIDTH_PRO(7.5), HEIGHT_PRO(7));
        _topScrView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _topScrView.currentPageDotColor = MAINCOLOR;
        _topScrView.pageDotColor = [UIColor whiteColor];
    }
    return _topScrView;
}

-(SDCycleScrollView *)midScrViewUp{
    if (!_midScrViewUp) {
        NSArray *array = @[];
        _midScrViewUp = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(30)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _midScrViewUp.delegate = self;
        _midScrViewUp.localizationImageNamesGroup = array;
        _midScrViewUp.onlyDisplayText = YES;
        _midScrViewUp.titlesGroup = array;
        _midScrViewUp.backgroundColor = [UIColor whiteColor];
        _midScrViewUp.titleLabelBackgroundColor = [UIColor whiteColor];
        _midScrViewUp.titleLabelTextColor = ZWHCOLOR(@"646363");
        _midScrViewUp.titleLabelTextFont = FontWithSize(14);
        _midScrViewUp.showPageControl = YES;
        _midScrViewUp.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _midScrViewUp.scrollDirection = UICollectionViewScrollDirectionVertical;
        _midScrViewUp.autoScrollTimeInterval = 4;
    }
    return _midScrViewUp;
}

-(SDCycleScrollView *)midScrViewDown{
    if (!_midScrViewDown) {
        NSArray *array = @[];
        _midScrViewDown = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(30)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _midScrViewDown.delegate = self;
        _midScrViewDown.localizationImageNamesGroup = array;
        _midScrViewDown.onlyDisplayText = YES;
        _midScrViewDown.titlesGroup = array;
        _midScrViewDown.backgroundColor = [UIColor whiteColor];
        _midScrViewDown.titleLabelBackgroundColor = [UIColor whiteColor];
        _midScrViewDown.titleLabelTextColor = ZWHCOLOR(@"646363");
        _midScrViewDown.titleLabelTextFont = FontWithSize(14);
        _midScrViewDown.showPageControl = YES;
        _midScrViewDown.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _midScrViewDown.scrollDirection = UICollectionViewScrollDirectionVertical;
        _midScrViewDown.autoScrollTimeInterval = 4;
    }
    return _midScrViewDown;
}

-(UIView *)headerView{
    if (!_headerView) {
        CGFloat wid = (SCREENWIDTH)/4;
        CGFloat hig = wid*0.7;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, hig*2+HEIGHT_TO(30 + 150 + 80 + 50))];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:self.topScrView];
        [_headerView addSubview:self.classifyView];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.classifyView.frame), SCREENWIDTH, HEIGHT_TO(70))];
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"nes")];
        [view addSubview:img];
        img.sd_layout
        .topSpaceToView(view, HEIGHT_TO(10))
        .leftSpaceToView(view, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(50))
        .widthIs(WIDTH_TO(50));
        
        
        
        
        [view addSubview:self.midScrViewUp];
        _midScrViewUp.sd_layout
        .leftSpaceToView(img, WIDTH_TO(5))
        .rightSpaceToView(view, WIDTH_TO(15))
        .topSpaceToView(view, HEIGHT_TO(10))
        .heightIs(HEIGHT_TO(25));
        
        [view addSubview:self.midScrViewDown];
        _midScrViewDown.sd_layout
        .leftSpaceToView(img, WIDTH_TO(5))
        .rightSpaceToView(view, WIDTH_TO(15))
        .topSpaceToView(_midScrViewUp, 0)
        .heightIs(HEIGHT_TO(25));
        
        for (NSInteger i = 0; i<2; i++) {
            UIImageView *rect = [[UIImageView alloc]initWithImage:ImageNamed(@"Rectangle 2 Copy")];
            [view addSubview:rect];
            rect.sd_layout
            .leftSpaceToView(img, 5)
            .heightIs(7)
            .widthEqualToHeight()
            .centerYEqualToView(i==0?_midScrViewUp:_midScrViewDown);
        }
        
        [_headerView addSubview:view];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LINECOLOR;
        [_headerView addSubview:line];
        line.sd_layout
        .topSpaceToView(view, 0)
        .heightIs(10)
        .leftEqualToView(_headerView)
        .rightEqualToView(_headerView);
        
        UIImageView *imga = [[UIImageView alloc]initWithImage:ImageNamed(@"jingxuan")];
        imga.backgroundColor = ZWHCOLOR(@"f6faff");
        imga.contentMode = UIViewContentModeCenter;
        [_headerView addSubview:imga];
        imga.sd_layout
        .leftEqualToView(_headerView)
        .rightEqualToView(_headerView)
        .heightIs(HEIGHT_TO(50))
        .bottomEqualToView(_headerView);
    }
    return _headerView;
}

#pragma mark - 头条跳转
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (cycleScrollView == _midScrViewUp) {
        NSLog(@"上%ld",index);
        ZWHNotiModel *mo = _upArray[index];
        MJWeakSelf
        [HttpHandler getNotic:@{@"id":mo.id} Success:^(id obj) {
            if (ReturnValue == 200) {
                ZWHNewsViewController *vc = [[ZWHNewsViewController alloc]init];
                vc.htmlStr = obj[@"data"];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
        
    }
    if (cycleScrollView == _midScrViewDown){
        NSLog(@"下%ld",index);
        ZWHNotiModel *mo = _dowmArray[index];
        MJWeakSelf
        [HttpHandler getNotic:@{@"id":mo.id} Success:^(id obj) {
            if (ReturnValue == 200) {
                ZWHNewsViewController *vc = [[ZWHNewsViewController alloc]init];
                vc.htmlStr = obj[@"data"];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        // 初始化一个布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset =UIEdgeInsetsMake(0,0,0, 0);
        flowLayout.headerReferenceSize =CGSizeMake(SCREENWIDTH,CGRectGetMaxY(self.headerView.frame));//头视图大小
        // 设置最小行距
        flowLayout.minimumLineSpacing = HEIGHT_PRO(0);
        // 设置最小间距
        flowLayout.minimumInteritemSpacing = WIDTH_PRO(0);
        // 设置格子大小
        flowLayout.itemSize = CGSizeMake((SCREENWIDTH )/2, HEIGHT_TO(215));
        // 设置组边界
        flowLayout.sectionInset = UIEdgeInsetsMake(HEIGHT_PRO(0), WIDTH_PRO(0), 0, WIDTH_PRO(0));
        // 设置头部和底部视图高度
        // flowLayout.headerReferenceSize = CGSizeMake(0, 100);
        //flowLayout.footerReferenceSize = CGSizeMake(0, 100);
        //        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 初始化集合视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHIGHT-64) collectionViewLayout:flowLayout];
        // 设置背景色
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 设置代理和数据源
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

-(ZWHHomeMidView *)classifyView{
    if (!_classifyView) {
        CGFloat wid = (SCREENWIDTH)/4;
        CGFloat hig = wid*0.7;
        _classifyView = [[ZWHHomeMidView alloc] initWithFrame:CGRectMake(0, HEIGHT_TO(150), SCREENWIDTH, hig*2+HEIGHT_TO(30))];
        _classifyView.dataArray = @[@"商城",@"钱包",@"封坛酒",@"商脉圈",@"个性定制",@"充值",@"提现",@"微超货柜"];
    }
    return _classifyView;
}
@end
