//
//  ZWHMyInfoViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHMyInfoViewController.h"
#import "ZWHSetNameViewController.h"
#import "ZWHQRViewController.h"
#import "ZWHSetPhoneViewController.h"
#import "ZWHSetAlipayViewController.h"
#import "ZWHSetBankViewController.h"

#import "ZWHLeRiTableViewCell.h"
#import "ZWHLeImgTableViewCell.h"

#define LRIMGCELL @"ZWHLeImgTableViewCell"
#define LRCELL @"ZWHLeRiTableViewCell"

@interface ZWHMyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *footView;

@property(nonatomic,strong)NSString *sex;

@end

@implementation ZWHMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NOTIFY_ADD(getData, @"myinfodata");
    [self creatView];
    [self setrefresh];
}

-(void)dealloc{
    NOTIFY_REMOVE(@"myinfodata");
}

#pragma mark - 数据 刷新
-(void)setrefresh{
    MJWeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
}

-(void)endrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(void)getData{
    MJWeakSelf
    [HttpHandler getCurrentUser:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            [UserManager sharedData].mymodel = [ZWHMyModel mj_objectWithKeyValues:obj[@"data"]];
            [UserManager sharedData].userDict = obj[@"data"];
            [weakSelf.tableView reloadData];
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

-(void)creatView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = GRAYBACKCOLOR;
    [self.tableView registerClass:[ZWHLeRiTableViewCell class] forCellReuseIdentifier:LRCELL];
    [self.tableView registerClass:[ZWHLeImgTableViewCell class] forCellReuseIdentifier:LRIMGCELL];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = self.footView;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZWHMyModel *model = [UserManager sharedData].mymodel;
    if (indexPath.section == 0 && indexPath.row == 0) {
        ZWHLeImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRIMGCELL forIndexPath:indexPath];
        cell.type.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.type.text = @"头像";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],model.face]] placeholderImage:ImageNamed(DefautImageName)];
        return cell;
    }else{
        ZWHLeRiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LRCELL forIndexPath:indexPath];
        cell.type.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    cell.type.text = @"头像";
                    cell.yue.text = @"";
                    
                }
                    break;
                case 1:
                {
                    cell.type.text = @"昵称";
                    cell.yue.text = model.nickName==nil?@"":model.nickName;
                }
                    break;
                case 2:
                {
                    cell.type.text = @"消费商号";
                    cell.yue.text = model.consumerNo==nil?@"":model.consumerNo;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case 3:
                {
                    cell.type.text = @"我的二维码";
                    cell.yue.text = @"";
                    
                }
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:
                {
                    cell.type.text = @"性别";
                    cell.yue.text = [model.sex integerValue]==0?@"保密":[model.sex integerValue]==1?@"男":@"女";
                }
                    break;
                case 1:
                {
                    cell.type.text = @"手机号";
                    cell.yue.text = model.phone==nil?@"":[model.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                }
                    break;
                case 2:
                {
                    cell.type.text = @"支付宝账号";
                    cell.yue.text = model.aliAccount==nil?@"未绑定":@"已绑定";
                }
                    break;
                case 3:
                {
                    cell.type.text = @"储蓄卡";
                    cell.yue.text = model.cardNo==nil?@"未绑定":@"已绑定";
                    
                }
                    break;
                default:
                    break;
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //ZWHMyModel *model = [UserManager sharedData].mymodel;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                {
                    [self changeIcon];
                }
                break;
            case 1:
            {
                ZWHSetNameViewController *vc = [[ZWHSetNameViewController alloc]init];
                vc.title = @"修改昵称";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                ZWHQRViewController *vc = [[ZWHQRViewController alloc]init];
                vc.title = @"我的二维码";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                {
                    [self changeSex];
                }
                break;
            case 1:
            {
                ZWHSetPhoneViewController *vc = [[ZWHSetPhoneViewController alloc]init];
                vc.title = @"修改手机号";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                ZWHSetAlipayViewController *vc = [[ZWHSetAlipayViewController alloc]init];
                vc.title = @"绑定支付宝";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                ZWHSetBankViewController *vc = [[ZWHSetBankViewController alloc]init];
                vc.title = @"银行卡";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 选择性别
-(void)changeSex{
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"性别" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    MJWeakSelf
    UIAlertAction *pz = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HttpHandler getchangeUserInfo:@{@"type":@"0",@"value":@1,@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                ShowSuccessWithStatus(@"修改成功");
                [weakSelf getData];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }];
    UIAlertAction *xc = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HttpHandler getchangeUserInfo:@{@"type":@"0",@"value":@2,@"v_weichao":[UserManager token]} Success:^(id obj) {
            if (ReturnValue == 200) {
                ShowSuccessWithStatus(@"修改成功");
                [weakSelf getData];
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [aler addAction:pz];
    [aler addAction:xc];
    [aler addAction:cancel];
    [self presentViewController:aler animated:YES completion:nil];
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
    MJWeakSelf
    UIImage *image = info[UIImagePickerControllerEditedImage];
    ShowProgress
    NotAllowUser
    [HttpHandler getuploadImage:@{} imageArray:@[image] imageKeyArray:@[@"img"] success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj)
            [HttpHandler getchangeUserInfo:@{@"type":@"2",@"value":obj[@"data"][@"filePath"],@"v_weichao":[UserManager token]} Success:^(id obj) {
                if (ReturnValue == 200) {
                    ShowSuccessWithStatus(@"修改成功");
                    [weakSelf getData];
                    [picker dismissViewControllerAnimated:YES completion:nil];
                }else{
                    ShowInfoWithStatus(ErrorMessage);
                    [picker dismissViewControllerAnimated:YES completion:nil];
                }
            } failed:^(id obj) {
                ShowInfoWithStatus(ErrorNet);
                [picker dismissViewControllerAnimated:YES completion:nil];
            }];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - getter
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(50))];
    }
    return _footView;
}

@end
