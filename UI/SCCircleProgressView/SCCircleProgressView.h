//
//  SCCircleProgressView.h
//  Test
//
//  Created by Luka Li on 2017/11/29.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Must use square frame.
 */
@interface SCCircleProgressView : UIView

/**
 Range is 0..1
 */
@property (nonatomic, assign) CGFloat progress;

/**
 Default is 4.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 Default is light grey color.
 */
@property (nonatomic, strong) UIColor *bgColor;

/**
 Default is orange color.
 */
@property (nonatomic, strong) UIColor *fgColor;

/**
 Default is NO.
 */
@property (nonatomic, assign) BOOL animationEnabled;

@end
