//
//  ZWHRightView.m
//  WXHL
//
//  Created by Syrena on 2017/11/8.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHRightView.h"

#define wid 150

@interface ZWHRightView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation ZWHRightView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = @[@"消息",@"关于我们",@"合作联系",@"声明",@"使用指南",@"反馈与售后"];
        self.frame = CGRectMake(SCREENWIDTH - WIDTH_TO(wid) - WIDTH_TO(15), 54, WIDTH_TO(wid), 0);
        self.backgroundColor = [UIColor clearColor];
        [self creatView];
    }
    return self;
}



-(void)showView{
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(SCREENWIDTH - WIDTH_TO(wid) - WIDTH_TO(15), 54,WIDTH_TO(wid),HEIGHT_TO(40)*6+HEIGHT_TO(10));
        self.tableView.frame = CGRectMake(0, HEIGHT_TO(9),WIDTH_TO(wid),HEIGHT_TO(40)*6);
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)creatView{
    UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"top_jt")];
    img.frame = CGRectMake(WIDTH_TO(150) - WIDTH_TO(5) - WIDTH_TO(20), 0, WIDTH_TO(20), HEIGHT_TO(9));
    [self addSubview:img];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HEIGHT_TO(9), WIDTH_TO(wid), 0) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cell"];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.bounces = NO;
    self.tableView.alpha = 0.7;
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        } else {
        }
    }
    [self addSubview:self.tableView];
}


#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font =FontWithSize(13);
    cell.imageView.image = ImageNamed(_dataArray[indexPath.row]);
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_didinput) {
        _didinput(indexPath.row);
    }
}

@end
