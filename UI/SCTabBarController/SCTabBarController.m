//
//  SCTabBarController.m
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import "SCTabBarController.h"
#import "UIViewController+SCTabBar.h"

@interface SCTabBarController ()

@property (nonatomic, strong, readwrite) SCTabBar *tabBar;
@property (nonatomic, strong, readwrite) NSArray<UIViewController *> *controllers;
@property (nonatomic, strong, readwrite) UIViewController *selectedController;

@end

@implementation SCTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefault];
    }
    return self;
}

- (void)initDefault
{
    self.tabBarHeight = 54.f;
    self.tabBarBackgroundColor = [UIColor blackColor];
}

- (void)prepare
{
    CGRect bounds = self.view.bounds;
    CGFloat x = 0;
    CGFloat y = CGRectGetHeight(bounds) - self.tabBarHeight;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = self.tabBarHeight;
    self.tabBar = [[SCTabBar alloc]initWithFrame:CGRectMake(x, y, width, height)];
    self.tabBar.contentHeight = self.tabBarHeight;
    self.tabBar.backgroundColor = self.tabBarBackgroundColor;
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tabBar];
    
    self.tabBar.delegate = self;
}

- (void)changeTabbarLocation:(CGFloat)bottom
{
    CGRect bounds = self.view.bounds;
    CGFloat x = 0;
    CGFloat y = CGRectGetHeight(bounds) - self.tabBarHeight - bottom;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = self.tabBarHeight + bottom;
    self.tabBar.frame = CGRectMake(x, y, width, height);
}

- (BOOL)prefersStatusBarHidden
{
    if ([self.selectedController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navi = (UINavigationController *)self.selectedController;
        UIViewController *vc = [navi childViewControllerForStatusBarHidden];
        if (vc) {
            return [vc prefersStatusBarHidden];
        }
    }
    
    return [self.selectedController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([self.selectedController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navi = (UINavigationController *)self.selectedController;
        UIViewController *vc = [navi childViewControllerForStatusBarStyle];
        if (vc) {
            return [vc preferredStatusBarStyle];
        }
    }
    
    return [self.selectedController preferredStatusBarStyle];
}

- (void)viewSafeAreaInsetsDidChange
{
    if (@available(iOS 11, *)) {
        [super viewSafeAreaInsetsDidChange];
        [self changeTabbarLocation:self.view.safeAreaInsets.bottom];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];
    [self configControllers];
}

- (void)setTabBarHidden:(BOOL)hidden
{
    self.tabBar.hidden = NO;
    
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:
     ^{
         CGFloat translateY = hidden ? CGRectGetHeight(self.tabBar.bounds) : 0;
         self.tabBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, translateY);
    } completion:^(BOOL finished) {
        if (hidden) {
            self.tabBar.hidden = hidden;
        }
    }];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)controllers
{
    [self removeOldController];
    self.controllers = controllers;
    [self configControllers];
}

- (void)configControllers
{
    if (!self.controllers.count) {
        return;
    }
    
    NSMutableArray *items = [NSMutableArray array];
    for (UIViewController *vc in self.controllers) {
        [items addObject:vc.sc_tabBarItem];
    }
    
    [self.tabBar configWithItems:items];
}

- (void)removeOldController
{
    if (self.selectedController) {
        [self.selectedController sc_removeFromParentController];
    }
}

#pragma mark - Public

- (void)setSelectIndex:(NSInteger)index
{
    [self.tabBar setSelectIndex:index];
}

- (NSInteger)selectedIndex
{
    return [self.controllers indexOfObject:self.selectedController];
}

#pragma mark - SCTabBarDelegate

- (void)tabBar:(SCTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    [self removeOldController];
    
    UIViewController *controller = self.controllers[index];
    
    [self addChildViewController:controller];
    controller.view.frame = self.view.bounds;
    controller.view.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    
    [self.view insertSubview:controller.view atIndex:0];
    [controller didMoveToParentViewController:self];
    
    self.selectedController = controller;
}

- (void)tabBarDidSelectAgain:(SCTabBar *)tabBar
{
    
}

#pragma mark - Badge

- (void)addBadge:(SCTabBarBadgeItem *)item atIndex:(NSInteger)index
{
    SCTabBarItemView *itemView = self.tabBar.itemViews[index];
    CGRect rect = [itemView convertRect:itemView.bounds toView:self.tabBar];
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    center.x += item.offset.x;
    center.y += item.offset.y;
    
    [self.tabBar addSubview:item.badgeView];
    item.badgeView.center = center;
}

- (void)showBadgeAtIndex:(NSInteger)index
{
    if (index >= self.controllers.count) {
        return;
    }
    
    UIViewController *vc = self.controllers[index];
    [vc.sc_tabBarBadgeItem configBadge];
    [self addBadge:vc.sc_tabBarBadgeItem atIndex:index];
}

- (void)hideBadgeAtIndex:(NSInteger)index
{
    if (index >= self.controllers.count) {
        return;
    }
    
    UIViewController *vc = self.controllers[index];
    [vc.sc_tabBarBadgeItem clean];
}

- (void)cleanAllBadge
{
    for (UIViewController *vc in self.controllers) {
        [vc.sc_tabBarBadgeItem clean];
    }
}

@end
