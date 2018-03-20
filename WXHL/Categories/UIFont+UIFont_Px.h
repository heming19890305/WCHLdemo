//
//  UIFont+UIFont_Px.h
//  千帆渡留学
//
//  Created by iOS开发 on 16/3/7.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
/** 列表无内容提示语 */
#define NOTHING_TEXT @"暂无内容，请您耐心的等待"

/** 列表获取数据失败提示语 */
#define INTERNET_ERROR_TEXT @"链接服务器失败，请稍后再试"
#define toolBarH HEIGHT_TO(80)
#define WEB_VIEW_TIMER_OUT 5
#define Current_City_Key @"currentCity1"
#define GPS_City_Key @"gpsCity1"
#define Title_Line_Height HEIGHT_TO(3)

@interface UIFont (UIFont_Px)
+(instancetype)fontWithPx:(CGFloat )px;

+(instancetype)fontWithPx:(CGFloat )px andWeight:(CGFloat) weight;
@end
