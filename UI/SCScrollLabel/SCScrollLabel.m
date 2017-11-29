//
//  SCScrollLabel.m
//  Test
//
//  Created by Luka Li on 2017/11/10.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "SCScrollLabel.h"

@interface SCScrollLabel ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation SCScrollLabel

- (void)dealloc
{
    [self stopScroll];
}

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

- (void)setFont:(UIFont *)font
{
    self.label.font = font;
}

- (UIFont *)font
{
    return self.label.font;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.label.textColor = textColor;
}

- (UIColor *)textColor
{
    return self.label.textColor;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.label = [[UILabel alloc]init];
    self.label.autoresizingMask = UIViewAutoresizingNone;
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
}

- (void)applyText:(NSString *)text
{
    self.label.text = text;
    [self layout];
}

- (void)applyRichText:(NSAttributedString *)richText
{
    self.label.attributedText = richText;
    [self layout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layout];
}

- (void)layout
{
    [self.label sizeToFit];
    CGRect frame = self.label.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height = CGRectGetHeight(self.bounds);
    self.label.frame = frame;
    
    [self startScrollIfNeeded];
}

- (void)startScrollIfNeeded
{
    [self stopScroll];
    
    if (CGRectGetWidth(self.label.bounds) <= CGRectGetWidth(self.bounds)) {
        return;
    }
    
    [self startScroll];
}

- (void)startScroll
{
    CGFloat labelWidth = CGRectGetWidth(self.label.bounds);
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    if (viewWidth <= 0) {
        return;
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.repeatCount = CGFLOAT_MAX;
    animation.removedOnCompletion = NO;
    animation.autoreverses = YES;
    
    // duration
    CGFloat offset = labelWidth - viewWidth;
    CGFloat offsetPercent = offset / viewWidth;
    CFTimeInterval baseDuration = 3.5;
    baseDuration *= offsetPercent;
    baseDuration += 2; // add delay duration at begin and end.
    baseDuration = MAX(2, baseDuration);
    animation.duration = baseDuration;
    
    // keyframe
    NSNumber *fromV = @(0);
    NSNumber *toV = @(-offset);
    CGFloat delayDurationPercent = 1.f / baseDuration;
    animation.values = @[fromV, fromV, toV, toV];
    animation.keyTimes = @[@0, @(delayDurationPercent), @(1.f - delayDurationPercent), @1];
    
    [self.label.layer addAnimation:animation forKey:@"scrollAnimation"];
}

- (void)stopScroll
{
    [self.label.layer removeAllAnimations];
}

@end
