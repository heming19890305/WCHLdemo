//
//  scoreViewController.m
//  WXHL
//
//  Created by tomorrow on 2018/3/9.
//  Copyright © 2018年 Syrena. All rights reserved.
//

#import "scoreViewController.h"
#import "ZWHMyheaderView.h"
#import "HMScoreView.h"

@interface scoreViewController ()
@property(nonatomic, strong) UIView * TopView;
@property(nonatomic, assign) float amount;

@end

@implementation scoreViewController

- (void)viewWillAppear:(BOOL)animated
{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"工分";
    
    // Do any additional setup after loading the view.
    //获取数据
    [self setupData];
    //添加头部View
//    [self setupAddTopView];
    [self setupview];
    //添加中间view
//    [self setupMidView];
   
}
- (void)setupview{
    MJWeakSelf
    [HttpHandler getMyWorkpoints:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"++========%@",obj);
            ZWHMyWorkModel *model = [ZWHMyWorkModel mj_objectWithKeyValues:obj[@"data"]];
            weakSelf.headerView.dataModel = model;
              NSLog(@"******&&&&######= %@", model.scoreNumber);
            //            [weakSelf endrefresh];
        }else{
            ShowInfoWithStatus(ErrorMessage);
//            [weakSelf endrefresh];
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
//        [weakSelf endrefresh];
    }];
    
    [self.view addSubview:self.headerView];
     NSLog(@"++___________ = %@", _dataModel.userBalance);
}
- (HMScoreView *)headerView
{
    if (!_headerView) {
        _headerView = [[HMScoreView alloc] initWithFrame:self.view.bounds];
    }
    return _headerView;
}



//获取数据
- (void)setupData
{
  
   
    [HttpHandler getOrderStatusNum:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"工分%@",obj);
            [HttpHandler getMyWorkpoints:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
                if (ReturnValue == 200) {
//                    NSLog(@"++=工分====%@",obj);
                    ZWHMyWorkModel *model = [ZWHMyWorkModel mj_objectWithKeyValues:obj[@"data"]];
                    _dataModel = model;
                  _gotScore = model.userBalance;
//                    NSLog(@"++++++gotScore = %@", _dataModel.userBalance);
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
        ShowInfoWithStatus(ErrorNet)
        
    }];
}

@end
