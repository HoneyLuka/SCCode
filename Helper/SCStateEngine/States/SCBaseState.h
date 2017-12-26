//
//  SCBaseState.h
//  Test
//
//  Created by Luka Li on 2017/12/26.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCStateEngine;
@class SCBaseState;

typedef void(^SCStateCallback)(SCStateEngine *engine, __kindof SCBaseState *thisState);

@interface SCBaseState : NSObject

@property (nonatomic, assign) NSUInteger stateEnum;

// If use callback block, be careful about 'retain cycle'.
@property (nonatomic, copy) SCStateCallback willEnterCallback;
@property (nonatomic, copy) SCStateCallback didEnterCallback;
@property (nonatomic, copy) SCStateCallback willExitCallback;
@property (nonatomic, copy) SCStateCallback didExitCallback;

#pragma mark - Override point

// Call super will call callback block. Do or not, it's up to you.

- (void)willEnterState:(SCStateEngine *)engine;
- (void)didEnterState:(SCStateEngine *)engine;

- (void)willExitState:(SCStateEngine *)engine;
- (void)didExitState:(SCStateEngine *)engine;

@end
