//
//  cityPickerVeiw.m
//  丢必得
//
//  Created by ZSMAC on 17/9/6.
//  Copyright © 2017年 zhangwenshuai. All rights reserved.
//

#import "CityPickerVeiw.h"
#import "CityModel.h"
#import "ProvinceModel.h"
#import "DistrictModel.h"
#import "DistrictModel.h"
#import "UIView+GoodView.h"
#define SCREEN [UIScreen mainScreen].bounds.size
@implementation CityPickerVeiw
{
    NSArray * section1;
    NSArray * section2;
    NSArray * section3;
    
    
    NSString * provinceStr;
    NSString * cityStr;
    NSString * districtStr;
    
    NSString * provinceCode;
    NSString * cityCode;
    NSString * districtCode;
    
    
    NSString * resultsStr;
    NSString * resultsCode;
    UIPickerView * cityPickerView;

}
-(instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self dataConfiguer];
        [self uiConfiguer];
    }
    return self;
}
- (void)dataConfiguer {
    //获取总资源
    //全部的省数组
    section1 = [[UserManager sharedData].addressArray copy];
    //取出市数组 （一个省的所有城市）
    ProvinceModel * shiModel = section1.firstObject;
    section2 = shiModel.list;
    
    CityModel * xianModel = section2.firstObject;
    section3 = xianModel.list;
    
    ProvinceModel *sheng=section1.firstObject;
    provinceStr=sheng.name;
    provinceCode = sheng.code;
    
    CityModel *shi=section2.firstObject;
    cityStr=shi.name;
    cityCode=shi.code;
    
    DistrictModel *xian=section3.firstObject;
    districtStr=xian.name;
    districtCode = xian.code;
    
    resultsStr = [NSString stringWithFormat:@"%@,%@,%@",provinceStr,cityStr,districtStr];
    resultsCode = [NSString stringWithFormat:@"%@,%@,%@",sheng.code,shi.code,xian.code];
}
#pragma mark 显示已选择的
- (void)setShowSelectedCityNameStr:(NSString *)showSelectedCityNameStr {
    _showSelectedCityNameStr=showSelectedCityNameStr;
    NSUInteger index1=0;
    NSUInteger index2=0;
    NSUInteger index3=0;
    NSArray * nameArray = [_showSelectedCityNameStr componentsSeparatedByString:@"-"];
    
    if (nameArray.count==3) {
       NSString * name1 = nameArray.firstObject;
        NSUInteger index=0;
        for (ProvinceModel *model in section1) {
            if ([model.name isEqualToString:name1]) {
                index= [section1 indexOfObject:model];
                break;
            }
        }
        index1=index;
        NSString * name2 = nameArray[1];
        //第二个区
        ProvinceModel * section1Model =section1[index];
        section2 =section1Model.list;
        for (CityModel * xianModel in section2) {
            if ([xianModel.name isEqualToString:name2]) {
                index= [section2 indexOfObject:xianModel];
                break;
            }
        }
         index2=index;
        NSString * name3 = nameArray.lastObject;
        //第三个区
        CityModel * cityModel =section2[index];
        section3 =cityModel.list;
        for (DistrictModel * districtModel in section3) {
            if ([districtModel.name isEqualToString:name3]) {
                index= [section3 indexOfObject:districtModel];
                break;
            }
        }
         index3=index;
        [cityPickerView reloadAllComponents];
    }
    [cityPickerView selectRow:index1 inComponent:0 animated:NO];
    [cityPickerView selectRow:index2 inComponent:1 animated:NO];
    [cityPickerView selectRow:index3 inComponent:2 animated:NO];
    
    ProvinceModel *sheng=[section1 objectAtIndex:index1];
    provinceStr=sheng.name;
    
    CityModel *shi=[section2 objectAtIndex:index2];
    cityStr=shi.name;
    
    DistrictModel *xian=[section3 objectAtIndex:index3];
    districtStr=xian.name;
    
    resultsStr=[NSString stringWithFormat:@"%@,%@,%@",provinceStr,cityStr,districtStr];
    resultsCode = [NSString stringWithFormat:@"%@,%@,%@",sheng.code,shi.code,xian.code];

}

-(void)uiConfiguer{
    _bageView= [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN.height, SCREEN.width, 260)];
    _bageView.backgroundColor=[UIColor colorWithRed: arc4random_uniform(256)/255.0f green: arc4random_uniform(256)/255.0f blue: arc4random_uniform(256)/255.0f alpha:1];
    _bageView.backgroundColor = [UIColor whiteColor];
    _bageView.userInteractionEnabled=YES;
    [self addSubview:_bageView];
    
    UIButton * cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 5, 40, 30)];
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [_bageView addSubview:cancelBtn];
    
    UIButton * completeBtn=[[UIButton alloc]initWithFrame:CGRectMake( SCREEN.width-50, 5, 40, 30)];
    [completeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [_bageView addSubview:completeBtn];
    
    cityPickerView=[[UIPickerView alloc]init];
    cityPickerView.frame=CGRectMake(0, completeBtn.bottom+5, SCREEN.width, _bageView.height-completeBtn.bottom-5);
    cityPickerView.delegate=self;
    cityPickerView.dataSource=self;
    cityPickerView.backgroundColor=[UIColor whiteColor];
    [_bageView addSubview:cityPickerView];
    
    
}

//  设置对应的字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN.width-30)/3,40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component]; // 数据源
    return label;
}
-(void)btnClicked:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self dismis];
    } else {
        if (self.CityBlock) {
            self.CityBlock(resultsStr, resultsCode);
             [self dismis];
        }
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
//多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger result=0;
    if (component == 0) {
        result= section1.count;
    }
    else if (component== 1){
        result= section2.count;
    }
    else if (component== 2){
        result= section3.count;
    }
    
    return result;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    
    if (component ==0 ) {
        ProvinceModel * prModel = section1[row];
        title = prModel.name;

    }
    else if (component== 1){
        CityModel * cModel = section2[row];
        title = cModel.name;
    
    }
    else if (component== 2){
        DistrictModel * disModel = section3[row];
        title = disModel.name;
    }

    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //滚动一区的时候
    if (component==0) {
        ProvinceModel *Prmodel =section1[row];
        section2=Prmodel.list;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        CityModel * ciModel = section2[0];
        section3=ciModel.list;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

        
      //滚动二区的时候
    } else if (component==1) {
        CityModel * ciModel = section2[row];
        section3=ciModel.list;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }
    [self setModelComponent:component Row:row];
    
    
}
- (void)setModelComponent:(NSInteger)component Row:(NSInteger)row {
    if (component == 0) {
        ProvinceModel *Prmodel =section1[row];
        CityModel * ciModel = Prmodel.list.firstObject;
        //省
        provinceStr =Prmodel.name;
        provinceCode = Prmodel.code;
        //市
        cityStr=ciModel.name;
        cityCode = ciModel.code;
        //xian
        DistrictModel *model3 =ciModel.list.firstObject;
        districtStr=model3.name;
        districtCode = model3.code;
    } else if (component==1) {
        
        CityModel * ciModel = section2[row];
        //市
        cityStr=ciModel.name;
        cityCode = ciModel.code;
        //县
        DistrictModel *model3 =ciModel.list.firstObject;
        districtStr=model3.name;
        districtCode = model3.code;

    } else {
        //县
        DistrictModel *model3 =section3[row];
        districtStr=model3.name;
        districtCode = model3.code;
    }
    resultsStr=[NSString stringWithFormat:@"%@,%@,%@",provinceStr,cityStr,districtStr];
    resultsCode = [NSString stringWithFormat:@"%@,%@,%@",provinceCode,cityCode,districtCode];
}
- (void)show {
    self.frame=[UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.bageView.top=SCREEN.height-self.bageView.height;
    }];
}
- (void)dismis {
    [UIView animateWithDuration:0.3 animations:^{
        self.bageView.top=SCREEN.height;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end
