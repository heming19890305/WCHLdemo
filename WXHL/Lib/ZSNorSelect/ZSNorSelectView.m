//
//  ZSNorSelectView.m
//  KPH
//
//  Created by 赵升 on 2017/6/9.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "ZSNorSelectView.h"
#import "KJChooseNormsView.h"

#define MaxHeight SCREEN_HEIGHT/10*9

@interface ZSNorSelectView()<UITableViewDelegate,UITableViewDataSource,goodsNumberChooseChangeDelegete>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KJChooseNormsView * normChooseView;

@property (nonatomic, strong) didFetchDataAndChangeHeight changeBlock;
@end

@implementation ZSNorSelectView


-(void)didChangeHeight:(didFetchDataAndChangeHeight)change{
    _changeBlock = change;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectNumber = 1;
        self.savenumber = @"-1";
        [self createView];
    }
    return self;
}

-(void)setGoodsId:(NSString *)goodsId{
    _goodsId = goodsId;
    [self loadGoodsNormInfo];
}

//@[@{@"key":@"套餐一",@"val":@"哈哈,呵呵"}]
-(void)setModel:(ZWHGoodsModel *)model{
    _model = model;
    NSMutableArray *arrayM = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    for (NSDictionary *dict in _model.attrs) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
        NSMutableArray *valu = [NSMutableArray array];
        [dictM setValue:dict[@"attrName"] forKey:@"key"];
        [selectDict setValue:dict[@"attrName"] forKey:@"key"];
        [selectDict setValue:dict[@"attrValue"] forKey:@"val"];
        NSLog(@"%@",dict[@"values"]);
        for (NSString *str in dict[@"values"]) {
            [valu addObject:str];
        }
        [dictM setValue:[UserManager dealWith:valu with:@","] forKey:@"val"];
        [arrayM addObject:dictM];
        [_selectArray addObject:selectDict];
    }
    _normsArray = [NSArray arrayWithArray:arrayM];
    [self loadGoodsNormInfo];
}

- (void)createView{
    self.certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.certainBtn setTitle:@"确定" forState:0];
    self.certainBtn.titleLabel.font = FontWithSize(14);
    [self.certainBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.certainBtn.backgroundColor = ZWHCOLOR(@"ff5555");
    //self.certainBtn.enabled = NO;
    [self addSubview:self.certainBtn];
    self.certainBtn.sd_layout
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(50)
    .rightEqualToView(self);
    
    self.headerView = [[ZSNorTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(140))];
    [self.headerView.closeBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headerView];
    

    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    self.tableView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomSpaceToView(self.certainBtn, 0)
    .topSpaceToView(self.headerView, 0)
    .maxHeightIs(MaxHeight-self.headerView.height-self.certainBtn.height);//最大高度
    
    
}

- (void)dismissView{
    if ([self.dismissDelegate respondsToSelector:@selector(dismiss)]) {
        [self.dismissDelegate dismiss];
    }
}


//加载规格选择视图
-(void)loadGoodsNormInfo{
    self.headerView.goodsImageView.image = ImageNamed(@"logo");
    self.headerView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [_nowprice floatValue]];
    self.headerView.chooseNor.text = @"请选择规格";
    [self.headerView.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],_model.masterImg]]];
    
    self.tableView.tableFooterView = self.bottomView;
    self.normChooseView  = [[KJChooseNormsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) WithAllNormInfo:_normsArray SelectNormInfo:_selectArray readOnly:NO];
    [self getDefaultDict];
    MJWeakSelf
    [self.normChooseView normChooseDidChange:^(BOOL isselectAll) {
        if ([weakSelf.dismissDelegate respondsToSelector:@selector(inputSelectNor:)]) {
            [weakSelf.dismissDelegate inputSelectNor:weakSelf.normChooseView.selectNormInfo];
        }
        weakSelf.savenumber = @"";
        weakSelf.normsString = @"";
        weakSelf.productId = @"";
        weakSelf.savenumber = @"-1";
        weakSelf.norDict = nil;
        if(isselectAll){
            //全部规格已选(获取价钱)
            [weakSelf fetchNormPriceAction];
        }else{//部分规格已选（显示商品最低价）
            [weakSelf showGoodsInfoInheader:@"请选择规格"];
        }
    }];
    self.tableView.tableHeaderView = self.normChooseView;
    self.tableView.height = self.normChooseView.height;
    [self.tableView reloadData];
    if(_changeBlock){
        _changeBlock(self.tableView.height+self.headerView.height+self.certainBtn.height+self.bottomView.height);
    }
}

//获得默认规格
-(void)getDefaultDict{
    self.normsString = self.normChooseView.selectNormInfo;
    NSLog(@"%@",self.normsString);
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[self.normsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSArray *selectArray = (NSArray *)jsonObject;
    NSLog(@"%@",selectArray);
    //获得选择的规格
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSDictionary *dict in selectArray) {
        NSString *str = dict[@"val"];
        [valueArray addObject:str];
    }
    NSArray *extend = _model.extendLists;
    for (NSDictionary *dict in extend) {
        NSInteger j=0;
        for (NSDictionary *vald in dict[@"skuValue"]) {
            for (NSString *str in valueArray) {
                if ([vald[@"value"] isEqualToString:str]) {
                    j++;
                }
            }
        }
        if (j == valueArray.count) {
            self.productId = dict[@"id"];
            self.norDict = dict;
            self.headerView.dict = dict;
        }
    }
}


//根据规格获取价钱
-(void)fetchNormPriceAction{
    self.normsString = self.normChooseView.selectNormInfo;
    NSLog(@"%@",self.normsString);
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[self.normsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSArray *selectArray = (NSArray *)jsonObject;
    NSLog(@"%@",selectArray);
    //获得选择的规格
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSDictionary *dict in selectArray) {
        NSString *str = dict[@"val"];
        [valueArray addObject:str];
    }
    
    NSArray *extend = _model.extendLists;
    
    for (NSDictionary *dict in extend) {
        NSInteger sum=0;
        for (NSInteger i=0; i<valueArray.count; i++){
            NSDictionary *vadict = dict[@"skuValue"][i];
            if ([valueArray[i] isEqualToString:vadict[@"value"]]) {
                sum++;
                if (sum == valueArray.count) {
                    self.productId = dict[@"id"];
                    self.norDict = dict;
                    self.headerView.dict = dict;
                    break;
                }
            }
        }
    }
    if ([self.productId isEqualToString:@""]) {
        ShowInfoWithStatus(@"改规格无货");
    }
    
    
    
    /*for (NSDictionary *dict in extend) {
        NSInteger j=0;
        for (NSDictionary *vald in dict[@"skuValue"]) {
            for (NSString *str in valueArray) {
                if ([vald[@"value"] isEqualToString:str]) {
                    j++;
                }
            }
        }
        if (j == valueArray.count) {
            self.productId = dict[@"id"];
            self.norDict = dict;
            self.headerView.dict = dict;
        }
    }
    if ([self.productId isEqualToString:@""]) {
        ShowInfoWithStatus(@"改规格无货");
    }*/
    
    
   // self.headerView.model = model;
    //self.nowprice = model.nowPrice;
    //[self showGoodsInfoInheader:@"无货"];
    
    /*[HttpHandler fetchGoodsNormInfoPartParams:@{@"goodsId":self.goodsModel.goodsId,@"jsonStr":self.normChooseView.selectNormInfo} Success:^(id obj) {
        if([obj[@"state"] integerValue] ==1){
            KJProductModel * model = [KJProductModel mj_objectWithKeyValues:obj[@"data"]];
            model.nowPrice = obj[@"data"][@"newPrice"];
            model.productId = obj[@"data"][@"id"];
            self.productId = model.productId;
            self.activityType = model.activityType;
            self.normsString = self.normChooseView.selectNormInfo;
            self.chooseProductModel = model;
            if(model && model != [NSNull null]){
                self.headerView.model = model;
                self.nowprice = model.nowPrice;
            }else{
                [self showGoodsInfoInheader:@"无货"];
            }
        }else if([obj[@"state"] integerValue] ==2){
            [self showGoodsInfoInheader:@"无货"];
        }else{
            [self showGoodsInfoInheader:@"无货"];
        }
    } failed:^(id obj) {
    }];*/
}

-(void)showGoodsInfoInheader:(NSString *)remark{
    
    
    //[self.headerView.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_HOST,self.goodsModel.firstImg]] placeholderImage:ImageNamed(DefautImageName)];
    self.headerView.oldpriceLabel.attributedText = nil;
    self.headerView.priceLabel.text = @"¥0.00";
    //self.headerView.priceLabel.text = self.goodsModel.minPrice;
    self.headerView.chooseNor.text = remark;
    self.headerView.priceLabel.sd_layout
    .bottomSpaceToView(self.headerView.chooseNor, HEIGHT_PRO(13));
    self.headerView.chooseNor.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

//返回是否能进行支付(库存足不足)
/*-(BOOL)canPayforGoods{
    if([self.chooseProductModel.repertory integerValue]>=1){
        return YES;
    }
    return NO;
}*/

-(void)didChangeNumber:(NSInteger)goodsNumber{
    NSLog(@"%ld",goodsNumber);
    self.selectNumber = goodsNumber;
}

-(ZSNorTableBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[ZSNorTableBottomView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(60))];
        _bottomView.delegete = self;
    }
    return _bottomView;
}
@end
