//
//  AsyncOperation.m
//  NSOperationsTests
//
//  Created by Joel Ekström on 2018-02-06.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "AsyncOperation.h"

@interface AsyncOperation() {
    BOOL _isExecuting;
    BOOL _isFinished;
}

@end

@implementation AsyncOperation

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)start
{
    if (!self.isReady) {
        [NSException raise:NSInternalInconsistencyException format:@"Attempt to start %@ before it was ready", NSStringFromClass(self.class)];
    }

    self.executing = YES;
    if (self.isCancelled) {
        [self finish];
    } else {
        [self main];
    }
}

- (void)main
{
    [self doesNotRecognizeSelector:_cmd]; // Must override and call finish
}

- (void)finish
{
    [self setExecuting:NO];
    [self setFinished:YES];
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (void)setExecuting:(BOOL)executing
{
    @synchronized(self) {
        if (_isExecuting != executing) {
            [self willChangeValueForKey:@"isExecuting"];
            _isExecuting = executing;
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

- (void)setFinished:(BOOL)finished
{
    @synchronized(self) {
        if (_isFinished != finished) {
            [self willChangeValueForKey:@"isFinished"];
            _isFinished = finished;
            [self didChangeValueForKey:@"isFinished"];
        }
    }
}

@end
