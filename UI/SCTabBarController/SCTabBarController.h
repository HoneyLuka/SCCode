//
//  SCTabBarController.h
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTabBarItem.h"
#import "SCTabBar.h"

@interface SCTabBarController : UIViewController <SCTabBarDelegate>

#pragma mark - Custom

@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, assign) UIColor *tabBarBackgroundColor;

#pragma mark - Public

@property (nonatomic, strong, readonly) SCTabBar *tabBar;
@property (nonatomic, strong, readonly) NSArray<UIViewController *> *controllers;

@property (nonatomic, strong, readonly) __kindof UIViewController *selectedController;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

@property (nonatomic, assign, readonly) BOOL isTabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden;

- (void)setViewControllers:(NSArray<UIViewController *> *)controllers;

- (void)setSelectIndex:(NSInteger)index;

#pragma mark - Badge

- (void)showBadgeAtIndex:(NSInteger)index;
- (void)hideBadgeAtIndex:(NSInteger)index;
- (void)cleanAllBadge;

@end
