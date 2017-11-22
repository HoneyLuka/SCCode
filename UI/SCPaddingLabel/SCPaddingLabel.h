//
//  SCPaddingLabel.h
//  StarCity
//
//  Created by Shadow on 2017/5/22.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPaddingLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets padding;

@property (nonatomic, assign) BOOL actionEnabled;

@property (nonatomic, copy) void(^clickCallback)(void);

@end
