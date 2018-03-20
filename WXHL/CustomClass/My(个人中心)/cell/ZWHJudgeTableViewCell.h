//
//  ZWHJudgeTableViewCell.h
//  WXHL
//
//  Created by Syrena on 2017/11/16.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^xxnumber)(NSInteger idx);

@interface ZWHJudgeTableViewCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UIButton *select;
@property(nonatomic,strong)xxnumber inputnumber;
@end
