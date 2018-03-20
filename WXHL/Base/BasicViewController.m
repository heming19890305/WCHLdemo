//
//  BasicViewController.m
//  千帆渡留学
//
//  Created by qfd on 15/11/17.
//  Copyright © 2015年  All rights reserved.
//

#import "BasicViewController.h"
#import "ZWHRightView.h"
#import "ZWHLoginViewController.h"
#import "ZWHJudgeViewController.h"
#import "ZWHLogisticsViewController.h"
#import "ZWHMessageViewController.h"
#import "ZWHFeedViewController.h"

@interface BasicViewController ()
@property (nonatomic,strong)UIView * titleView;//顶部显示的视图

@property(nonatomic,strong)ZWHRightView *rigview;

@property(nonatomic,strong)UIButton *backgroundBtn;
@end

@implementation BasicViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.tintColor  = [UIColor grayColor];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor  = [UIColor grayColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
    [self createLeftNavButton];
}




#pragma mark - 创建导航栏返回按键
- (void) createLeftNavButton
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 28, 28);
    [_backBtn setImage:[UIImage imageNamed:@"left_fanhui"] forState:UIControlStateNormal];
    _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}




- (void)backClick:(UIButton *)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showMore{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    
    _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundBtn.backgroundColor = [UIColor clearColor];
    [_backgroundBtn addTarget:self action:@selector(dismisChooseView) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_backgroundBtn];
    _backgroundBtn.sd_layout
    .topEqualToView(window)
    .leftEqualToView(window)
    .rightEqualToView(window)
    .bottomEqualToView(window);
    
    _rigview = [[ZWHRightView alloc]init];
    MJWeakSelf
    _rigview.didinput = ^(NSInteger idx) {
        [weakSelf dismisChooseView];
        if (idx == 0) {
            if ([[UserManager token] length] == 0) {
                [weakSelf getLogin];
                return ;
            }
            ZWHMessageViewController *vc = [[ZWHMessageViewController alloc]init];
            vc.title = @"消息中心";
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (idx >0 && idx < 5){
            NSArray *arr = @[@"gywm",@"hzlx",@"sm",@"syzn"];
            NSArray *namearr = @[@"关于我们",@"合作联系",@"声明",@"使用指南"];
            [HttpHandler getArticleInfo:@{@"code":arr[idx - 1]} Success:^(id obj) {
                if (ReturnValue == 200) {
                    BasicWebViewController *vc = [[BasicWebViewController alloc]init];
                    vc.htmlStr = obj[@"data"][@"content"];
                    vc.title = namearr[idx - 1];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    ShowInfoWithStatus(ErrorMessage);
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
            }];
        }else if(idx == 5){
            ZWHFeedViewController *vc = [[ZWHFeedViewController alloc]init];
            vc.title = @"反馈";
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else{
            ZWHLogisticsViewController *vc = [[ZWHLogisticsViewController alloc]init];
            vc.title = @"物流";
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    [window addSubview:_rigview];
    [_rigview showView];
}

-(void)dismisChooseView{
    
    [_backgroundBtn removeFromSuperview];
    [_rigview removeFromSuperview];
}

-(void)createRightNavButton{
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"menu")  style:UIBarButtonItemStylePlain target:self action:@selector(showMore)];
    self.navigationItem.rightBarButtonItem = more;
}

-(void)getLogin{
    ZWHLoginViewController *vc = [[ZWHLoginViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
