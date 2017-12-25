//
//  SCTabBarBadgeItem.h
//  StarCity
//
//  Created by Shadow on 2017/5/27.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTabBarBadgeItem : NSObject

@property (nonatomic, strong) UIView *badgeView;

/**
 Based on SCTabBarItemView.center convert to SCTabBar coordinate system.
 */
@property (nonatomic, assign) CGPoint offset;

/**
 Override. Must call super.
 */
- (void)configBadge;

- (void)clean;

@end
