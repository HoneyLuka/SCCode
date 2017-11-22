//
//  SCPaddingLabel.m
//  StarCity
//
//  Created by Shadow on 2017/5/22.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import "SCPaddingLabel.h"

@interface SCPaddingLabel ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SCPaddingLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    if (!self.text.length) {
        return [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
    
    UIEdgeInsets insets = self.padding;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.padding)];
}

- (void)setActionEnabled:(BOOL)actionEnabled
{
    if (_actionEnabled == actionEnabled) {
        return;
    }
    
    _actionEnabled = actionEnabled;
    
    self.userInteractionEnabled = actionEnabled;
    
    if (self.tapGesture) {
        [self removeGestureRecognizer:self.tapGesture];
    }
    
    if (actionEnabled) {
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:self.tapGesture];
    }
}

- (void)onTap
{
    if (self.clickCallback) {
        self.clickCallback();
    }
}

@end
