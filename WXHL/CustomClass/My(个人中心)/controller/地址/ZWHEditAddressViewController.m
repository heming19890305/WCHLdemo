//
//  ZWHEditAddressViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/10.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHEditAddressViewController.h"
#import "AddressPickerView.h"
#import "CityPickerVeiw.h"

#import "KJChangeUserInfoTableViewCell.h"

#define KJCHCELL @"KJChangeUserInfoTableViewCell"

@interface ZWHEditAddressViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_titleArray;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *footView;

@property(nonatomic,strong)UISwitch *swith;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *area;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *number;

@property(nonatomic,assign)BOOL isdefautl;

@property(nonatomic,strong)NSMutableDictionary *dict;



@end

@implementation ZWHEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"收货人信息:",@"手机号码:",@"所在区域:",@"详细地址:",@"邮政编码:"];
    [self creatView];
    _dict = [NSMutableDictionary dictionary];
    [_dict setValue:@"0" forKey:@"defaultFlag"];
    [_dict setValue:[UserManager token] forKey:@"v_weichao"];
    if (_model) {
        [_dict setValue:_model.name forKey:@"name"];
        self.name = _model.name;
        [_dict setValue:_model.phone forKey:@"phone"];
        self.phone = _model.phone;
        [_dict setValue:_model.zone forKey:@"zone"];
        [_dict setValue:_model.zoneName forKey:@"zoneName"];
        self.area = _model.zoneName;
        [_dict setValue:_model.address forKey:@"address"];
        self.address = _model.address;
        [_dict setValue:_model.postCode forKey:@"postCode"];
        self.number = _model.postCode;
        [_dict setValue:_model.defaultFlag forKey:@"defaultFlag"];
        _isdefautl = [_model.defaultFlag integerValue]==1?YES:NO;
        
        [_dict setValue:_model.id forKey:@"id"];
    }
    //[self.backBtn setImage:ImageNamed(@"delete") forState:0];
}


-(void)creatView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = GRAYBACKCOLOR;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[KJChangeUserInfoTableViewCell class] forCellReuseIdentifier:KJCHCELL];
    self.tableView.tableFooterView = self.footView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
            self.automaticallyAdjustsScrollViewInsets = NO;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    [self.view addSubview:self.tableView];
}

#pragma mark - uitableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        KJChangeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KJCHCELL forIndexPath:indexPath];
        cell.isWidTitle = YES;
        cell.contentTex.enabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftTitleStr = _titleArray[indexPath.row];
        cell.contentTex.font = FontWithSize(14);
        [cell showRightImage:NO];
        cell.rightImage.image = ImageNamed(@"xuanze_xia");
        [cell.leftLable textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        cell.contentTex.keyboardType = UIKeyboardTypeDefault;
        MJWeakSelf
        switch (indexPath.row) {
            case 0:
            {
                cell.contentTex.text = weakSelf.name;
                [cell didEndInput:^(NSString *input) {
                    weakSelf.name = input;
                    [weakSelf.dict setValue:input forKey:@"name"];
                }];
            }
                break;
            case 1:
            {
                cell.contentTex.keyboardType = UIKeyboardTypeNumberPad;
                cell.contentTex.text = weakSelf.phone;
                [cell didEndInput:^(NSString *input) {
                    weakSelf.phone = input;
                    [weakSelf.dict setValue:input forKey:@"phone"];
                }];
            }
                break;
            case 2:
            {
                cell.contentTex.enabled = NO;
                [cell showRightImage:YES];
                cell.contentTex.text = weakSelf.area;
            }
                break;
            case 3:
            {
                cell.contentTex.text = weakSelf.address;
                [cell didEndInput:^(NSString *input) {
                    weakSelf.address = input;
                    [weakSelf.dict setValue:input forKey:@"address"];
                }];
            }
                break;
            case 4:
            {
                cell.contentTex.keyboardType = UIKeyboardTypeNumberPad;
                cell.contentTex.text = weakSelf.number;
                [cell didEndInput:^(NSString *input) {
                    weakSelf.number = input;
                    [weakSelf.dict setValue:input forKey:@"postCode"];
                }];
            }
                break;
            default:
                break;
        }
        return cell;
    }else{
        KJChangeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KJCHCELL forIndexPath:indexPath];
        cell.contentTex.enabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftTitleStr = @"设为默认地址";
        [cell.leftLable textFont:15 textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        _swith = [[UISwitch alloc]init];
        _swith.on = _isdefautl;
        [cell.contentView addSubview:_swith];
        _swith.tintColor = MAINCOLOR;
        [_swith addTarget:self action:@selector(isgetmessage:) forControlEvents:UIControlEventValueChanged];
        _swith.sd_layout
        .rightSpaceToView(cell.contentView, WIDTH_TO(15))
        .centerYEqualToView(cell.contentView)
        .heightIs(HEIGHT_TO(30))
        .widthIs(WIDTH_TO(60));
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [self.view endEditing:YES];
        [self getSpecialClicked];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return HEIGHT_TO(10);
}

#pragma mark - 是否设为默认
-(void)isgetmessage:(UISwitch *)sender{
    if (sender.on) {
        NSLog(@"开")
        _isdefautl = YES;
        [_dict setValue:@"1" forKey:@"defaultFlag"];
    }else{
        NSLog(@"关");
        _isdefautl = NO;
        [_dict setValue:@"0" forKey:@"defaultFlag"];
    }
}

#pragma mark - 获取收货地址
-(void)getSpecialClicked{
    MJWeakSelf
    ShowProgress
    NotAllowUser
    [HttpHandler getLocation:@{} Success:^(id obj) {
        if (ReturnValue == 200) {
            NSLog(@"%@",obj);
            Dismiss
            [ProvinceModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"list":@"CityModel"};
            }];
            [CityModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"list":@"DistrictModel"};
            }];
            [UserManager sharedData].addressArray = [ProvinceModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            CityPickerVeiw * cityView = [[CityPickerVeiw alloc] init];
            [cityView show];
            [cityView setCityBlock:^(NSString *cityname, NSString *citycode) {
                NSLog(@"%@----%@",cityname,citycode);
                weakSelf.area = [cityname stringByReplacingOccurrencesOfString:@"," withString:@"-"];
                [weakSelf.dict setValue:citycode forKey:@"zone"];
                [weakSelf.dict setValue:cityname forKey:@"zoneName"];
                [weakSelf.tableView reloadData];
            }];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
    
}


#pragma mark - 保存
-(void)saveAddress{
    if ([_dict[@"name"] length]==0 || [_dict[@"phone"] length]==0 || [_dict[@"zone"] length]==0 || [_dict[@"zoneName"] length]==0 || [_dict[@"address"] length]==0 || [_dict[@"postCode"] length]==0 || [_dict[@"defaultFlag"] length]==0) {
        ShowInfoWithStatus(@"请完善收货信息");
        return;
    }
    ShowProgress
    NotAllowUser
    if ([_state integerValue] == 0) {
        [HttpHandler getaddConsignees:_dict Success:^(id obj) {
            if (ReturnValue == 200) {
                ShowSuccessWithStatus(@"保存成功");
                NOTIFY_POST(@"address");
                ONEPOP
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }else{
        [HttpHandler getupdateAddress:_dict Success:^(id obj) {
            if (ReturnValue == 200) {
                ShowSuccessWithStatus(@"保存成功");
                NOTIFY_POST(@"address");
                ONEPOP
            }else{
                ShowInfoWithStatus(ErrorMessage);
            }
        } failed:^(id obj) {
            ShowInfoWithStatus(ErrorNet);
        }];
    }
    
}


#pragma mark - getter
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(120))];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        [btn setTitle:[_state integerValue]==1?@"保存":@"保存地址" forState:0];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = MAINCOLOR;
        [btn addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        btn.sd_layout
        .leftSpaceToView(_footView, WIDTH_TO(20))
        .rightSpaceToView(_footView, WIDTH_TO(20))
        .topSpaceToView(_footView, HEIGHT_TO(30))
        .heightIs(HEIGHT_TO(50));
    }
    return _footView;
}

@end
