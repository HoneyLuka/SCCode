//
//  SCScrollLabel.h
//  Test
//
//  Created by Luka Li on 2017/11/10.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCScrollLabel : UIView

@property(nonatomic,strong) UIFont *font;
@property(nonatomic,strong) UIColor *textColor;
//@property (nonatomic, assign) CGFloat scrollOffset;

- (void)applyText:(NSString *)text;
- (void)applyRichText:(NSAttributedString *)richText;

@end
