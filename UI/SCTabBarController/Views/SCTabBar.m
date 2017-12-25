//
//  SCTabBar.m
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import "SCTabBar.h"
#import "Masonry.h"

@interface SCTabBar ()

@property (nonatomic, strong, readwrite) NSArray<SCTabBarItem *> *items;
@property (nonatomic, strong, readwrite) NSArray<SCTabBarItemView *> *itemViews;
@property (nonatomic, strong, readwrite) SCTabBarItemView *selectedItemView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation SCTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    _contentHeight = contentHeight;
    [self relayoutContentView];
}

- (void)relayoutContentView
{
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.contentHeight));
    }];
}

- (void)prepare
{
    _contentHeight = 54;
    self.backgroundColor = [UIColor whiteColor];
    self.contentView = [[UIView alloc]initWithFrame:self.bounds];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(self.contentHeight));
    }];
}

- (void)configWithItems:(NSArray<SCTabBarItem *> *)items
{
    [self clean];
    self.items = items;
    
    if (!items.count) {
        return;
    }
    
    NSMutableArray *itemViews = [NSMutableArray array];
    for (SCTabBarItem *item in items) {
        SCTabBarItemView *itemView = [SCTabBarItemView new];
        [itemView configWithItem:item];
        [self.contentView addSubview:itemView];
        [itemViews addObject:itemView];
        
        [itemView addTarget:self
                     action:@selector(buttonClick:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    
    [itemViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                           withFixedSpacing:0
                                leadSpacing:0
                                tailSpacing:0];
    
    [itemViews mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
    }];
    
    self.itemViews = itemViews;
    
    [self setSelectIndex:0];
}

- (void)clean
{
    [self.itemViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.selectedItemView = nil;
}

- (void)resetButtonSelectState
{
    for (SCTabBarItemView *itemView in self.itemViews) {
        itemView.selected = NO;
    }
}

- (void)setSelectIndex:(NSInteger)index
{
    [self setSelectIndex:index notify:YES];
}

- (void)setSelectIndex:(NSInteger)index notify:(BOOL)notify
{
    if (index >= self.items.count) {
        return;
    }
    
    [self resetButtonSelectState];
    self.selectedItemView = self.itemViews[index];
    self.selectedItemView.selected = YES;
    
    if (notify) {
        [self notifyDelegateDidSelect];
    }
}

- (NSInteger)selectedIndex
{
    return [self.itemViews indexOfObject:self.selectedItemView];
}

- (void)buttonClick:(SCTabBarItemView *)itemView
{
    if (self.selectedItemView == itemView) {
        [self notifyDelegateDidSelectAgain];
        return;
    }
    
    [self resetButtonSelectState];
    itemView.selected = YES;
    
    self.selectedItemView = itemView;
    [self notifyDelegateDidSelect];
}

- (void)notifyDelegateDidSelect
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        NSInteger index = [self.itemViews indexOfObject:self.selectedItemView];
        [self.delegate tabBar:self didSelectIndex:index];
    }
}

- (void)notifyDelegateDidSelectAgain
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidSelectAgain:)]) {
        [self.delegate tabBarDidSelectAgain:self];
    }
}

@end
