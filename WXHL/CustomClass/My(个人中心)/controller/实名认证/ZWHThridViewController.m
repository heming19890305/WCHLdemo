//
//  ZWHThridViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHThridViewController.h"

@interface ZWHThridViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UIView *footerView;

@property(nonatomic,strong)UIButton *nextB;

@property(nonatomic,strong)UIImageView *icon;


@end

@implementation ZWHThridViewController

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
    self.tableView.tableFooterView = self.footerView;
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

#pragma mark - 下一步
-(void)nextClicked:(UIButton *)sender{
    MJWeakSelf
    [HttpHandler getuploadImage:@{} imageArray:@[_icon.image] imageKeyArray:@[@"img"] success:^(id obj) {
        if (ReturnValue == 200) {
            [weakSelf.imgArray addObject: obj[@"data"][@"filePath"]];
            [weakSelf.dict setValue:[UserManager dealWith:weakSelf.imgArray with:@","] forKey:@"idImgs"];
            [weakSelf.dict setValue:[UserManager token] forKey:@"v_weichao"];
            [HttpHandler getsaveIdCard:weakSelf.dict Success:^(id obj) {
                if (ReturnValue == 200) {
                    ShowSuccessWithStatus(@"提交成功，请耐心等待后台审核!");
                    NOTIFY_POST(@"mycenter");
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    });
                }else{
                    ShowErrorWithStatus(@"认证失败");
                }
            } failed:^(id obj) {
                ShowErrorWithStatus(ErrorNet);
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
        
        
        _nextB = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextB.layer.cornerRadius = 5;
        _nextB.layer.masksToBounds = YES;
        _nextB.enabled = NO;
        [_nextB addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_nextB setBackgroundImage:[UIImage imageWithColor:MAINCOLOR] forState:UIControlStateNormal];
        [_nextB setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [_nextB setTitle:@"提交" forState:0];
        [_nextB setTitle:@"提交" forState:UIControlStateDisabled];
        [_nextB setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_nextB setTitleColor:[UIColor whiteColor] forState:0];
        
        [_footerView addSubview:_nextB];
        _nextB.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(20))
        .rightSpaceToView(_footerView, WIDTH_TO(20))
        .topSpaceToView(lab, HEIGHT_TO(20))
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
        UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"lc_02")];
        [_headerView addSubview:img];
        img.sd_layout
        .leftSpaceToView(_headerView, WIDTH_TO(15))
        .rightSpaceToView(_headerView, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(50))
        .topSpaceToView(_headerView, HEIGHT_TO(6));
        
        _icon = [[UIImageView alloc]initWithImage:ImageNamed(@"sm_tj")];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:_icon];
        _icon.sd_layout
        .widthIs(WIDTH_TO(116))
        .heightIs(HEIGHT_TO(176))
        .topSpaceToView(img, HEIGHT_TO(40))
        .centerXEqualToView(_headerView);
        
        [_icon updateLayout];
        
        UIButton *changeicon = [UIButton buttonWithType:UIButtonTypeCustom];
        changeicon.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:changeicon];
        changeicon.sd_layout
        .leftEqualToView(_icon)
        .topEqualToView(_icon)
        .rightEqualToView(_icon)
        .bottomEqualToView(_icon);
        [changeicon addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = LINECOLOR;
        [_footerView addSubview:view];
        view.sd_layout
        .leftEqualToView(_footerView)
        .rightEqualToView(_footerView)
        .bottomEqualToView(_footerView)
        .heightIs(1);
        
        CGFloat headerY = CGRectGetMaxY(_icon.frame);
        _headerView.frame = CGRectMake(0, 0, SCREENWIDTH, headerY+HEIGHT_TO(30));
    }
    return _headerView;
}

#pragma mark - 更改头像
-(void)changeIcon{
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"选择类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *pz = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseImageWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *xc = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [aler addAction:pz];
    [aler addAction:xc];
    [aler addAction:cancel];
    [self presentViewController:aler animated:YES completion:nil];
}

#pragma mark -调用相机，选择图片
-(void)chooseImageWithType:(UIImagePickerControllerSourceType)type{
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = type;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    _icon.image = image;
    _nextB.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end
