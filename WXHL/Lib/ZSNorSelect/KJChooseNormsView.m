//
//  KJChooseNormsView.m
//  KPH
//
//  Created by Yonger on 2017/8/3.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "KJChooseNormsView.h"
#import "KJNormRadioChooseView.h"

@interface KJChooseNormsView ()

@property(nonatomic,strong)NSArray * allNormInfoArry;//[{@"key":@"name",@"val":@"a,b,c"},{}]
@property(nonatomic,strong)NSArray * selectNormInfoArry;//之前选择的规格[{@"key":@"name",@"val":@"a"},{}]@end


@property(nonatomic,strong)normChooseDidChange changeBlock;
@property(nonatomic,strong)NSMutableArray * radioViews;

@end
@implementation KJChooseNormsView

-(void)normChooseDidChange:(normChooseDidChange)change{
    _changeBlock = change;
}


-(BOOL)isSelectAllNorm//判断是否所有规则都做了选择
{
    for (KJNormRadioChooseView * radioview in self.radioViews) {
        if (!radioview.isSelect) {
            return NO;
        }
    }
    return YES;
}
-(NSString *)selectNormInfo//获取选择的规格[{@"key":@"name",@"val":@"a"},{}]
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self loadSelectInfoArry] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

-(NSArray *)loadSelectInfoArry{
    NSMutableArray * selectNormInfoTemp = [NSMutableArray array];
    for (KJNormRadioChooseView * radioview in self.radioViews) {
        [selectNormInfoTemp addObject:@{@"key":radioview.key,@"val":[radioview selectValue]}];
    }
    return selectNormInfoTemp;
}



-(instancetype)initWithFrame:(CGRect)frame WithAllNormInfo:(NSArray *)allNormInfoArry SelectNormInfo:(NSArray *)selectInfo readOnly:(BOOL)readOnly{
    self = [super initWithFrame:frame];
    if(self){
        self.allNormInfoArry = allNormInfoArry;
        self.selectNormInfoArry = selectInfo;
        self.radioViews = [NSMutableArray array];
        [self createView];
        self.userInteractionEnabled = !readOnly;
    }
    return self;
}

-(void)normChooseDidChangeAction{
    if(_changeBlock){
        if([self isSelectAllNorm]){//全部选择
            _changeBlock(YES);
        }else{//有没选的
            _changeBlock(NO);
        }
    }
}

-(void)createView{
    CGFloat height = 0;
    
    /*for (NSDictionary * dict in self.allNormInfoArry) {
        NSString * key = dict[@"key"];
        NSString * value = dict[@"val"];
        NSString * selectValue = [self fetchSelectvaluebykey:key];
        KJNormRadioChooseView * radioview = [[KJNormRadioChooseView alloc]initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 0) Key:key Values:[value componentsSeparatedByString:@","] SelectValu:selectValue];
        height += radioview.height;
        [self addSubview:radioview];
        [self.radioViews addObject:radioview];
        [radioview didChooseNorm:^(NSString *norm) {
           //当选择某一个规格
            [self normChooseDidChangeAction];
        }];
    }*/
    for (NSInteger i=0; i<self.allNormInfoArry.count; i++) {
        NSDictionary *dict = self.allNormInfoArry[i];
        NSString * key = dict[@"key"];
        NSString * value = dict[@"val"];
        NSString * selectValue = [self fetchSelectvaluebykey:key with:i];
        KJNormRadioChooseView * radioview = [[KJNormRadioChooseView alloc]initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 0) Key:key Values:[value componentsSeparatedByString:@","] SelectValu:selectValue];
        height += radioview.height;
        [self addSubview:radioview];
        [self.radioViews addObject:radioview];
        [radioview didChooseNorm:^(NSString *norm) {
            //当选择某一个规格
            [self normChooseDidChangeAction];
        }];
    }
    self.height = height;
}
-(NSString *)fetchSelectvaluebykey:(NSString *)key with:(NSInteger)index{
    if(self.selectNormInfoArry.count>0){
        for (NSInteger i = 0; i < self.selectNormInfoArry.count; i++) {
            if (i == index) {
                return self.selectNormInfoArry[i][@"val"];
            }
        }
    }
    return @"";
}



-(NSString *)fetchSelectvaluebykey:(NSString *)key{
    if(self.selectNormInfoArry.count>0){
        for (NSDictionary * dict in self.selectNormInfoArry) {
            NSString * thiskey = dict[@"key"];
            if([thiskey isEqualToString:key]){
                return dict[@"val"];
            }
        }
    }
    return @"";
    /*if(self.selectNormInfoArry.count>0){
        for (NSDictionary * dict in self.selectNormInfoArry) {
            NSString * thiskey = dict[@"key"];
            if([thiskey isEqualToString:key]){
                return dict[@"val"];
            }
        }
        for (NSInteger i = 0; i , self.selectNormInfoArry.count; i++) {
            
        }
    }
    return @"";*/
}

@end
