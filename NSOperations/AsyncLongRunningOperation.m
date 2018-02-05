//
//  AsyncLongRunningOperation.m
//  NSOperations
//
//  Created by Joel Ekström on 2018-01-23.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "AsyncLongRunningOperation.h"

@interface AsyncLongRunningOperation() {
    BOOL _isExecuting;
    BOOL _isFinished;
}

@end

@implementation AsyncLongRunningOperation

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)start
{
    if (!self.isReady) {
        [NSException raise:NSInternalInconsistencyException format:@"Attempt to start %@ before it was ready", NSStringFromClass(self.class)];
    }

    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];

    [[NSOperationQueue new] addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:self.timeInterval];

        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        _isExecuting = NO;
        _isFinished = YES;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
    }];
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

@end
