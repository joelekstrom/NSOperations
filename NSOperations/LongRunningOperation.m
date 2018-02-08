//
//  LongRunningOperation.m
//  NSOperations
//
//  Created by Joel Ekström on 2018-01-23.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "LongRunningOperation.h"

@implementation LongRunningOperation

- (void)main
{
    [NSThread sleepForTimeInterval:self.timeInterval];
}

- (void)setMainThreadCompletionBlock:(void (^)(void))completionBlock
{
    [self setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), completionBlock);
    }];
}

@end
