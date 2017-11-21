//
//  SCNavigationBar.m
//  Test
//
//  Created by Luka Li on 2017/11/21.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "SCNavigationBar.h"
#import "Masonry.h"

@interface SCNavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *leftStackView;
@property (nonatomic, strong) UIStackView *rightStackView;

@end

@implementation SCNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setLeftViewOffset:(float)leftViewOffset
{
    _leftViewOffset = leftViewOffset;
    [self.leftStackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(leftViewOffset);
    }];
}

- (void)setRightViewOffset:(float)rightViewOffset
{
    _rightViewOffset = rightViewOffset;
    [self.rightStackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-rightViewOffset);
    }];
}

- (void)setContentViewHeight:(float)contentViewHeight
{
    _contentViewHeight = contentViewHeight;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(contentViewHeight));
    }];
}

- (void)setup
{
    _leftViewOffset = 12;
    _rightViewOffset = 12;
    _contentViewHeight = 44;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.contentView = [[UIView alloc]initWithFrame:self.bounds];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(self.contentViewHeight));
    }];
    
    self.leftStackView = [self createStackView];
    self.rightStackView = [self createStackView];
    [self.contentView addSubview:self.leftStackView];
    [self.contentView addSubview:self.rightStackView];
    
    [self.leftStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.leftViewOffset);
    }];
    
    [self.rightStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-self.rightViewOffset);
    }];
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
    }];
}

- (UIStackView *)createStackView
{
    UIStackView *stackView = [[UIStackView alloc]initWithFrame:CGRectZero];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 8;
    return stackView;
}

- (void)addLeftView:(UIView *)leftView
{
    if (!leftView) {
        return;
    }
    
    [self.leftStackView addArrangedSubview:leftView];
}

- (void)addRightView:(UIView *)rightView
{
    if (!rightView) {
        return;
    }
    
    [self.rightStackView insertArrangedSubview:rightView atIndex:0];
}

- (void)addLeftViews:(NSArray<UIView *> *)views
{
    for (UIView *view in views) {
        [self addLeftView:view];
    }
}

- (void)addRightViews:(NSArray<UIView *> *)views
{
    for (UIView *view in views) {
        [self addRightView:view];
    }
}

@end
