//
//  SexChooseView.m
//  MengMa
//
//  Created by Yonger on 2017/7/3.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "KJSexChooseView.h"

@interface KJSexChooseView()<UITableViewDelegate,UITableViewDataSource>
{
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * stylesArry;
@property (nonatomic,assign)BOOL isMutaSelect;//是否是多选

@property (nonatomic,strong)NSString * selectStyle;
@property (nonatomic,assign)NSInteger selectIndex;

@property (nonatomic,strong)sureChooseContent selectBlock;


@property (nonatomic,strong)NSMutableArray * selectStyles;
@property (nonatomic,strong)NSMutableArray * selectIndexs;

@property (nonatomic,strong)sureChooseContents selectsBlock;
@end

@implementation KJSexChooseView

- (id)init {
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        self.backgroundColor = BACKCOLOR;
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(-2, 0,SCREEN_WIDTH+4, 40)];
        upVeiw.backgroundColor = [UIColor whiteColor];
        [self addSubview:upVeiw];
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 0, 40, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitleColor:[ZSColor hexStringToColor:@"292929"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hiddenPickerView) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:cancelButton];
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 40, 40);
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        chooseButton.backgroundColor = [UIColor whiteColor];
        [chooseButton setTitleColor:[ZSColor hexStringToColor:@"292929"] forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(hiddenPickerViewRight) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:chooseButton];
    
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 41,SCREEN_WIDTH, 0)];
        self.tableview.backgroundColor = [UIColor whiteColor]
        ;
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview.dataSource=self;
        self.tableview.delegate=self;
        [self addSubview:self.tableview];
    }
    return self;
}

//取消的隐藏
- (void)hiddenPickerView
{
    if(_isMutaSelect){
        if(_selectsBlock){
            _selectsBlock(@[],@[]);
        }
    }else{
        if(_selectBlock){
            _selectBlock(@"",0);
        }
    }
}

//确认的隐藏
-(void)hiddenPickerViewRight
{
    if(_isMutaSelect){
        if(_selectsBlock){
            _selectsBlock(self.selectStyles,self.selectIndexs);
        }
    }else{
        if(_selectBlock){
            _selectBlock(self.selectStyle,self.selectIndex);
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stylesArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdheader = @"cellIdheader";
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdheader];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdheader];
        cell.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell.textLabel textFont:16 textColor:[ZSColor hexStringToColor:@"292929"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        UIView * lineview= [[UIView alloc]init];
        lineview.backgroundColor = [ZSColor hexStringToColor:@"c9c9c9"];
        [cell.contentView addSubview:lineview];
        lineview.sd_layout
        .centerXEqualToView(cell.contentView)
        .heightIs(1)
        .widthIs(WIDTH_PRO(260))
        .bottomSpaceToView(cell.contentView,1);
    }
    if(_isMutaSelect){
        cell.textLabel.text = self.stylesArry[indexPath.row];
        if([self.selectIndexs containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]){
            cell.textLabel.textColor = MAINCOLOR;
        }else{
            cell.textLabel.textColor = [ZSColor hexStringToColor:@"292929"];
        }
    }else{
        cell.textLabel.text = self.stylesArry[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isMutaSelect){
        if([self.selectIndexs containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]){
            [self.selectStyles removeObject:self.stylesArry[indexPath.row]];
            [self.selectIndexs removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }else{
            [self.selectStyles addObject:self.stylesArry[indexPath.row]];
            [self.selectIndexs addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }
        [self.tableview reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }else{
        self.selectStyle = self.stylesArry[indexPath.row];
        self.selectIndex = indexPath.row;
        [self hiddenPickerViewRight];
    }
}

#pragma mark -- show and hidden
- (void)showInView:(UIView *)view withAllSelects:(NSArray *)selects didselect:(sureChooseContent)select{
    _isMutaSelect = NO;
    _selectBlock = select;
    self.stylesArry = [NSMutableArray arrayWithArray:selects];
    _selectStyle = self.stylesArry[0];
    _selectIndex = 0;
    CGFloat height =  selects.count*55+41;
    if(height >211){
        height = 211;
    }
    if(height < 180){
        height = 180;
    }
    self.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH,height);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT-height,SCREEN_WIDTH,height);
        self.tableview.frame = CGRectMake(0, 41,SCREEN_WIDTH,height-41);
        [self.tableview reloadData];
    } completion:^(BOOL finished) {
        
    }];
}

//几选多
- (void)showInView:(UIView *)view withAllSelects:(NSArray *)selects didselects:(sureChooseContents)select{
    _isMutaSelect = YES;
    _selectsBlock = select;
    self.stylesArry = [NSMutableArray arrayWithArray:selects];
    self.selectStyles = [NSMutableArray array];
    self.selectIndexs = [NSMutableArray array];
    CGFloat height =  selects.count*55+41;
    if(height >211){
        height = 211;
    }
    if(height < 180){
        height = 180;
    }
    self.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH,height);
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT-height,SCREEN_WIDTH,height);
        self.tableview.frame = CGRectMake(0, 41,SCREEN_WIDTH,height-41);
        [self.tableview reloadData];
    } completion:^(BOOL finished) {
        
    }];
}


@end
