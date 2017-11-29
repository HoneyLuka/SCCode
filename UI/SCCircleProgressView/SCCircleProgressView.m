//
//  SCCircleProgressView.m
//  Test
//
//  Created by Luka Li on 2017/11/29.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "SCCircleProgressView.h"

#define AppDegreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface SCCircleProgressView ()

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *fgLayer;

@end

@implementation SCCircleProgressView

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

- (void)initDefaultValue
{
    _lineWidth = 4;
    _bgColor = [UIColor lightGrayColor];
    _fgColor = [UIColor orangeColor];
}

- (void)setup
{
    [self initDefaultValue];
    self.backgroundColor = [UIColor clearColor];
    
    self.bgLayer = [CAShapeLayer layer];
    self.bgLayer.fillColor = [UIColor clearColor].CGColor;
    self.bgLayer.strokeColor = self.bgColor.CGColor;
    self.bgLayer.lineWidth = self.lineWidth;
    [self.layer addSublayer:self.bgLayer];
    
    self.fgLayer = [CAShapeLayer layer];
    self.fgLayer.fillColor = [UIColor clearColor].CGColor;
    self.fgLayer.strokeColor = self.fgColor.CGColor;
    self.fgLayer.lineWidth = self.lineWidth;
    self.fgLayer.strokeEnd = 0;
    [self.layer addSublayer:self.fgLayer];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.bgLayer.lineWidth = lineWidth;
    self.fgLayer.lineWidth = lineWidth;
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.bgLayer.strokeColor = bgColor.CGColor;
}

- (void)setFgColor:(UIColor *)fgColor
{
    _fgColor = fgColor;
    self.fgLayer.strokeColor = fgColor.CGColor;
}

- (void)setProgress:(CGFloat)progress
{
    progress = MAX(MIN(1, progress), 0);
    _progress = progress;
    
    if (self.animationEnabled) {
        self.fgLayer.strokeEnd = progress;
        return;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.fgLayer.strokeEnd = progress;
    [CATransaction commit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self drawPath];
}

- (void)drawPath
{
    CGFloat radius = CGRectGetWidth(self.bounds) * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(radius, radius)
                    radius:radius
                startAngle:degreesToRadians(270)
                  endAngle:degreesToRadians(270 + 360)
                 clockwise:YES];
    
    self.bgLayer.path = path.CGPath;
    self.fgLayer.path = path.CGPath;
}

static inline CGFloat degreesToRadians(CGFloat degrees) {
    return degrees / 180.f * M_PI;
}

@end
