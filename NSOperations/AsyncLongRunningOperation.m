//
//  AsyncLongRunningOperation.m
//  NSOperations
//
//  Created by Joel Ekström on 2018-01-23.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "AsyncLongRunningOperation.h"

@interface AsyncLongRunningOperation()

@property (assign) BOOL internalExecuting;
@property (assign) BOOL internalFinished;

@end

@implementation AsyncLongRunningOperation

@synthesize executing, finished;

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)start
{
    NSAssert(self.isReady, @"Attempted to start %@ before it was ready...", NSStringFromClass(self.class));
    self.internalExecuting = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self main];
        self.internalExecuting = NO;
        self.internalFinished = YES;
    });
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"executing"] || [key isEqualToString:@"isExecuting"]) {
        return [keyPaths setByAddingObject:@"internalExecuting"];
    } else if ([key isEqualToString:@"finished"] || [key isEqualToString:@"isFinished"]) {
        return [keyPaths setByAddingObject:@"internalFinished"];
    }
    return keyPaths;
}

@end
