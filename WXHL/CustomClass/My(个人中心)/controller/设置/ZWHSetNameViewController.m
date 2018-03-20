//
//  ZWHSetNameViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/9.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHSetNameViewController.h"

@interface ZWHSetNameViewController ()

@property(nonatomic,strong)UITextField *nameF;

@end

@implementation ZWHSetNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
    [_nameF becomeFirstResponder];
}

-(void)creatView{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = GRAYBACKCOLOR;
    
    UIView *white = [[UIView alloc]init];
    white.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:white];
    white.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, HEIGHT_TO(20))
    .heightIs(HEIGHT_TO(50));
    
    _nameF = [[UITextField alloc]init];
    _nameF.clearButtonMode = UITextFieldViewModeAlways;
    [white addSubview:_nameF];
    _nameF.sd_layout
    .leftSpaceToView(white, WIDTH_TO(15))
    .rightSpaceToView(white, WIDTH_TO(15))
    .topSpaceToView(white, 0)
    .heightIs(HEIGHT_TO(50));
}

-(void)doneClicked{
    [self.view endEditing:YES];
    if (_nameF.text.length == 0 || _nameF.text.length > 10) {
        ShowInfoWithStatus(@"请输入正确昵称(昵称不能过长或没有)");
        return;
    }
    [HttpHandler getchangeUserInfo:@{@"type":@"1",@"value":_nameF.text,@"v_weichao":[UserManager token]} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"修改成功");
            NOTIFY_POST(@"myinfodata");
            NOTIFY_POST(@"mycenter");
            ONEPOP
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

@end
