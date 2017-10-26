//
//  SCActionSheet.m
//  OpenWire
//
//  Created by Shadow on 16/1/14.
//  Copyright © 2016年 Jianjun. All rights reserved.
//

#import "SCActionSheet.h"
#import "Masonry.h"
#import "UIColor+Utils.h"

typedef void(^AppActionBlock)(NSInteger buttonIndex);

typedef NS_ENUM(NSUInteger, AppActionButtonType) {
  AppActionButtonTypeNormal,
  AppActionButtonTypeRed,
  AppActionButtonTypeGrey,
  AppActionButtonTypeTitle
};

#define titleButtonHeight 30
#define normalButtonHeight 50
#define buttonBgColor [UIColor colorWithRed:0.980 green:0.984 blue:0.988 alpha:1.0]
#define buttonRedColor [UIColor colorWithHex:0xFF7171]
#define containerBgColor [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1.0]
#define buttonTextFont [UIFont systemFontOfSize:16]
#define titleTextFont [UIFont systemFontOfSize:12]
#define titleTextColor [UIColor colorWithWhite:0 alpha:0.3]

@interface AppActionButton : UIButton

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) AppActionButtonType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) AppActionBlock block;

+ (instancetype)createWithTitle:(NSString *)title type:(AppActionButtonType)type block:(AppActionBlock)block;

@end

@implementation AppActionButton

+ (instancetype)createWithTitle:(NSString *)title type:(AppActionButtonType)type block:(AppActionBlock)block
{
  AppActionButton *button = [AppActionButton buttonWithType:UIButtonTypeCustom];
  button.backgroundColor = buttonBgColor;
  button.title = title;
  button.type = type;
  button.block = block;
  
  [button setTitle:title forState:UIControlStateNormal];

  UIColor *titleColor = [UIColor blackColor];
  UIFont *font = buttonTextFont;
  switch (type) {
    case AppActionButtonTypeRed:
      titleColor = buttonRedColor;
      break;
    case AppActionButtonTypeTitle:
      font = titleTextFont;
      titleColor = titleTextColor;
      button.enabled = NO;
      break;
    default:
      break;
  }
  [button setTitleColor:titleColor forState:UIControlStateNormal];
  button.titleLabel.font = font;
  button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    CGFloat height = type == AppActionButtonTypeTitle ? titleButtonHeight : normalButtonHeight;
    make.height.mas_equalTo(height);
  }];
  
  return button;
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  if (highlighted) {
    self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.05];
  } else {
    self.backgroundColor = buttonBgColor;
  }
}

@end

@interface SCActionSheet ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentContainerView; //titleButton和buttonContainer
@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) AppActionButton *titleButton;

@end

@implementation SCActionSheet

- (instancetype)init
{
  return [self initWithTitle:nil];
}

- (id)initWithTitle:(NSString *)title
{
  self = [super init];
  if (self) {
    self.title = title;
    [self prepare];
  }
  
  return self;
}

- (void)setTitle:(NSString *)title
{
  _title = title;
  [self.titleButton setTitle:title forState:UIControlStateNormal];
  [self resizeTitleButtonHeight];
}

- (void)prepare
{
  self.backgroundColor = [UIColor clearColor];
  self.buttonArray = [NSMutableArray array];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
  [self addGestureRecognizer:tap];
  
  __weak typeof(self) weakSelf = self;
  
  self.bgView = [[UIView alloc]init];
  self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
  self.bgView.alpha = 0;
  [self addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(weakSelf).with.insets(UIEdgeInsetsZero);
  }];
  
  self.contentContainerView = [[UIView alloc]init];
  self.contentContainerView.backgroundColor = containerBgColor;
  [self addSubview:self.contentContainerView];
  [self.contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(weakSelf.mas_left);
    make.right.mas_equalTo(weakSelf.mas_right);
    make.bottom.mas_equalTo(weakSelf.mas_bottom);
  }];
  
  self.buttonContainerView = [[UIView alloc]init];
  self.buttonContainerView.backgroundColor = containerBgColor;
  [self.contentContainerView addSubview:self.buttonContainerView];
  [self.buttonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(weakSelf.contentContainerView.mas_left);
    make.right.mas_equalTo(weakSelf.contentContainerView.mas_right);
    make.bottom.mas_equalTo(weakSelf.contentContainerView.mas_bottom);
  }];
  
  self.titleButton = [AppActionButton createWithTitle:self.title type:AppActionButtonTypeTitle block:nil];
  [self.contentContainerView addSubview:self.titleButton];
  [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(weakSelf.contentContainerView.mas_left);
    make.right.mas_equalTo(weakSelf.contentContainerView.mas_right);
    make.top.mas_equalTo(weakSelf.contentContainerView.mas_top);
    make.bottom.mas_equalTo(weakSelf.buttonContainerView.mas_top);
  }];
  [self resizeTitleButtonHeight];
}

- (void)resizeTitleButtonHeight
{
  CGFloat height = self.title.length ? titleButtonHeight : 0;
  CGFloat offset = self.title.length ? -1 : 0;
  
  __weak typeof(self) weakSelf = self;
  [self.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(height);
    make.bottom.mas_equalTo(weakSelf.buttonContainerView.mas_top).offset(offset);
  }];
}

- (void)addButton:(NSString *)title block:(void (^)(NSInteger buttonIndex))block
{
  AppActionButton *button = [AppActionButton createWithTitle:title
                                                        type:AppActionButtonTypeNormal
                                                       block:block];
  [self insertButtonToContainerView:button];
}

- (void)addCancelButton:(NSString *)title block:(void (^)(NSInteger buttonIndex))block
{
  AppActionButton *button = [AppActionButton createWithTitle:title
                                                        type:AppActionButtonTypeGrey
                                                       block:block];
  [self insertButtonToContainerView:button];
}

- (void)addConfirmButton:(NSString *)title block:(void (^)(NSInteger buttonIndex))block
{
  AppActionButton *button = [AppActionButton createWithTitle:title
                                                        type:AppActionButtonTypeRed
                                                       block:block];
  
  [self insertButtonToContainerView:button];
}

- (void)insertButtonToContainerView:(AppActionButton *)button
{
  button.exclusiveTouch = YES;
  button.tag = self.buttonArray.count;
  [self.buttonArray addObject:button];
  [button addTarget:self
             action:@selector(buttonClick:)
   forControlEvents:UIControlEventTouchUpInside];
  
  [self.buttonContainerView addSubview:button];
  
  __weak typeof(self) weakSelf = self;
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(weakSelf.buttonContainerView.mas_left);
    make.right.mas_equalTo(weakSelf.buttonContainerView.mas_right);
  }];
  
  if (self.buttonArray.count == 1) {
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(weakSelf.buttonContainerView.mas_top);
    }];
  } else {
    NSInteger preIndex = button.tag - 1;
    AppActionButton *preButton = self.buttonArray[preIndex];
    
    CGFloat dividerHeight = 1;
    if (button.type == AppActionButtonTypeGrey) {
      dividerHeight = 5;
    }
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(preButton.mas_bottom).offset(dividerHeight);
    }];
  }
}

- (void)show
{
  if (self.superview) {
    return;
  }
  
  if (self.buttonArray.count <= 0) {
    return;
  }
  
  AppActionButton *lastButton = self.buttonArray.lastObject;
  __weak typeof(self) weakSelf = self;
  [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(weakSelf.buttonContainerView.mas_bottom);
  }];
  
  CGSize size = [self.contentContainerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  self.contentContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, size.height);
  
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  if (!window) {
    return;
  }
  
  [window addSubview:self];
  [self mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(window).with.insets(UIEdgeInsetsZero);
  }];
  
  [UIView animateWithDuration:0.25 animations:^{
    self.bgView.alpha = 1;
    self.contentContainerView.transform = CGAffineTransformIdentity;
  }];
}

- (void)dismiss
{
  if (!self.superview) {
    return;
  }
  
  [UIView animateWithDuration:0.25 animations:^{
    self.bgView.alpha = 0;
    CGSize size = [self.contentContainerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.contentContainerView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, size.height);
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

- (void)buttonClick:(AppActionButton *)button
{
  if (button.block) {
    button.block(button.tag);
  }
  
  [self dismiss];
}

- (void)tapAction
{
  [self dismiss];
}

@end
