//
//  ZWHChoosePayWayView.m
//  WXHL
//
//  Created by Syrena on 2017/12/7.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHChoosePayWayView.h"
#import "KJUserInfoOneTableViewCell.h"

#define NORCELL @"uitableviewcell"
#define KJCELL @"KJUserInfoOneTableViewCell"


@interface ZWHChoosePayWayView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;

@end

@implementation ZWHChoosePayWayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor redColor];
        _titleArray = @[@"支付宝",@"余额支付",@"提货券"];
        [self creatView];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, SCREENHIGHT, SCREENWIDTH, 0);
        MJWeakSelf
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.frame = CGRectMake(0, SCREENHIGHT - HEIGHT_TO(40)-HEIGHT_TO(50)*3, SCREEN_WIDTH, HEIGHT_TO(40)+HEIGHT_TO(50)*3);
            weakSelf.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_TO(40)+HEIGHT_TO(50)*3);
        }];
    }
    return self;
}

-(void)creatView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NORCELL];
    [self.tableView registerClass:[KJUserInfoOneTableViewCell class] forCellReuseIdentifier:KJCELL];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        } else {
            
        }
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableView];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(50);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_TO(40);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KJUserInfoOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KJCELL forIndexPath:indexPath];
    cell.image = _titleArray[indexPath.row];
    cell.title = _titleArray[indexPath.row];
    cell.inputTex.enabled = NO;
    /*cell.textLabel.text = _titleArray[indexPath.row];
    cell.imageView.image = ImageNamed(_titleArray[indexPath.row]);
    cell.backgroundColor = [UIColor whiteColor];*/
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_returnway) {
        [self removeFromSuperview];
        _returnway(indexPath.row+1);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEIGHT_TO(40))];
    view.backgroundColor = LINECOLOR;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setBackgroundImage:ImageNamed(@"left_fanhui") forState:UIControlStateNormal];
    [back addTarget:self action:@selector(viewbackClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:back];
    view.sd_layout
    .leftSpaceToView(view, WIDTH_TO(15))
    .centerYEqualToView(view)
    .heightIs(HEIGHT_TO(18))
    .widthIs(WIDTH_TO(18));
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"请选择支付方式";
    [lab textFont:16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [view addSubview:lab];
    lab.sd_layout
    .centerXEqualToView(view)
    .widthIs(WIDTH_TO(120))
    .centerYEqualToView(view)
    .autoHeightRatio(0);
    
    return view;
}

#pragma mark - 返回
-(void)viewbackClicked{
    [self removeFromSuperview];
}


@end
