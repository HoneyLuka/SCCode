//
//  SCNavigationBar.h
//  Test
//
//  Created by Luka Li on 2017/11/21.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCNavigationBar : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong, readonly) UIStackView *leftStackView;
@property (nonatomic, strong, readonly) UIStackView *rightStackView;

// Default is 44.
@property (nonatomic, assign) float contentViewHeight;

// Default is 12.
@property (nonatomic, assign) float leftViewOffset;
@property (nonatomic, assign) float rightViewOffset;

- (void)addLeftView:(UIView *)leftView;
- (void)addRightView:(UIView *)rightView;
- (void)addLeftViews:(NSArray<UIView *> *)views;
- (void)addRightViews:(NSArray<UIView *> *)views;

@end
