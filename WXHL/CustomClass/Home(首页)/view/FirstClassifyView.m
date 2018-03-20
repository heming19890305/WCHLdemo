//
//  FirstClassifyView.m
//  LookPicture
//
//  Created by 胡青月 on 2017/8/2.
//  Copyright © 2017年 胡青月. All rights reserved.
//

#import "FirstClassifyView.h"


@interface FirstClassifyView ()<UIScrollViewDelegate>

@end

@implementation FirstClassifyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 加入分类数据
- (void) addClassifyDataToView:(NSArray *) dataArray {
    int lie = dataArray.count % 3 == 0 ? (int)dataArray.count / 3 : (int)dataArray.count / 3 + 1;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_TO(208))];
    self.scrollView.userInteractionEnabled = YES;
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * (lie - 1), 0)];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    if (self.type == 1) {
        self.scrollView.scrollEnabled = NO;
        [self.scrollView setHeight:HEIGHT_TO(312)];
    }
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < lie; j ++) {
            if (j == 2) {
                if (self.type != 1) {
                    UIView * bgView = [[UIView alloc] init];
                    bgView.backgroundColor = [UIColor whiteColor];
                    bgView.layer.borderColor = lineColor.CGColor;
                    bgView.layer.borderWidth = 0.5;
                    bgView.userInteractionEnabled = YES;
                    [self.scrollView addSubview:bgView];
                    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.scrollView).offset(0);
                        make.left.equalTo(self.scrollView).offset(i * (SCREENWIDTH / 3) + SCREEN_WIDTH);
                        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH / 3, HEIGHT_TO(104)));
                    }];
                    UIImageView * img = [[UIImageView alloc] init];
                    img.image = [UIImage imageNamed:dataArray[j * 3 + i]];
                    img.layer.cornerRadius = HEIGHT_TO(25);
                    img.userInteractionEnabled = YES;
                    img.layer.masksToBounds = YES;
                    [bgView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(bgView).offset(HEIGHT_TO(11.5));
                        make.centerX.equalTo(bgView);
                        make.size.mas_equalTo(HEIGHT_TO(50));
                    }];
                    UILabel * titleLab = [[UILabel alloc] init];
                    titleLab.font = [UIFont fontWithPx:30];
                    titleLab.textColor = [UIColor colorWithHex:@"292929"];
                    titleLab.text = dataArray[j * 3 + i];
                    titleLab.userInteractionEnabled = YES;
                    titleLab.textAlignment = NSTextAlignmentCenter;
                    [bgView addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(bgView);
                        make.top.equalTo(img.mas_bottom).offset(HEIGHT_TO(10));
                        make.left.equalTo(bgView.mas_left).with.offset(0);
                        make.right.equalTo(bgView.mas_right).with.offset(0);
                    }];
                    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.backgroundColor = [UIColor clearColor];
                    btn.userInteractionEnabled = YES;
                    [btn addTarget:self action:@selector(classifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag = 400 + j * 3 + i;
                    [bgView addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];

                }else{
                    if (j * 3 + i > dataArray.count - 1) {
                        
                    }else{
                        
                        UIView * bgView = [[UIView alloc] init];
                        bgView.backgroundColor = [UIColor whiteColor];
                        bgView.layer.borderColor = lineColor.CGColor;
                        bgView.layer.borderWidth = 0.5;
                        bgView.userInteractionEnabled = YES;
                        [self.scrollView addSubview:bgView];
                        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.scrollView).offset(j * HEIGHT_TO(104));
                            make.left.equalTo(self.scrollView).offset(i * (SCREENWIDTH / 3));
                            make.size.mas_equalTo(CGSizeMake(SCREENWIDTH / 3, HEIGHT_TO(104)));
                        }];
                        UIImageView * img = [[UIImageView alloc] init];
                        img.userInteractionEnabled = YES;
                        img.image = [UIImage imageNamed:dataArray[j * 3 + i]];
                        img.layer.cornerRadius = HEIGHT_TO(25);
                        //                    img.layer.masksToBounds = YES;
                        [bgView addSubview:img];
                        [img mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(bgView).offset(HEIGHT_TO(11.5));
                            make.centerX.equalTo(bgView);
                            make.size.mas_equalTo(HEIGHT_TO(50));
                        }];
                        UILabel * titleLab = [[UILabel alloc] init];
                        titleLab.font = [UIFont fontWithPx:30];
                        titleLab.textColor = [UIColor colorWithHex:@"292929"];
                        titleLab.text = dataArray[j * 3 + i];
                        titleLab.userInteractionEnabled = YES;
                        titleLab.textAlignment = NSTextAlignmentCenter;
                        [bgView addSubview:titleLab];
                        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(bgView);
                            make.top.equalTo(img.mas_bottom).offset(HEIGHT_TO(10));
                            make.left.equalTo(bgView.mas_left).with.offset(0);
                            make.right.equalTo(bgView.mas_right).with.offset(0);
                        }];
                        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.userInteractionEnabled = YES;
                        btn.backgroundColor = [UIColor clearColor];
                        [btn addTarget:self action:@selector(classifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = 400 + j * 3 + i;
                        
                        
                        [bgView addSubview:btn];
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
                        }];
                    }

                }
                
            }else{
                if (j * 3 + i > dataArray.count - 1) {
                    
                }else{
                    
                    UIView * bgView = [[UIView alloc] init];
                    bgView.backgroundColor = [UIColor whiteColor];
                    bgView.layer.borderColor = lineColor.CGColor;
                    bgView.layer.borderWidth = 0.5;
                    bgView.userInteractionEnabled = YES;
                    [self.scrollView addSubview:bgView];
                    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.scrollView).offset(j * HEIGHT_TO(104));
                        make.left.equalTo(self.scrollView).offset(i * (SCREENWIDTH / 3));
                        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH / 3, HEIGHT_TO(104)));
                    }];
                    UIImageView * img = [[UIImageView alloc] init];
                    img.userInteractionEnabled = YES;
                    img.image = [UIImage imageNamed:dataArray[j * 3 + i]];
                    img.layer.cornerRadius = HEIGHT_TO(25);
//                    img.layer.masksToBounds = YES;
                    [bgView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(bgView).offset(HEIGHT_TO(11.5));
                        make.centerX.equalTo(bgView);
                        make.size.mas_equalTo(HEIGHT_TO(50));
                    }];
                    UILabel * titleLab = [[UILabel alloc] init];
                    titleLab.font = [UIFont fontWithPx:30];
                    titleLab.textColor = [UIColor colorWithHex:@"292929"];
                    titleLab.text = dataArray[j * 3 + i];
                    titleLab.userInteractionEnabled = YES;
                    titleLab.textAlignment = NSTextAlignmentCenter;
                    [bgView addSubview:titleLab];
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(bgView);
                        make.top.equalTo(img.mas_bottom).offset(HEIGHT_TO(10));
                        make.left.equalTo(bgView.mas_left).with.offset(0);
                        make.right.equalTo(bgView.mas_right).with.offset(0);
                    }];
                    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.userInteractionEnabled = YES;
                    btn.backgroundColor = [UIColor clearColor];
                    [btn addTarget:self action:@selector(classifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag = 400 + j * 3 + i;
                    

                    [bgView addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                }
            }
        }
    }
    if (_isshowPage) {
        [self setpageCon];
    }
    
}

#pragma mark - 添加分页
-(void)setpageCon{
    self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, HEIGHT_TO(208) - 20, 60, 20)];
    self.pageC.numberOfPages = 2;
    self.pageC.currentPage = 0;
    self.pageC.pageIndicatorTintColor = [UIColor grayColor];
    self.pageC.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:self.pageC];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x) {
        self.pageC.currentPage = 1;
    }else{
        self.pageC.currentPage = 0;
    }
}


#pragma mark - 分类按钮点击
- (void)classifyButtonClicked:(UIButton *)sender {
    int num = (int)sender.tag - 400;
    NSLog(@"分类按钮点击 - %d",num);
    if (self.ClassifyButtonClicked) {
        self.ClassifyButtonClicked(num);
    }
}




@end
