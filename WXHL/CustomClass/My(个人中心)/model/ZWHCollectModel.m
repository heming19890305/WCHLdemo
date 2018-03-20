//
//  ZWHCollectModel.m
//  WXHL
//
//  Created by Syrena on 2017/11/22.
//  Copyright © 2017年 Syrena. All rights reserved.
//

#import "ZWHCollectModel.h"

@implementation ZWHCollectModel


-(void)setThumbnail:(NSString *)thumbnail{
    _thumbnail = [NSString stringWithFormat:@"%@%@",[UserManager fileSer],thumbnail];
}

@end
