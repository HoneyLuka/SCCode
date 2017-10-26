//
//  SCActionSheet.h
//  OpenWire
//
//  Created by Shadow on 16/1/14.
//  Copyright © 2016年 Jianjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCActionSheet : UIView

@property (nonatomic, strong) NSString *title;

- (id)initWithTitle:(NSString *)title;

//添加按钮的方法可以调用任意次，按钮顺序跟调用顺序一致，所以如果要添加取消按钮请在最后一个添加
- (void)addButton:(NSString *)title block:(void (^)(NSInteger buttonIndex))block;
- (void)addCancelButton:(NSString *)title block:(void (^)(NSInteger buttonIndex))block;
- (void)addConfirmButton:(NSString *)title block:(void (^)(NSInteger buttonIndex))block;

- (void)show;
- (void)dismiss;

@end
