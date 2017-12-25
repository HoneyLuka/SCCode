//
//  SCTabBarItem.h
//  StarCity
//
//  Created by Shadow on 2017/5/26.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTabBarItem : NSObject

@property (nonatomic, strong) UIImage *deselectImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *deselectTitleColor;
@property (nonatomic, strong) UIColor *selectTitleColor;

@end
