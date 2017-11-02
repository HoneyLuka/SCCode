//
//  SCTimerTaskCenter.h
//  StarCity
//
//  Created by Shadow on 2017/9/5.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCTimerTaskDelegate <NSObject>

@required
- (NSInteger)timerTaskInterval; //can't <= 0.
- (void)onTimerTask;

@optional
- (BOOL)timerTaskRepeat; //default is NO.

@end

@interface SCTimerTaskCenter : NSObject

- (void)addTask:(id<SCTimerTaskDelegate>)task;
- (void)removeTask:(id<SCTimerTaskDelegate>)task;

+ (instancetype)sharedCenter;

@end
