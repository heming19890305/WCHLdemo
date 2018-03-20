//
//  ZWHJudgeViewController.m
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHJudgeViewController.h"
#import "ZWHOrderTableViewCell.h"
#import "ZWHJudgeTableViewCell.h"

#define ORCELL @"ZWHOrderTableViewCell"
#define JUCELL @"ZWHJudgeTableViewCell"

@interface ZWHJudgeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arr;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UITextView *wordTV;

@property(nonatomic,assign)NSInteger selecell;

@end

@implementation ZWHJudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = @[@"好评",@"中评",@"差评"];
    _selecell = -1;
    [self creatView];
}


-(void)creatView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerClass:[ZWHOrderTableViewCell class] forCellReuseIdentifier:ORCELL];
    
    [self.tableView registerClass:[ZWHJudgeTableViewCell class] forCellReuseIdentifier:JUCELL];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return HEIGHT_TO(110);
    }
    return HEIGHT_TO(40);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return HEIGHT_TO(10);
    }
    return CGFLOAT_MIN;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ZWHOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ORCELL forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_goodmodel) {
            cell.ordermodel = _goodmodel;
        }
        return cell;
    }else{
        ZWHJudgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JUCELL forIndexPath:indexPath];
        cell.icon.image = ImageNamed(_arr[indexPath.row]);
        cell.title.text = _arr[indexPath.row];
        cell.select.tag = indexPath.row;
        [cell.select addTarget:self action:@selector(seleClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.select.selected = _selecell==cell.select.tag?YES:NO;
        return cell;
    }
    
}

#pragma mark - 选中
-(void)seleClicked:(UIButton *)sender{
    _selecell = sender.tag;
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selecell = indexPath.row;
    [self.tableView reloadData];
}

#pragma mark - 发表评论
-(void)judgeClicked{
    if (_selecell==-1) {
        ShowInfoWithStatus(@"请选择等级");
        return;
    }
    if (_wordTV.text.length == 0) {
        ShowInfoWithStatus(@"请输入评价类容");
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ZWHINTTOSTR(_selecell+1) forKey:@"score"];
    [dict setValue:_wordTV.text forKey:@"content"];
    [dict setValue:_goodmodel.detailId forKey:@"detailId"];
    [dict setValue:[UserManager token] forKey:@"v_weichao"];
    NSLog(@"%@",dict);
    MJWeakSelf
    ShowProgress
    NotAllowUser
    [HttpHandler getaddComment:dict Success:^(id obj) {
        if (ReturnValue == 200) {
            ShowSuccessWithStatus(@"评价成功");
            NOTIFY_POST(@"orderlist");
            [weakSelf.navigationController popViewControllerAnimated: YES];
        }else{
            ShowInfoWithStatus(ErrorMessage);
        }
    } failed:^(id obj) {
        ShowInfoWithStatus(ErrorNet);
    }];
}

#pragma mark - getter
-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(250))];
        _wordTV = [[UITextView alloc]init];
        _wordTV.backgroundColor = lineColor;
        _wordTV.textColor = ZWHCOLOR(@"fbfbfb");
        _wordTV.layer.borderColor = ZWHCOLOR(@"ebeaea").CGColor;
        _wordTV.layer.borderWidth = 1;
        _wordTV.font = FontWithSize(14);
        _wordTV.layer.cornerRadius = 4;
        _wordTV.layer.masksToBounds = YES;
        [_footerView addSubview:_wordTV];
        _wordTV.sd_layout
        .leftSpaceToView(_footerView, WIDTH_TO(15))
        .rightSpaceToView(_footerView, WIDTH_TO(15))
        .heightIs(HEIGHT_TO(150))
        .topEqualToView(_footerView);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = FontWithSize(14);
        [btn setTitle:@"发表评论" forState:0];
        [btn setTitleColor:[UIColor redColor] forState:0];
        btn.layer.borderColor = [UIColor redColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(judgeClicked) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        [_footerView addSubview:btn];
        btn.sd_layout
        .leftEqualToView(_wordTV)
        .heightIs(HEIGHT_TO(30))
        .widthIs(WIDTH_TO(70))
        .topSpaceToView(_wordTV, HEIGHT_TO(20));
    }
    return _footerView;
}

@end
