//
//  SCTabBarBadgeItem.m
//  StarCity
//
//  Created by Shadow on 2017/5/27.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import "SCTabBarBadgeItem.h"

@implementation SCTabBarBadgeItem

- (void)configBadge
{
    [self clean];
}

- (void)clean
{
    if (self.badgeView.superview) {
        [self.badgeView removeFromSuperview];
        self.badgeView = nil;
    }
}

@end
