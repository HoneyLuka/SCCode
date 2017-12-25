//
//  SCTabBarItemView.m
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import "SCTabBarItemView.h"
#import "Masonry.h"

@interface SCTabBarItemView ()

@property (nonatomic, strong, readwrite) SCTabBarItem *item;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@end

@implementation SCTabBarItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)prepare
{
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.offset(-6);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-3);
        make.centerX.equalTo(self);
    }];
    
}

- (void)configWithItem:(SCTabBarItem *)item
{
    self.item = item;
    [self refreshItemView];
}

- (void)refreshItemView
{
    UIImage *image = self.isSelected ? self.item.selectImage : self.item.deselectImage;
    if (self.imageView.image == image) {
        return;
    }
    self.titleLabel.text = self.item.title;
    self.imageView.image = image;
    
    UIColor *color = self.isSelected ? self.item.selectTitleColor : self.item.deselectTitleColor;
    self.titleLabel.textColor = color;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self refreshItemView];
}

@end
