//
//  WrapperOperation.m
//  NSOperationsTests
//
//  Created by Joel Ekström on 2018-02-06.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "WrapperOperation.h"

@implementation WrapperOperation

- (void)main
{
    NSOperationQueue *queue = [NSOperationQueue new];
    LongRunningOperation *operation1 = [[LongRunningOperation alloc] init];
    LongRunningOperation *operation2 = [[LongRunningOperation alloc] init];
    LongRunningOperation *operation3 = [[LongRunningOperation alloc] init];
    LongRunningOperation *operation4 = [[LongRunningOperation alloc] init];
    [queue addOperations:@[operation1, operation2, operation3, operation4] waitUntilFinished:YES];
    // or [queue waitUntilAllOperationsAreFinished]
}

@end
