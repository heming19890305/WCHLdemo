/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "BaseViewController.h"


@interface BaseViewController ()




@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.alpha = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:self.titleView];
}


-(UIView *)titleView{
    if(!_titleView){
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _titleView.backgroundColor = MAINCOLOR;
        [self.view addSubview:_titleView];
        
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        [self.titleLable textFont:18 textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
        self.titleLable.text = self.baseTitle;
        [_titleView addSubview:self.titleLable];
        
        self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,20,44, 44)];
        [self.backBtn setImage:ImageNamed(@"basebackbtn") forState:0];
        [self.backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:self.backBtn];
        self.backBtn.hidden = self.backBtnIsHiden;
        
        self.firstRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        //[_titleView addSubview:self.firstRightBtn];
        
        self.secondRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_titleView addSubview:self.secondRightBtn];
        
        _titleView.hidden = !self.titleViewIsShow;
    }
    return _titleView;
}
//设置是否影藏标题视图
-(void)setTitleViewIsShow:(BOOL)titleViewIsShow{
    _titleViewIsShow = titleViewIsShow;
    self.titleView.hidden = !titleViewIsShow;
}

//设置是否影藏返回按钮
-(void)setBackBtnIsHiden:(BOOL)backBtnIsHiden{
    _backBtnIsHiden = backBtnIsHiden;
    self.backBtn.hidden = backBtnIsHiden;
}
//设置显示标题
-(void)setBaseTitle:(NSString *)baseTitle{

    _baseTitle = baseTitle;
    self.titleLable.text = baseTitle;
}
//返回事件
- (void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIButton *)addFirstRightBtn:(NSString *)title hightTile:(NSString *)hightTile fontsize:(CGFloat)fontsize fontcolor:(UIColor *)color Image:(NSString *)image hightImage:(NSString *)hightImage{
    
    self.firstRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstRightBtn setTitleColor:color forState:UIControlStateNormal];
    self.firstRightBtn.titleLabel.font = FontWithSize(fontsize);
    
    if(title.length>0){
        [self.firstRightBtn setTitle:title forState:UIControlStateNormal];
    }
    if(hightTile.length>0){
        [self.firstRightBtn setTitle:hightTile forState:UIControlStateHighlighted];
    }
    if(image.length>0){
        [self.firstRightBtn setImage:ImageNamed(image) forState:UIControlStateNormal];
    }
    if(hightImage.length>0){
        [self.firstRightBtn setImage:ImageNamed(hightImage) forState:UIControlStateHighlighted];
    }
    CGFloat with = [self fetchBtnWithWithTitle:([title length]>[hightTile length]?title:hightTile) Font:fontsize hasImage:[image length]>0];
    self.firstRightBtn.frame = CGRectMake(SCREEN_WIDTH-with-10, 20, with, 44);
    return self.firstRightBtn;
}

-(UIButton *)addSecondRightBtn:(NSString *)title hightTile:(NSString *)hightTile fontsize:(CGFloat)fontsize fontcolor:(UIColor *)color Image:(NSString *)image hightImage:(NSString *)hightImage{
    
    [self.secondRightBtn setTitleColor:color forState:UIControlStateNormal];
    self.secondRightBtn.titleLabel.font = FontWithSize(fontsize);
    
    if(title.length>0){
        [self.secondRightBtn setTitle:title forState:UIControlStateNormal];
    }
    if(hightTile.length>0){
        [self.secondRightBtn setTitle:hightTile forState:UIControlStateHighlighted];
    }
    if(image.length>0){
        [self.secondRightBtn setImage:ImageNamed(image) forState:UIControlStateNormal];
    }
    if(hightImage.length>0){
        [self.secondRightBtn setImage:ImageNamed(hightImage) forState:UIControlStateHighlighted];
    }
    CGFloat with = [self fetchBtnWithWithTitle:([title length]>[hightTile length]?title:hightTile) Font:fontsize hasImage:[image length]>0];
    self.secondRightBtn.frame = CGRectMake(SCREEN_WIDTH-with-20-self.firstRightBtn.width, 20, with, 44);
    return self.secondRightBtn;
}

-(void)addBackLeftBtn:(NSString *)title hightTile:(NSString *)hightTile fontsize:(CGFloat)fontsize fontcolor:(UIColor *)color Image:(NSString *)image hightImage:(NSString *)hightImage{
    
    [self.backBtn setTitleColor:color forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = FontWithSize(fontsize);
    
    if(title.length>0){
        [self.backBtn setTitle:title forState:UIControlStateNormal];
    }
    if(hightTile.length>0){
        [self.backBtn setTitle:hightTile forState:UIControlStateHighlighted];
    }
    if(image.length>0){
        [self.backBtn setImage:ImageNamed(image) forState:UIControlStateNormal];
    }
    if(hightImage.length>0){
        [self.backBtn setImage:ImageNamed(hightImage) forState:UIControlStateHighlighted];
    }
    CGFloat with = [self fetchBtnWithWithTitle:([title length]>[hightTile length]?title:hightTile) Font:fontsize hasImage:[image length]>0];
    self.backBtn.frame = CGRectMake(0, 20, with, 44);
    if(self.titleViewIsShow){//显示导航栏
        [self.titleView addSubview:self.backBtn];
    }else{//不显示//加到当前view
        [self.backBtn removeFromSuperview];
        self.backBtn.hidden = NO;
        [self.view addSubview:self.backBtn];
    }
}


-(CGFloat)fetchBtnWithWithTitle:(NSString *)title Font:(CGFloat)fontSize hasImage:(BOOL)hasImage{
    NSDictionary *attributes = @{NSFontAttributeName:FontWithSize(fontSize)};
    CGFloat length = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    if(hasImage)
    {
        length += 20;
    }
    length+=5;//空隙
    return length;
}



@end
