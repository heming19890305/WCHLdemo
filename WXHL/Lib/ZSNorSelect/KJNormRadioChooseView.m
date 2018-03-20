//
//  KJNormRadioChooseView.m
//  KPH
//
//  Created by Yonger on 2017/8/3.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "KJNormRadioChooseView.h"
@interface KJNormRadioChooseView()

@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,assign)CGFloat contentViewWith;

@property (nonatomic,strong)UIButton * lastClickBtn;
@property(nonatomic,strong)NSString * selectValue;

@property (nonatomic,strong)chooseNormChange chooseBlock;
@end


@implementation KJNormRadioChooseView
-(void)didChooseNorm:(chooseNormChange)choose{
    _chooseBlock = choose;
}

-(BOOL)isSelect//是否选择
{
    if(self.selectValue.length>0){
        return YES;
    }
    return NO;
}
-(NSString *)selectValue{
    return _selectValue;
}
//初始化后，会自动计算高度，
-(instancetype)initWithFrame:(CGRect)frame Key:(NSString *)key Values:(NSArray *)values SelectValu:(NSString *)selectValue{
    self = [super initWithFrame:frame];
    if(self){
        self.key = key;
        self.values = values;
        self.selectValue = selectValue;
        [self createView];
    }
    return self;
}

-(void)createView{
    
    UILabel * titlelable = [[UILabel alloc]init];
    [titlelable textFont:WIDTH_PRO(12) textColor:[ZSColor hexStringToColor:@"434343"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:titlelable];
    titlelable.sd_layout
    .leftSpaceToView(self, WIDTH_PRO(15))
    .topSpaceToView(self, 8)
    .heightIs(20);
    titlelable.text = [NSString stringWithFormat:@"%@:",self.key];
    [titlelable setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];

    self.contentViewWith = SCREEN_WIDTH;
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0,33, self.contentViewWith, 0)];
    [self addSubview:self.contentView];
    [self addbtnToContentView];
}


-(void)addbtnToContentView{
    CGFloat w = 0;
    CGFloat h = 0;
    CGFloat ws = 15;//横向空隙
    CGFloat hs = 10;//竖向空隙
    CGFloat height = 25;//按钮高度
    CGFloat bthspace = 35;//按钮大于Title的宽度
    for (NSInteger i = 0; i < self.values.count; i++) {
        UIButton * labelButton = [[UIButton alloc]init];
        labelButton.backgroundColor = [UIColor clearColor];
        [labelButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        labelButton.backgroundColor = BACKCOLOR;
        if([self.values[i] isEqualToString:self.selectValue]){
            labelButton.selected = YES;
            self.lastClickBtn = labelButton;
            labelButton.backgroundColor =MAINCOLOR;
        }
        [labelButton setTitleColor:[ZSColor hexStringToColor:@"434343"] forState:UIControlStateNormal];
        [labelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        labelButton.tag = 1000 + i;
        
        
        [labelButton setTitle:self.values[i] forState:UIControlStateNormal];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:WIDTH_PRO(12)]};
        CGFloat length = [self.values[i] boundingRectWithSize:CGSizeMake(self.contentViewWith-bthspace, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        
        labelButton.frame = CGRectMake(ws + w, h, length + bthspace , height);
        
        if(ws + w + length + bthspace > self.contentViewWith - ws*2){
            w = 0;
            h = h + labelButton.frame.size.height + hs;
            labelButton.frame = CGRectMake(ws + w, h, length + bthspace,height);
        }
        w = labelButton.frame.size.width + labelButton.frame.origin.x;
        labelButton.titleLabel.font = [UIFont systemFontOfSize:WIDTH_PRO(12)];
        labelButton.layer.cornerRadius = 5;
        labelButton.layer.masksToBounds = YES;
        
        self.contentView.height =  labelButton.frame.origin.y + height+ hs;
        [self.contentView addSubview:labelButton];
    }
    self.height = self.contentView.mj_y + self.contentView.height;
    
    UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, SCREEN_HEIGHT, 1)];
    lineview.backgroundColor = BACKCOLOR;
    [self addSubview:lineview];
}

-(void)tagButtonClick:(UIButton *)sender{
    if(sender.tag == self.lastClickBtn.tag){
        sender.selected = !sender.selected;
    }else{
        self.lastClickBtn.selected = NO;
        self.lastClickBtn.backgroundColor = BACKCOLOR;
        sender.selected = YES;
    }
    self.lastClickBtn = sender;
    if(sender.selected){
        self.selectValue = self.values[sender.tag - 1000];
        self.lastClickBtn.backgroundColor = MAINCOLOR;
    }else{
        self.selectValue = @"";
        self.lastClickBtn.backgroundColor = BACKCOLOR;
    }
    if(_chooseBlock){
        _chooseBlock(self.selectValue);
    }
}
@end
