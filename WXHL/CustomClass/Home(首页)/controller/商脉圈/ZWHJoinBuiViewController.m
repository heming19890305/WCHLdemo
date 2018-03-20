//
//  ZWHJoinBuiViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHJoinBuiViewController.h"
#import "ZWHBuinessViewController.h"

@interface ZWHJoinBuiViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *contex;
@property(nonatomic,strong)UIBarButtonItem *rig;
@end

@implementation ZWHJoinBuiViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor  = [UIColor grayColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
}

-(void)creatView{
    self.view.backgroundColor = ZWHCOLOR(@"f6f6f6");
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    self.navigationItem.rightBarButtonItem = more;
    _rig = more;
    
    UIView *texv = [[UIView alloc]init];
    texv.backgroundColor = [UIColor whiteColor];
    texv.layer.borderColor = ZWHCOLOR(@"e7e7e7").CGColor;
    texv.layer.borderWidth = 1;
    [self.view addSubview:texv];
    texv.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(HEIGHT_TO(60))
    .topSpaceToView(self.view, HEIGHT_TO(20));
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:15 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    lab.text = @"邀请人账号：";
    [texv addSubview:lab];
    lab.sd_layout
    .leftSpaceToView(texv, WIDTH_TO(15))
    .centerYEqualToView(texv)
    .autoHeightRatio(0);
    [lab setSingleLineAutoResizeWithMaxWidth:200];
    [lab updateLayout];
    
    _contex = [[UITextField alloc]init];
    _contex.font = FontWithSize(15);
    _contex.textColor = [UIColor blackColor];
    _contex.delegate = self;
    if (_str) {
        _contex.text = _str;
    }
    [texv addSubview:_contex];
    _contex.sd_layout
    .leftSpaceToView(lab, WIDTH_TO(5))
    .centerYEqualToView(texv)
    .heightIs(HEIGHT_TO(40))
    .rightSpaceToView(texv, WIDTH_TO(15));
    
    _contex.clearButtonMode = UITextFieldViewModeAlways;
    
    UILabel *labdet = [[UILabel alloc]init];
    [labdet textFont:13 textColor:ZWHCOLOR(@"646363") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    labdet.text = @"请输入圈主账号加入商脉圈";
    [self.view addSubview:labdet];
    labdet.sd_layout
     .leftSpaceToView(self.view, WIDTH_TO(15))
     .topSpaceToView(texv,HEIGHT_TO(8))
     .autoHeightRatio(0);

    [labdet setSingleLineAutoResizeWithMaxWidth:SCREENWIDTH];
    [labdet updateLayout];
    
}

-(void)doneClicked:(UIButton *)sender{
    if ([[UserManager token] length]==0) {
        [self getLogin];
        return;
    }
    if (_contex.text.length == 0) {
        return;
    }
    MJWeakSelf
    [HttpHandler getaddVencircle:@{@"phone":_contex.text,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            [HttpHandler getCurrentUser:@{@"v_weichao":[UserManager token]} Success:^(id obj) {
                if (ReturnValue == 200) {
                    NSLog(@"%@",obj);
                    ShowSuccessWithStatus(@"加入成功");
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text>0) {
        [_rig setTitleTextAttributes:@{NSForegroundColorAttributeName:MAINCOLOR} forState:UIControlStateNormal];
    }else{
        [_rig setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    }
}

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return  YES;
}*/



@end
