//
//  UIViewController+SCTabBar.m
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import "UIViewController+SCTabBar.h"
#import <objc/runtime.h>

static int kSCTabBarItemKey;
static int kSCTabBarBadgeItemKey;

@implementation UIViewController (SCTabBar)

- (void)setSc_tabBarBadgeItem:(__kindof SCTabBarBadgeItem *)sc_tabBarBadgeItem
{
    objc_setAssociatedObject(self, &kSCTabBarBadgeItemKey, sc_tabBarBadgeItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (__kindof SCTabBarBadgeItem *)sc_tabBarBadgeItem
{
    return objc_getAssociatedObject(self, &kSCTabBarBadgeItemKey);
}

- (void)setSc_tabBarItem:(SCTabBarItem *)sc_tabBarItem
{
    objc_setAssociatedObject(self, &kSCTabBarItemKey, sc_tabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCTabBarItem *)sc_tabBarItem
{
    SCTabBarItem *item = objc_getAssociatedObject(self, &kSCTabBarItemKey);
    if (!item) {
        item = [SCTabBarItem new];
        [self setSc_tabBarItem:item];
    }
    
    return item;
}

- (SCTabBarController *)sc_tabBarController
{
    if ([self.parentViewController isKindOfClass:SCTabBarController.class]) {
        return (SCTabBarController *)self.parentViewController;
    }
    
    if (self.navigationController) {
        return [self.navigationController sc_tabBarController];
    }
    
    return nil;
}

- (void)sc_addChildViewController:(UIViewController *)childController
{
    if (!childController) {
        return;
    }
    
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)sc_removeFromParentController
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
