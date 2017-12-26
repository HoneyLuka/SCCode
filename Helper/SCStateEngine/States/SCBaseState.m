//
//  SCBaseState.m
//  Test
//
//  Created by Luka Li on 2017/12/26.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "SCBaseState.h"

@implementation SCBaseState

- (void)willEnterState:(SCStateEngine *)engine
{
    if (self.willEnterCallback) {
        self.willEnterCallback(engine, self);
    }
}

- (void)didEnterState:(SCStateEngine *)engine
{
    if (self.didEnterCallback) {
        self.didEnterCallback(engine, self);
    }
}

- (void)willExitState:(SCStateEngine *)engine
{
    if (self.willExitCallback) {
        self.willExitCallback(engine, self);
    }
}

- (void)didExitState:(SCStateEngine *)engine
{
    if (self.didExitCallback) {
        self.didExitCallback(engine, self);
    }
}

@end
