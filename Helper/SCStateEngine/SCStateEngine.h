//
//  SCStateEngine.h
//  Test
//
//  Created by Luka Li on 2017/12/26.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCBaseState.h"

@class SCStateEngine;
typedef void(^SCStateEngineCallback)(SCStateEngine *engine);

@interface SCStateEngine : NSObject

@property (nonatomic, strong, readonly) __kindof SCBaseState *currentState;

/**
 Default is NO.
 */
@property (nonatomic, assign) BOOL ignoreSameState;

@property (nonatomic, copy) SCStateEngineCallback didChangeStateCallback;

- (void)changeStateWithEnum:(NSUInteger)stateEnum;

- (void)addState:(__kindof SCBaseState *)state;
- (void)addStates:(NSArray<__kindof SCBaseState *> *)states;

- (__kindof SCBaseState *)addStateWithEnum:(NSUInteger)stateEnum;
- (void)addStateWithEnumSet:(NSIndexSet *)indexSet;

- (__kindof SCBaseState *)getStateWithEnum:(NSUInteger)stateEnum;

- (void)removeStateWithEnum:(NSUInteger)stateEnum;

- (void)clear;

@end
