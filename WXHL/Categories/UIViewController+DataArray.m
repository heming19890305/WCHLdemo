//
//  UIViewController+DataArray.m
//  LookPicture
//
//  Created by Syrena on 2017/9/13.
//  Copyright © 2017年 龙泉舟. All rights reserved.
//

#import "UIViewController+DataArray.h"

@implementation UIViewController (DataArray)


static char foreigArr = 'a';

-(void)setModuleArray:(NSArray *)moduleArray{
    objc_setAssociatedObject(self, &foreigArr, moduleArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSArray *)moduleArray{
    return  objc_getAssociatedObject(self, &foreigArr);
}

@end
