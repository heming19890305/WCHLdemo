//
//  ZWHSetIdCardViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSetIdCardViewController.h"
#import "KJChooseImagesView.h"
#import "ZWHSecondIdViewController.h"

#define NORCELL @"uitableviewcell"

@interface ZWHSetIdCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UIView *footerView;

@property(nonatomic,strong)UIButton *nextB;

@property(nonatomic,strong)KJChooseImagesView * chooseZImageView;//正
@property(nonatomic,strong)KJChooseImagesView * chooseFImageView;//反

@end

@implementation ZWHSetIdCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
}

-(void)creatView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"拍照指南" style:UIBarButtonItemStylePlain target:self action:@selector(editClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NORCELL];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
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

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NORCELL forIndexPath:indexPath];
    return cell;
}


#pragma mark - 拍照指南
-(void)editClicked:(UIBarButtonItem *)sender{
    MJWeakSelf
    [HttpHandler getArticleInfo:@{@"code":@"pzzn"} Success:^(id obj) {
        if (ReturnValue == 200) {
            BasicWebViewController *vc = [[BasicWebViewController alloc]init];
            vc.htmlStr = obj[@"data"][@"content"];
            vc.title = @"拍照指南";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
}


#pragma mark - 遵守协议
-(void)agressDelegate:(UIButton *)sender{
    sender.selected = !sender.selected;
    _nextB.enabled = !_nextB.enabled;
}

#pragma mark - 下一步
-(void)nextClicked:(UIButton *)sender{
    NSLog(@"下一步");
    
    if (_chooseZImageView.imagesArry.count == 0 || _chooseFImageView.imagesArry.count == 0  ) {
        ShowInfoWithStatus(@"请上传身份证正反面照片")
        return;
    }
    ShowProgress
    NotAllowUser
    MJWeakSelf
    NSMutableArray *imgArray = [NSMutableArray array];
    [HttpHandler getuploadImage:@{} imageArray:@[[_chooseZImageView.imagesArry lastObject]] imageKeyArray:@[@"img"] success:^(id obj) {
        if (ReturnValue == 200) {
            [imgArray addObject:obj[@"data"][@"filePath"]];
            [HttpHandler getuploadImage:@{} imageArray:@[[weakSelf.chooseFImageView.imagesArry lastObject]] imageKeyArray:@[@"img"] success:^(id obj) {
                if (ReturnValue == 200) {
                    Dismiss
                    [imgArray addObject:obj[@"data"][@"filePath"]];
                    ZWHSecondIdViewController *se = [[ZWHSecondIdViewController alloc]init];
                    se.imgArray = imgArray;
                    se.title = @"实名认证";
                    [weakSelf.navigationController pushViewController:se animated:YES];
                }else{
                    ShowInfoWithStatus(@"上传照片失败");
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
            }];
        }else{
            ShowInfoWithStatus(@"上传照片失败");
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
}


#pragma mark - getter
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        UILabel *lab = [[UILabel alloc]init];
        [lab textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        lab.text = @"请上传本人身份证信息，一经提交不可修改";
        [_footerView addSubview:lab];
        lab.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(15))
        .rightSpaceToView(_footerView, WIDTH_TO(15))
        .autoHeightRatio(0)
        .topSpaceToView(_footerView, HEIGHT_TO(20));
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:ImageNamed(@"a") forState:0];
        [btn setImage:ImageNamed(@"对号(1)") forState:UIControlStateSelected];
        [_footerView addSubview:btn];
        [btn addTarget:self action:@selector(agressDelegate:) forControlEvents:UIControlEventTouchUpInside];
        btn.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(20))
        .widthEqualToHeight()
        .topSpaceToView(lab, HEIGHT_TO(15));
        
        //需要点击的字符不同
        NSString *label_text2 = @"阅读并同意《认证服务协议》";
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
        [attributedString2 addAttribute:NSFontAttributeName value:FontWithSize(14) range:NSMakeRange(0, label_text2.length)];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 5)];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:MAINCOLOR range:NSMakeRange(5, label_text2.length - 5)];
        
        UILabel *ybLabel2 = [[UILabel alloc] init];
        ybLabel2.backgroundColor = [UIColor clearColor];
        ybLabel2.attributedText = attributedString2;
        [_footerView addSubview:ybLabel2];
        ybLabel2.sd_layout
        .centerYEqualToView(btn)
        .widthIs(WIDTH_TO(250))
        .autoHeightRatio(0)
        .leftSpaceToView(btn, WIDTH_TO(6));
        
        ybLabel2.textAlignment = NSTextAlignmentLeft;
        MJWeakSelf
        [ybLabel2 yb_addAttributeTapActionWithStrings:@[@"《认证服务协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            [HttpHandler getArticleInfo:@{@"code":@"smrzfwxy"} Success:^(id obj) {
                if (ReturnValue == 200) {
                    BasicWebViewController *vc = [[BasicWebViewController alloc]init];
                    vc.htmlStr = obj[@"data"][@"content"];
                    vc.title = @"认证服务协议";
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    ShowInfoWithStatus(ErrorMessage);
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
            }];
        }];
        ybLabel2.enabledTapEffect = NO;
        
        
        _nextB = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextB.layer.cornerRadius = 5;
        _nextB.layer.masksToBounds = YES;
        _nextB.enabled = NO;
        [_nextB addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_nextB setBackgroundImage:[UIImage imageWithColor:MAINCOLOR] forState:UIControlStateNormal];
        [_nextB setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [_nextB setTitle:@"下一步" forState:0];
        [_nextB setTitle:@"下一步" forState:UIControlStateDisabled];
        [_nextB setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_nextB setTitleColor:[UIColor whiteColor] forState:0];
        
        [_footerView addSubview:_nextB];
        _nextB.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(20))
        .rightSpaceToView(_footerView, WIDTH_TO(20))
        .topSpaceToView(btn, HEIGHT_TO(30))
        .heightIs(HEIGHT_TO(50));
        
        [_nextB updateLayout];
        
        CGFloat footY = CGRectGetMaxY(_nextB.frame);
        
        _footerView.frame = CGRectMake(0, 0, SCREENWIDTH,footY + HEIGHT_TO(20));
    }
    return _footerView;
}


-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(500))];
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"lc_01")];
        [_headerView addSubview:img];
        img.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(50))
        .topSpaceToView(_headerView, HEIGHT_TO(6));
        
        [_headerView addSubview:self.chooseZImageView];
        self.chooseZImageView.sd_layout
        .topSpaceToView(img, HEIGHT_TO(15))
        .heightIs(HEIGHT_TO(125))
        .widthIs(WIDTH_TO(181))
        .centerXEqualToView(_headerView);
        
        UILabel *labz = [[UILabel alloc]init];
        [labz textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        labz.text = @"身份证正面照片";
        [_headerView addSubview:labz];
        labz.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .autoHeightRatio(0)
        .topSpaceToView(self.chooseZImageView, HEIGHT_TO(20));
        
        [_headerView addSubview:self.chooseFImageView];
        self.chooseFImageView.sd_layout
        .topSpaceToView(labz, HEIGHT_TO(20))
        .heightIs(HEIGHT_TO(125))
        .widthIs(WIDTH_TO(181))
        .centerXEqualToView(_headerView);
        
        UILabel *labf = [[UILabel alloc]init];
        [labf textFont:14 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        labf.text = @"身份证反面照片";
        [_headerView addSubview:labf];
        labf.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .autoHeightRatio(0)
        .topSpaceToView(self.chooseFImageView, HEIGHT_TO(20));
        [labf updateLayout];
        
        CGFloat headerY = CGRectGetMaxY(labf.frame);
        _headerView.frame = CGRectMake(0, 0, SCREENWIDTH, headerY + 30);
    }
    return _headerView;
}

-(KJChooseImagesView *)chooseZImageView{
    if(!_chooseZImageView){
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"KJChooseImagesView" owner:self options:nil];
        //得到第一个UIView
        _chooseZImageView = [nib objectAtIndex:0];
        _chooseZImageView.numberOfLine = 2;//每行6张
        _chooseZImageView.maxImagesNumber = 1;//最大3张
        _chooseZImageView.titleStr = @"";
        [_chooseZImageView viewheightIsChanged:^(CGFloat height) {
            
        } addimage:@"sm_zm"];
    }
    return _chooseZImageView;
}
-(KJChooseImagesView *)chooseFImageView{
    if(!_chooseFImageView){
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"KJChooseImagesView" owner:self options:nil];
        //得到第一个UIView
        _chooseFImageView = [nib objectAtIndex:0];
        _chooseFImageView.numberOfLine = 2;//每行张
        _chooseFImageView.maxImagesNumber = 1;//最大张
        _chooseFImageView.titleStr = @"";
        [_chooseFImageView viewheightIsChanged:^(CGFloat height) {
            
        } addimage:@"smfm"];
    }
    return _chooseFImageView;
}

@end
