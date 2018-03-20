//
//  ZWHChoseExView.m
//  WXHL
//
//  Created by Syrena on 2017/11/14.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHChoseExView.h"

#define wid  WIDTH_TO(90)

@interface ZWHChoseExView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation ZWHChoseExView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = @[@"快递",@"EMS",@"自提"];
        //self.frame = CGRectMake(SCREENWIDTH - WIDTH_TO(wid) - WIDTH_TO(15), 54, WIDTH_TO(wid), 0);
        self.backgroundColor = [UIColor clearColor];
        [self creatView];
    }
    return self;
}



-(void)showViewWith:(CGRect)frame{
    CGFloat y = CGRectGetMaxY(frame) - HEIGHT_TO(9) + 64;
    self.frame = CGRectMake(WIDTH_TO(15), y,WIDTH_TO(wid),0);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(WIDTH_TO(15), y,WIDTH_TO(wid),HEIGHT_TO(40)*3+HEIGHT_TO(10));
        self.tableView.frame = CGRectMake(0, HEIGHT_TO(9),WIDTH_TO(wid),HEIGHT_TO(40)*3);
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)creatView{
    UIImageView *img = [[UIImageView alloc]initWithImage:ImageNamed(@"top_jt")];
    img.frame = CGRectMake(wid - WIDTH_TO(15+10), 0, WIDTH_TO(20), HEIGHT_TO(9));
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
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_TO(40);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font =FontWithSize(13);
    //cell.imageView.image = ImageNamed(_dataArray[indexPath.row]);
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
