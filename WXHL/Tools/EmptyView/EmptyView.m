//
//  EmptyView.m
//  KPH
//
//  Created by 赵升 on 2017/6/1.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createView{
    self.emptyView = [[UIImageView alloc]init];
    self.emptyView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.emptyView];
    self.emptyView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, HEIGHT_PRO(122.5))
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(HEIGHT_PRO(168));
    
    self.emptyLabel = [[UILabel alloc]init];
    [self.emptyLabel textFont:14 textColor:[ZSColor hexStringToColor:@"6f6f6f"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.emptyLabel];
    self.emptyLabel.sd_layout
    .centerXEqualToView(self.emptyView)
    .heightIs(20)
    .bottomSpaceToView(self.emptyView, HEIGHT_PRO(17))
    .widthIs(400);
    
}


-(void)setImage:(UIImage *)image{
    self.emptyView.image = image;
}

-(void)setText:(NSString *)text{
    self.emptyLabel.text = text;
}




@end
