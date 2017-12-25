//
//  SCTabBarItemView.h
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTabBarItem.h"

@interface SCTabBarItemView : UIControl

@property (nonatomic, strong, readonly) SCTabBarItem *item;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (void)configWithItem:(SCTabBarItem *)item;

@end
