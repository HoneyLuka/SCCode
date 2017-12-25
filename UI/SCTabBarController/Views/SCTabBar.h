//
//  SCTabBar.h
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTabBarItem.h"
#import "SCTabBarItemView.h"

@class SCTabBar;
@protocol SCTabBarDelegate <NSObject>

@optional
- (void)tabBar:(SCTabBar *)tabBar didSelectIndex:(NSInteger)index;

/**
 Callback when user select an itemView that has been selected.
 */
- (void)tabBarDidSelectAgain:(SCTabBar *)tabBar;

@end

@interface SCTabBar : UIView

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, weak) id<SCTabBarDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray<SCTabBarItem *> *items;
@property (nonatomic, strong, readonly) NSArray<SCTabBarItemView *> *itemViews;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, strong, readonly) SCTabBarItemView *selectedItemView;

/**
 Default notify is YES.
 */
- (void)setSelectIndex:(NSInteger)index;
- (void)setSelectIndex:(NSInteger)index notify:(BOOL)notify;

- (void)configWithItems:(NSArray<SCTabBarItem *> *)items;

@end
