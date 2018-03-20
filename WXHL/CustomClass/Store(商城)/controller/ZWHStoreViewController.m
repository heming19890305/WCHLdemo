//
//  ZWHStoreViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHStoreViewController.h"
#import "FDSlideContentView.h"
#import "FDSlideBar.h"
#import "ZWHStoreListViewController.h"

@interface ZWHStoreViewController ()<FDSlideContentViewDataSource,SDCycleScrollViewDelegate>

@property(nonatomic,strong)FDSlideContentView *contentView;
@property(nonatomic,strong)FDSlideBar *sliderBar;

@property(nonatomic,strong)NSMutableArray *dataArray;

//顶部轮播图
@property(nonatomic,strong)SDCycleScrollView *topScrView;

@property(nonatomic,strong)NSMutableArray *titleArray;


@end

@implementation ZWHStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topScrView];
    [self getBannerData];
    [self createRightNavButton];
}

#pragma mark 轮播图信息
-(void)getBannerData{
    MJWeakSelf
    [HttpHandler getSliderImages:@{} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            if ([obj[@"data"] count]>0) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in obj[@"data"]) {
                    [array addObject:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],dict[@"img"]]];
                }
                weakSelf.topScrView.imageURLStringsGroup = array;
            }
        }
    } failed:^(id obj) {
        
    }];
    
    [HttpHandler getGoodsType:@{} Success:^(id obj) {
        if (ReturnValue == 200) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray:obj[@"data"]];
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in weakSelf.dataArray) {
                [array addObject: dict[@"name"]];
            }
            _titleArray = [NSMutableArray arrayWithArray:array];
            [_titleArray insertObject:@"全部" atIndex:0];
            [weakSelf.dataArray insertObject:@"0" atIndex:0];
            [weakSelf setupSlideBar];
            [weakSelf setupScollContentView];
        }else{
            ShowErrorWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowErrorWithStatus(ErrorNet);
    }];
}

-(void)setupSlideBar{
    _sliderBar = [[FDSlideBar alloc]init];
    _sliderBar.frame = CGRectMake(0, HEIGHT_TO(150), SCREENHIGHT, 40);
    _sliderBar.backgroundColor = [UIColor whiteColor];
    _sliderBar.itemWidth = SCREENWIDTH/5+HEIGHT_TO(10);
    _sliderBar.layer.borderColor = LINECOLOR.CGColor;
    _sliderBar.layer.borderWidth = 0.5;
    _sliderBar.itemsTitle = _titleArray;
    _sliderBar.itemColor = [UIColor grayColor];
    _sliderBar.itemSelectedColor = MAINCOLOR;
    _sliderBar.sliderColor = MAINCOLOR;
    [self.view addSubview:_sliderBar];
    MJWeakSelf
    [_sliderBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        [weakSelf.contentView scrollSlideContentViewToIndex:idx];
    }];
}

-(void)setupScollContentView{
    CGFloat Y = CGRectGetMaxY(_sliderBar.frame);
    _contentView = [[FDSlideContentView alloc]init];
    _contentView.dataSource = self;
    _contentView.frame = CGRectMake(0, Y, SCREENWIDTH, SCREENHIGHT - 64 - Y);
    [self.view addSubview:_contentView];
    MJWeakSelf
    [_contentView slideContentViewScrollFinished:^(NSUInteger index) {
        [weakSelf.sliderBar selectSlideBarItemAtIndex:index];
    }];
}

#pragma mark - fd代理

-(NSInteger)numOfContentView{
    return self.dataArray.count;
}

-(UIViewController *)slideContentView:(FDSlideContentView *)contentView viewControllerForIndex:(NSUInteger)index{
    ZWHStoreListViewController *vc = [[ZWHStoreListViewController alloc]init];
    NSLog(@"%@",ZWHINTTOSTR(index));
    vc.state = ZWHINTTOSTR(index);
    if (index > 0) {
        vc.dict = self.dataArray[index];
    }
    [self addChildViewController:vc];
    return vc;
}

#pragma mark - getter

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
        //_topScrView.currentPageDotColor = [ZSColor hexStringToColor:@"595959"];
       // _topScrView.pageDotColor = [ZSColor hexStringToColor:@"cbcbcb"];
        _topScrView.currentPageDotColor = MAINCOLOR;
        _topScrView.pageDotColor = [UIColor whiteColor];
    }
    return _topScrView;
}


@end
