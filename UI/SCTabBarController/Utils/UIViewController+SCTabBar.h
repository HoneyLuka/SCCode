//
//  UIViewController+SCTabBar.h
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTabBarItem.h"
#import "SCTabBarController.h"
#import "SCTabBarBadgeItem.h"

@interface UIViewController (SCTabBar)

@property (nonatomic, strong) __kindof SCTabBarBadgeItem *sc_tabBarBadgeItem;
@property (nonatomic, strong) SCTabBarItem *sc_tabBarItem;

@property (nonatomic, assign, readonly) SCTabBarController *sc_tabBarController;

- (void)sc_addChildViewController:(UIViewController *)childController;
- (void)sc_removeFromParentController;

@end
