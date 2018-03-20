//
//  ZWHDoodsHeaderView.m
//  WXHL
//
//  Created by Syrena on 2017/11/13.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHDoodsHeaderView.h"

@interface ZWHDoodsHeaderView()<SDCycleScrollViewDelegate>

@end

@implementation ZWHDoodsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];
    }
    return self;
}

-(void)setC2fmodel:(ZWHGoodsModel *)c2fmodel{
    _c2fmodel = c2fmodel;
    if ([_c2fmodel.masterImg length]>0) {
        NSArray *imga = [_c2fmodel.masterImg componentsSeparatedByString:@";"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *str in imga) {
            [array addObject:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],str]];
        }
        _topScro.imageURLStringsGroup = array;
    }
    _name.text = _c2fmodel.name;
    _newprice.text = [NSString stringWithFormat:@"¥%@",_c2fmodel.salePrice];
    _oldprice.text = [NSString stringWithFormat:@"价格¥%@",_c2fmodel.price];
    _work.text = _c2fmodel.score==nil?@"0":_c2fmodel.score;
    
    NSString *label_text2 = [NSString stringWithFormat:@"今日成交%@笔",_c2fmodel.daySaleNum];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSFontAttributeName value:FontWithSize(12) range:NSMakeRange(0, label_text2.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"999999") range:NSMakeRange(0, 4)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"ff5555") range:NSMakeRange(4, label_text2.length - 5)];
    _daynum.attributedText = attributedString2;
    
    NSString *label_text3 = [NSString stringWithFormat:@"累计成交%@笔",_c2fmodel.totalSaleNum];
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:label_text3];
    [attributedString3 addAttribute:NSFontAttributeName value:FontWithSize(12) range:NSMakeRange(0, label_text3.length)];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"999999") range:NSMakeRange(0, 4)];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"ff5555") range:NSMakeRange(4, label_text3.length - 5)];
    _sumnum.attributedText = attributedString3;
}

-(void)setModel:(ZWHGoodsModel *)model{
    _model = model;
    if ([_model.goodsImgs length]>0) {
        NSArray *imga = [_model.goodsImgs componentsSeparatedByString:@";"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *str in imga) {
            [array addObject:[NSString stringWithFormat:@"%@%@",[UserManager fileSer],str]];
        }
        _topScro.imageURLStringsGroup = array;
    }
    _name.text = _model.name;
    _newprice.text = [NSString stringWithFormat:@"¥%@",_model.nowPrice];
    _oldprice.text = [NSString stringWithFormat:@"价格¥%@",_model.price];
    _work.text = _model.giveScore==nil?@"0":_model.giveScore;
    
    NSString *label_text2 = [NSString stringWithFormat:@"今日成交%@笔",_model.curSaleNum];
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSFontAttributeName value:FontWithSize(12) range:NSMakeRange(0, label_text2.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"999999") range:NSMakeRange(0, 4)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"ff5555") range:NSMakeRange(4, label_text2.length - 5)];
    _daynum.attributedText = attributedString2;
    
    NSString *label_text3 = [NSString stringWithFormat:@"累计成交%@笔",_model.saleNum];
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:label_text3];
    [attributedString3 addAttribute:NSFontAttributeName value:FontWithSize(12) range:NSMakeRange(0, label_text3.length)];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"999999") range:NSMakeRange(0, 4)];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"ff5555") range:NSMakeRange(4, label_text3.length - 5)];
    _sumnum.attributedText = attributedString3;
    
}

-(void)creatView{
    [self addSubview:self.topScro];
    self.name = [[UILabel alloc]init];
    [_name textFont:16 textColor:ZWHCOLOR(@"333333") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _name.text = @"贵州酒魂酒魂酒魂酒魂";
    [self addSubview:_name];
    _name.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(self.topScro, HEIGHT_TO(20))
    .rightSpaceToView(self, WIDTH_TO(15))
    .autoHeightRatio(0);
    [_name setMaxNumberOfLinesToShow:1];
    
    _newprice = [[UILabel alloc]init];
    [_newprice textFont:16 textColor:ZWHCOLOR(@"ff5555") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _newprice.text = @"¥980";
    [self addSubview:_newprice];
    _newprice.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(_name, HEIGHT_TO(14))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    
    _oldprice = [[UILabel alloc]init];
    [_oldprice textFont:12 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _oldprice.text = @"价格¥1980";
    [self addSubview:_oldprice];
    _oldprice.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(_newprice, HEIGHT_TO(7))
    .autoHeightRatio(0)
    .widthIs(WIDTH_TO(150));
    
    UILabel *lab = [[UILabel alloc]init];
    [lab textFont:14 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    lab.text = @"工分(元)";
    [self addSubview:lab];
    lab.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .autoHeightRatio(0)
    .centerYEqualToView(_newprice);
    
    [lab setSingleLineAutoResizeWithMaxWidth:100];
    [lab updateLayout];
    
    _work = [[UILabel alloc]init];
    [_work textFont:12 textColor:ZWHCOLOR(@"ff5555") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    _work.text = @"480";
    [self addSubview:_work];
    _work.sd_layout
    .rightSpaceToView(lab, 0)
    .centerYEqualToView(lab)
    .autoHeightRatio(0);
    
    [_work setSingleLineAutoResizeWithMaxWidth:100];
    [_work updateLayout];
    
    
    UILabel *zhen = [[UILabel alloc]init];
    [zhen textFont:12 textColor:[UIColor whiteColor] backgroundColor:ZWHCOLOR(@"ff5555") textAlignment:NSTextAlignmentRight];
    zhen.text = @"赠";
    [self addSubview:zhen];
    zhen.sd_layout
    .rightSpaceToView(_work, 0)
    .centerYEqualToView(lab)
    .autoHeightRatio(0);
    [zhen setSingleLineAutoResizeWithMaxWidth:100];
    [zhen updateLayout];
    zhen.layer.cornerRadius = zhen.bounds.size.width/2;
    zhen.layer.masksToBounds = YES;
    
    _daynum = [[UILabel alloc]init];
    [_daynum textFont:12 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    NSString *label_text2 = @"今日成交23笔";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSFontAttributeName value:FontWithSize(12) range:NSMakeRange(0, label_text2.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"999999") range:NSMakeRange(0, 4)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"ff5555") range:NSMakeRange(4, label_text2.length - 5)];
    _daynum.attributedText = attributedString2;
    [self addSubview:_daynum];
    _daynum.sd_layout
    .leftSpaceToView(self, WIDTH_TO(15))
    .topSpaceToView(_oldprice, HEIGHT_TO(10))
    .autoHeightRatio(0);
    [_daynum setSingleLineAutoResizeWithMaxWidth:150];
    [_daynum updateLayout];
    
    
    _sumnum = [[UILabel alloc]init];
    [_sumnum textFont:12 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    NSString *label_text3 = @"累计成交28371827笔";
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:label_text3];
    [attributedString3 addAttribute:NSFontAttributeName value:FontWithSize(12) range:NSMakeRange(0, label_text3.length)];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"999999") range:NSMakeRange(0, 4)];
    [attributedString3 addAttribute:NSForegroundColorAttributeName value:ZWHCOLOR(@"ff5555") range:NSMakeRange(4, label_text3.length - 5)];
    _sumnum.attributedText = attributedString3;
    [self addSubview:_sumnum];
    _sumnum.sd_layout
    .leftSpaceToView(_daynum, WIDTH_TO(52))
    .centerYEqualToView(_daynum)
    .autoHeightRatio(0);
    [_sumnum setSingleLineAutoResizeWithMaxWidth:150];
    [_sumnum updateLayout];
    
    
    _freight = [[UILabel alloc]init];
    [_freight textFont:12 textColor:ZWHCOLOR(@"999999") backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight];
    _freight.text = @"运费 买家承担";
    [self addSubview:_freight];
    _freight.sd_layout
    .rightSpaceToView(self, WIDTH_TO(15))
    .centerYEqualToView(_daynum)
    .autoHeightRatio(0);
    [_freight setSingleLineAutoResizeWithMaxWidth:150];
    [_freight updateLayout];
    
    _freight.hidden = YES;

    
    
    
    
    
    CGFloat y = CGRectGetMaxY(_daynum.frame);
    self.frame = CGRectMake(0, 0, SCREENWIDTH, y+HEIGHT_TO(15));
    
    

}

-(SDCycleScrollView *)topScro{
    if (!_topScro) {
        NSArray *array = @[@"logo"];
        _topScro = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_PRO(375)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _topScro.delegate = self;
        _topScro.localizationImageNamesGroup = array;
        _topScro.backgroundColor = [UIColor whiteColor];
        _topScro.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _topScro.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _topScro.pageControlBottomOffset = HEIGHT_TO(7);
        _topScro.pageControlDotSize = CGSizeMake(WIDTH_PRO(7.5), HEIGHT_PRO(7));
        _topScro.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _topScro.currentPageDotColor = MAINCOLOR;
        _topScro.pageDotColor = [UIColor whiteColor];
    }
    return _topScro;
}

@end
