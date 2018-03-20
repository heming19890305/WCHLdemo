//
//  ZSHomeScrollBannerView.m
//  LookPicture
//
//  Created by ZS on 2017/9/12.
//  Copyright © 2017年 龙泉舟. All rights reserved.
//

#import "ZSHomeScrollBannerView.h"

@implementation ZSHomeScrollBannerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    
    self.view1 = [[UIView alloc]init];
    self.view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.view1];
    self.view1.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(HEIGHT_TO(33.33));
    
    self.view2 = [[UIView alloc]init];
    self.view2.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.view2];
    self.view2.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self.view1, 0)
    .heightIs(HEIGHT_TO(33.33));
    
    self.view3 = [[UIView alloc]init];
    self.view3.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.view3];
    self.view3.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self.view2, 0)
    .heightIs(HEIGHT_TO(33.33));
    
    UIImageView *notifiImgaeView = [[UIImageView alloc]init];
    notifiImgaeView.image = ImageNamed(@"通知");
    notifiImgaeView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view1 addSubview:notifiImgaeView];
    notifiImgaeView.sd_layout
    .leftSpaceToView(self.view1, WIDTH_TO(15))
    .centerYEqualToView(self.view1)
    .widthIs(15)
    .heightIs(17);
    
    UIImageView *announceImageView = [[UIImageView alloc]init];
    announceImageView.image = ImageNamed(@"公告");
    announceImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view2 addSubview:announceImageView];
    announceImageView.sd_layout
    .leftSpaceToView(self.view2, WIDTH_TO(15))
    .centerYEqualToView(self.view2)
    .widthIs(15)
    .heightIs(17);
    
    UIImageView *publicityImageView = [[UIImageView alloc]init];
    publicityImageView.image = ImageNamed(@"公示");
    publicityImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view3 addSubview:publicityImageView];
    publicityImageView.sd_layout
    .leftSpaceToView(self.view3, WIDTH_TO(15))
    .centerYEqualToView(self.view3)
    .widthIs(15)
    .heightIs(17);
    
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(globalQueue, ^{
        NSMutableArray *array = [NSMutableArray arrayWithObjects:@"通知：暂时没有通知",nil];
        self.notifyScrollView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(WIDTH_TO(40), 0, SCREEN_WIDTH - WIDTH_TO(40) - WIDTH_TO(10), HEIGHT_TO(33.33))];
        [self.notifyScrollView animationWithTexts:array];
        self.notifyScrollView.delegate = self;
        [self.view1 addSubview:self.notifyScrollView];
        
        NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"公告：暂时没有公告", nil];
        self.announceScrollView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(WIDTH_TO(40), 0, SCREEN_WIDTH - WIDTH_TO(40) - WIDTH_TO(10), HEIGHT_TO(33.33))];;
        [self.announceScrollView animationWithTexts:array1];
        self.announceScrollView.delegate = self;
        [self.view2 addSubview:self.announceScrollView];
        
        NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"公示：暂时没有公示", nil];
        self.publicityScrollView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(WIDTH_TO(40), 0, SCREEN_WIDTH - WIDTH_TO(40) - WIDTH_TO(10), HEIGHT_TO(33.33))];
        [self.publicityScrollView animationWithTexts:array2];
        self.publicityScrollView.delegate = self;
        [self.view3 addSubview:self.publicityScrollView];
    });
}

-(void)zsChangeTextView:(ScrollLabelView *)textView didTapedAtIndex:(NSInteger)index withDataArray:(NSArray *)dataArray{
//    self.fffVC.na
}

-(void)setDataSource:(NSArray *)textArray{
    
    [self.publicityScrollView removeFromSuperview];
    self.publicityScrollView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(WIDTH_TO(25), 0, SCREEN_WIDTH - WIDTH_TO(25) - WIDTH_TO(10), HEIGHT_TO(33.33))];
    self.publicityScrollView.delegate = self;
    self.publicityScrollView.dataArray = self.dataArray;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSString *str in textArray) {
        [mutableArray addObject:[NSString stringWithFormat:@"公示:%@",str]];
    }
    [self.publicityScrollView animationWithTexts:mutableArray];
    [self.view3 addSubview:self.publicityScrollView];
    
}

-(void)setDataWithInformList:(NSArray *)array{
    
    [self.notifyScrollView removeFromSuperview];
    self.notifyScrollView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(WIDTH_TO(25), 0, SCREEN_WIDTH - WIDTH_TO(25) - WIDTH_TO(10), HEIGHT_TO(33.33))];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSString *str in array) {
        [mutableArray addObject:[NSString stringWithFormat:@"通知:%@",str]];
    }
    [self.notifyScrollView animationWithTexts:mutableArray];
    self.notifyScrollView.dataArray = self.dataArray;
    self.notifyScrollView.delegate = self;
    [self.view1 addSubview:self.notifyScrollView];
}

-(void)setDataWithNoticeList:(NSArray *)array{

    [self.announceScrollView removeFromSuperview];
    self.announceScrollView = [[ScrollLabelView alloc]initWithFrame:CGRectMake(WIDTH_TO(25), 0, SCREEN_WIDTH - WIDTH_TO(25) - WIDTH_TO(10), HEIGHT_TO(33.33))];
    self.announceScrollView.delegate = self;
    self.announceScrollView.dataArray = self.dataArray;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSString *str in array) {
        [mutableArray addObject:[NSString stringWithFormat:@"公告:%@",str]];
    }
    [self.announceScrollView animationWithTexts:mutableArray];
    [self.view2 addSubview:self.announceScrollView];
}

@end
