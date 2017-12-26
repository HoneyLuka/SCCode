//
//  SCStateEngine.m
//  Test
//
//  Created by Luka Li on 2017/12/26.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "SCStateEngine.h"

@interface SCStateEngine ()

@property (nonatomic, strong) __kindof SCBaseState *currentState;

@property (nonatomic, strong) NSMutableDictionary *statesDict;

@end

@implementation SCStateEngine

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.statesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)changeStateWithEnum:(NSUInteger)stateEnum
{
    SCBaseState *oldState = self.currentState;
    BOOL hasOldState = oldState != nil;
    BOOL isSameState = (hasOldState && oldState.stateEnum == stateEnum);
    
    if (isSameState && self.ignoreSameState) {
        return;
    }
    
    BOOL needNotifyOldState = (hasOldState && !isSameState);
    
    SCBaseState *state = [self getStateWithEnum:stateEnum];
    
    // will exit
    if (needNotifyOldState) {
        [oldState willExitState:self];
    }
    
    // will enter
    [state willEnterState:self];
    
    // set current state
    self.currentState = state;
    
    // did exit
    if (needNotifyOldState) {
        [oldState didExitState:self];
    }
    
    // did enter
    [state didEnterState:self];
}

- (void)addState:(__kindof SCBaseState *)state
{
    if (!state) {
        return;
    }
    
    [self addStates:@[state]];
}

- (void)addStates:(NSArray<__kindof SCBaseState *> *)states
{
    if (!states.count) {
        return;
    }
    
    for (SCBaseState *state in states) {
        NSNumber *key = [NSNumber numberWithUnsignedInteger:state.stateEnum];
        [self.statesDict setObject:state forKey:key];
    }
}

- (__kindof SCBaseState *)addStateWithEnum:(NSUInteger)stateEnum
{
    SCBaseState *state = [SCBaseState new];
    state.stateEnum = stateEnum;
    [self addState:state];
    return state;
}

- (void)addStateWithEnumSet:(NSIndexSet *)indexSet
{
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [self addStateWithEnum:idx];
    }];
}

- (__kindof SCBaseState *)getStateWithEnum:(NSUInteger)stateEnum
{
    NSNumber *key = [NSNumber numberWithUnsignedInteger:stateEnum];
    return self.statesDict[key];
}

- (void)removeStateWithEnum:(NSUInteger)stateEnum
{
    if (self.currentState && self.currentState.stateEnum == stateEnum) {
        SCBaseState *state = self.currentState;
        
        [state willExitState:self];
        self.currentState = nil;
        [state didExitState:self];
    }
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:stateEnum];
    [self.statesDict removeObjectForKey:key];
}

- (void)clear
{
    [self.statesDict removeAllObjects];
    self.currentState = nil;
}

@end
