//
//  JKNotifierBar.m
//  JKNotifier
//
//  Created by Jakey on 15/5/21.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//

#import "JKNotifierBar.h"
#import <Accelerate/Accelerate.h>
#import "JKNotifier.h"

@interface JKNotifierBar ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, assign) UIEdgeInsets edge;
@property (nonatomic, strong) UIFont *font;

@end

@implementation JKNotifierBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self buildWindow];
    }
    return self;
}
- (void)buildWindow
{
    self.windowLevel = UIWindowLevelStatusBar + 1.0;
    self.hidden = NO;
    self.autoresizesSubviews = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.850];
    
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    self.frame = sharedApplication.statusBarFrame;
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self addGestureRecognizer:recognizer];

    
//    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                            action:@selector(doHandlePanAction:)];
//    [self addGestureRecognizer:panGestureRecognizer];

    
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.detailLabel];
}

//- (void)doHandlePanAction:(UIPanGestureRecognizer *)paramSender{
//    
//    CGPoint point = [paramSender translationInView:self];
//    NSLog(@"X:%f;Y:%f",point.x,point.y);
//    
//    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
//    
//    [paramSender setTranslation:CGPointMake(0, 0) inView:self];
//    
//    
//}

- (void)handleSwipeFrom{
    NSLog(@"1234");
}

- (UIFont *)font{
    if (!_font) {
        _font =[UIFont systemFontOfSize:14.0];
    }
    return _font;
}
- (UIEdgeInsets)edge{
    return  UIEdgeInsetsMake(8.0, 50.0, 20.0, 5.0);
}
- (UIImageView *)iconView;
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_iconView setSize:CGSizeMake(35, 35)];
        _iconView.layer.cornerRadius = 10;
        _iconView.layer.masksToBounds = YES;
        _iconView.clipsToBounds = YES;
    }
    return _iconView;
}

//- (UILabel *)timeLabel;
//{
//    if (!_timeLabel) {
//        _timeLabel = [[UILabel alloc] initWithFrame:self.bounds];
//        _timeLabel.textColor = [UIColor colorWithWhite:1.000 alpha:0.490];
//        _timeLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.000];
//        _timeLabel.font = [UIFont systemFontOfSize:NOTIFIER_FONT_SIZE-2];
//        _timeLabel.textAlignment = NSTextAlignmentLeft;
//        _timeLabel.clipsToBounds = YES;
//    }
//    return _timeLabel;
//}

- (UILabel *)nameLabel;
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = self.font;
        _nameLabel.textAlignment = NSTextAlignmentJustified;
        _nameLabel.clipsToBounds = YES;
        _nameLabel.numberOfLines = 2;

    }
    return _nameLabel;
}

- (UILabel *)detailLabel;
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = self.font;
        _detailLabel.textAlignment = NSTextAlignmentJustified;
        _detailLabel.clipsToBounds = YES;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}


- (void)tap{
    if (_notifierBarClickBlock) {
        _notifierBarClickBlock(self.nameLabel.text?:@"",self.detailLabel.text?:@"",[JKNotifier shareInstance]);
    }
}




- (void)handleClickAction:(JKNotifierBarClickBlock)notifierBarClickBlock{
    _notifierBarClickBlock = [notifierBarClickBlock copy];
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath  *round = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.frame)-35)/2, CGRectGetHeight(self.frame)-12, 35, 5) byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(10, 10)];
    [[UIColor lightGrayColor] setFill];
    [round fill];
}
- (void)show:(NSString*)note name:(NSString*)appName icon:(UIImage*)appIcon{
    self.nameLabel.text = appName;
    self.detailLabel.text = note;
    self.iconView.image = appIcon;
//    self.timeLabel.text = @"刚刚";
    
    self.iconView.frame = CGRectMake(10, 10, 30, 30);
    self.iconView.layer.cornerRadius = 8;
    self.iconView.layer.masksToBounds= YES;
    CGFloat nameLabelHeight  =  MIN(40, [self heightWithString:appName fontSize:self.font.pointSize width:CGRectGetWidth(self.frame)-self.edge.left-self.edge.right]);
    
    self.nameLabel.frame = CGRectMake(self.edge.left, self.edge.top + 3, CGRectGetWidth(self.frame)-self.edge.left-self.edge.right,nameLabelHeight);

    
    CGFloat detailLabelHeight =  MIN(CGRectGetHeight([UIScreen mainScreen].bounds)-40-self.edge.bottom, [self heightWithString:note fontSize:self.font.pointSize width:CGRectGetWidth(self.frame)-self.edge.left-self.edge.right]);
    
    self.detailLabel.frame = CGRectMake(self.edge.left,
                             CGRectGetMaxY(self.nameLabel.frame),
                             CGRectGetWidth(self.frame)-self.edge.left-self.edge.right,detailLabelHeight);
    
    CGFloat selfHeight = MIN(CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetMaxY(self.detailLabel.frame)+self.edge.bottom);
    self.frame = CGRectMake(0,-selfHeight,CGRectGetWidth(self.frame),selfHeight);

    [self setNeedsDisplay];
}
- (CGFloat)widthWithString:(NSString*)string fontSize:(CGFloat)fontSize height:(CGFloat)height
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}
- (CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}
@end
