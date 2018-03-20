//
//  ZSNorTableHeaderView.m
//  KPH
//
//  Created by 赵升 on 2017/6/9.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "ZSNorTableHeaderView.h"
#import "YYTimer.h"
@interface ZSNorTableHeaderView()

@property(nonatomic,assign)NSInteger timeCount;
@property (nonatomic, strong) YYTimer *timer;
@end


@implementation ZSNorTableHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

-(void)setDict:(NSDictionary *)dict{
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",dict[@"price"]];
    self.chooseNor.text = [NSString stringWithFormat:@"库存%@件",dict[@"stock"]];
}


- (void)createView{
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topView];
    self.topView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(HEIGHT_PRO(30));
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    self.bottomView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self.topView, HEIGHT_TO(30))
    .bottomEqualToView(self);
    
    self.goodsImageView = [[UIImageView alloc]initWithImage:ImageNamed(@"logo")];
    //self.goodsImageView.image = ImageNamed(@"已收藏");
    self.goodsImageView.clipsToBounds = YES;
    self.goodsImageView.layer.cornerRadius = 8;
    self.goodsImageView.layer.borderWidth = 1;
    self.goodsImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:self.goodsImageView];
    self.goodsImageView.sd_layout
    .leftSpaceToView(self, 15)
    .topEqualToView(self)
    .widthIs(WIDTH_PRO(135))
    .heightIs(HEIGHT_PRO(130));
    
    self.chooseNor = [[UILabel alloc]init];
    self.chooseNor.text = @"请选择规格";
    [self.chooseNor textFont:WIDTH_PRO(14) textColor:[ZSColor hexStringToColor:@"323232"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.chooseNor];
    self.chooseNor.sd_layout
    .leftSpaceToView(self.goodsImageView, 15)
    .bottomEqualToView(self.goodsImageView)
    .heightIs(15)
    .widthIs(120);
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.text = @"¥0.00";
    [self.priceLabel textFont:WIDTH_PRO(16) textColor:[ZSColor hexStringToColor:@"ff3232"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.priceLabel];
    self.priceLabel.sd_layout
    .leftEqualToView(self.chooseNor)
    .bottomSpaceToView(self.chooseNor, HEIGHT_PRO(13))
    .heightIs(20);
    [self.priceLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.oldpriceLabel = [[UILabel alloc]init];
    self.oldpriceLabel.text = @"";
    [self.oldpriceLabel textFont:WIDTH_PRO(12) textColor:TIMECOLOR backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.oldpriceLabel];
    self.oldpriceLabel.sd_layout
    .leftSpaceToView(self.priceLabel, 4)
    .centerYEqualToView(self.priceLabel)
    .heightIs(20);
    [self.oldpriceLabel setSingleLineAutoResizeWithMaxWidth:100];

    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:ImageNamed(@"delete") forState:0];
    [self.bottomView addSubview:self.closeBtn];
    self.closeBtn.sd_layout
    .rightSpaceToView(self.bottomView, HEIGHT_TO(10))
    .topSpaceToView(self.bottomView, HEIGHT_TO(10))
    .heightIs(HEIGHT_TO(20))
    .widthIs(HEIGHT_TO(20));
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = GRAYBACKCOLOR;
    [self addSubview:view];
    view.sd_layout
    .bottomEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(1);
    [self.priceLabel updateLayout];
    [self.oldpriceLabel updateLayout];
    
}

/*-(void)setModel:(KJProductModel *)model{
    _model = model;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_HOST,model.img]] placeholderImage:ImageNamed(DefautImageName)];
    
    NSString * nowPrice = [NSString stringWithFormat:@"¥%.2f",[model.nowPrice doubleValue]];
    NSString * oldPrice = [NSString stringWithFormat:@"¥%.2f",[model.oldPrice doubleValue]];
    
    self.timer = nil;
    if([model.activityType isEqualToString:@"pt"]){
        
        self.priceLabel.sd_resetLayout
        .bottomSpaceToView(self.chooseNor, 0)
        .leftEqualToView(self.chooseNor)
        .heightIs(20);
        self.oldpriceLabel.sd_resetLayout
        .leftSpaceToView(self.priceLabel, 4)
        .bottomEqualToView(self.priceLabel)
        .heightIs(20);
        
        [self showPrice:nowPrice OldPrice:@""];
        
        self.chooseNor.hidden = YES;
        self.chooseNor.text = @"";
        
    }else if([model.activityType isEqualToString:@"tj"]){
        
        self.priceLabel.sd_resetLayout
        .bottomSpaceToView(self.chooseNor, 0)
        .leftEqualToView(self.chooseNor)
        .heightIs(20);
        self.oldpriceLabel.sd_resetLayout
        .leftSpaceToView(self.priceLabel, 4)
        .bottomEqualToView(self.priceLabel)
        .heightIs(20);
        
        [self showPrice:nowPrice OldPrice:oldPrice];
        self.chooseNor.hidden = YES;
        self.chooseNor.text = @"";
        
    }else if([model.activityType isEqualToString:@"ms"]){
        
        self.priceLabel.sd_resetLayout
        .leftEqualToView(self.chooseNor)
        .bottomSpaceToView(self.chooseNor, HEIGHT_PRO(13))
        .heightIs(20);
        self.oldpriceLabel.sd_resetLayout
        .leftSpaceToView(self.priceLabel, 4)
        .bottomEqualToView(self.priceLabel)
        .heightIs(20);
        [self showPrice:nowPrice OldPrice:oldPrice];
        self.chooseNor.hidden = NO;
        [self fetchTimeCount:model];
        
    }else if([model.activityType isEqualToString:@"kp"]){
        
        self.priceLabel.sd_resetLayout
        .leftEqualToView(self.chooseNor)
        .bottomSpaceToView(self.chooseNor, HEIGHT_PRO(13))
        .heightIs(20);
        self.oldpriceLabel.sd_resetLayout
        .leftSpaceToView(self.priceLabel, 4)
        .bottomEqualToView(self.priceLabel)
        .heightIs(20);
        
        [self showPrice:nowPrice OldPrice:oldPrice];
        self.chooseNor.hidden = NO;
        self.chooseNor.text = [NSString stringWithFormat:@"参团人数：%ld人团",[model.astrict integerValue]];
        
    }*/
//    [self.priceLabel updateLayout];
//    [self.oldpriceLabel updateLayout];

//    if([model.repertory integerValue] <= 0){
//        self.chooseNor.text = @"无货";
//    }
//}


-(void)showPrice:(NSString *)nowPrice OldPrice:(NSString *)oldPrice{
    
    self.priceLabel.text = nowPrice;
    
    NSMutableAttributedString*hintString=[[NSMutableAttributedString alloc]initWithString:oldPrice];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:TIMECOLOR range:NSMakeRange(hintString.length-oldPrice.length, oldPrice.length)];
    [hintString addAttribute:NSFontAttributeName value:FontWithSize(WIDTH_PRO(14)) range:NSMakeRange(hintString.length-oldPrice.length, oldPrice.length)];
    [hintString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:1] range:NSMakeRange(hintString.length-oldPrice.length, oldPrice.length)];
    
    self.oldpriceLabel.attributedText=hintString;
}




/*-(void)fetchTimeCount:(KJProductModel *)model{
    //结束时间
    NSString *endTime = [self changeTimeToString:model.endTime];
    //当前时间
    NSString *startTime = [self getCurrentTime];
    
    NSString *nowTime = [self changeTimeToString:startTime];
    
    NSInteger remainTime = endTime.integerValue - nowTime.integerValue;
    
    self.timeCount = remainTime;//剩余豪秒数
    
    if(self.timeCount>0){
        self.chooseNor.text = [NSString stringWithFormat:@"距结束还有：%02zd天%02zd:%02zd:%02zd",(_timeCount/3600)/24,(_timeCount/3600)%24, (_timeCount/60)%60, _timeCount%60];
        
        self.timer = [YYTimer timerWithTimeInterval:1.0 target:self selector:@selector(cutDownClick) repeats:YES];
    }else{
        self.chooseNor.text = @"活动结束";
    }
}*/

- (void)cutDownClick{
    _timeCount--;
    if (_timeCount <= 0) {
        self.chooseNor.text = @"活动结束";
    }else{
        self.chooseNor.text = [NSString stringWithFormat:@"距结束还有：%02zd天%02zd:%02zd:%02zd",(_timeCount/3600)/24,(_timeCount/3600)%24, (_timeCount/60)%60, _timeCount%60];
    }
}
#pragma mark - 转换时间
- (NSString *)changeTimeToString:(NSString *)value{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:value];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

#pragma mark - 获取当前时间
- (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

@end
