//
//  ZWHFeedViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHFeedViewController.h"

@interface ZWHFeedViewController ()
@property(nonatomic,strong)UITextView *wordTV;

@end

@implementation ZWHFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LINECOLOR;
    _wordTV = [[UITextView alloc]init];
    _wordTV.backgroundColor = [UIColor whiteColor];
    _wordTV.textColor = ZWHCOLOR(@"646363");
    _wordTV.font = FontWithSize(14);
    _wordTV.text = @"服务态度良好";
    _wordTV.layer.cornerRadius = 5;
    _wordTV.layer.masksToBounds = YES;
    [self.view addSubview:_wordTV];
    _wordTV.sd_layout
    .leftSpaceToView(self.view, WIDTH_TO(15))
    .rightSpaceToView(self.view, WIDTH_TO(15))
    .heightIs(HEIGHT_TO(150))
    .topSpaceToView(self.view, HEIGHT_TO(20));
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.backgroundColor = MAINCOLOR;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(senderClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.sd_layout
    .rightSpaceToView(self.view, WIDTH_TO(15))
    .topSpaceToView(_wordTV, HEIGHT_TO(20))
    .widthIs(WIDTH_TO(110))
    .heightIs(HEIGHT_TO(40));
    
}


#pragma mark - 提交
-(void)senderClicked{
    if (_wordTV.text.length == 0) {
        ShowInfoWithStatus(@"反馈内容不能为空");
        return;
    }
    [HttpHandler getaddFeedback:@{@"content":_wordTV.text} Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"反馈成功");
            ONEPOP
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowErrorWithStatus(ErrorNet);
    }];
}

@end
