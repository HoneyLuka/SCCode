//
//  SCTimerTaskCenter.m
//  StarCity
//
//  Created by Shadow on 2017/9/5.
//  Copyright © 2017年 Tiaoshu Tech Inc. All rights reserved.
//

#import "SCTimerTaskCenter.h"

@interface SCTimerTaskHolder : NSObject

@property (nonatomic, weak) id<SCTimerTaskDelegate> target;
@property (nonatomic, assign) NSInteger step;

@end

@implementation SCTimerTaskHolder

+ (instancetype)holderWithTarget:(id<SCTimerTaskDelegate>)target
{
    if (!target) {
        return nil;
    }
    
    SCTimerTaskHolder *holder = [SCTimerTaskHolder new];
    holder.target = target;
    return holder;
}

- (BOOL)isEqual:(id)object
{
    return self.target == object;
}

- (BOOL)isRepeat
{
    if ([self.target respondsToSelector:@selector(timerTaskRepeat)]) {
        return [self.target timerTaskRepeat];
    }
    
    return NO;
}

- (NSInteger)interval
{
    NSInteger i = [self.target timerTaskInterval];
    
    NSAssert(i > 0, @"interval can't be negative");
    return i;
}

@end

@interface SCTimerTaskCenter ()

@property (nonatomic, strong) NSMutableArray<SCTimerTaskHolder *> *holders;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SCTimerTaskCenter

+ (instancetype)sharedCenter
{
    static SCTimerTaskCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [SCTimerTaskCenter new];
    });
    return center;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.holders = [NSMutableArray array];
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(onTimer)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)addTask:(id<SCTimerTaskDelegate>)task
{
    [self removeTask:task];
    SCTimerTaskHolder *holder = [SCTimerTaskHolder holderWithTarget:task];
    if (!holder) {
        return;
    }
    
    [self.holders addObject:holder];
}

- (void)removeTask:(id<SCTimerTaskDelegate>)task
{
    if ([self.holders containsObject:task]) {
        [self.holders removeObject:task];
    }
}

- (void)onTimer
{
    NSMutableIndexSet *is = [NSMutableIndexSet indexSet];
    NSMutableArray *needCallbackHolders = [NSMutableArray array];
    
    for (int i = 0; i < self.holders.count; i++) {
        SCTimerTaskHolder *holder = self.holders[i];
        
        //remove dealloced task
        if (!holder.target) {
            [is addIndex:i];
            continue;
        }
        
        holder.step++;
        NSInteger interval = [holder interval];
        
        if (holder.step % interval != 0) {
            continue;
        }
        
        [needCallbackHolders addObject:holder];
        
        BOOL repeat = [holder isRepeat];
        if (!repeat) {
            [is addIndex:i];
        }
    }
    
    [self.holders removeObjectsAtIndexes:is];
    
    for (SCTimerTaskHolder *holder in needCallbackHolders) {
        [holder.target onTimerTask];
    }
}

@end
