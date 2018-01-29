//
//  LongRunningOperation.m
//  NSOperations
//
//  Created by Joel Ekström on 2018-01-23.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "LongRunningOperation.h"

@interface LongRunningOperation()

@property (nonatomic, assign) NSTimeInterval timeInterval;

@end

@implementation LongRunningOperation

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval
{
    if (self = [super init]) {
        self.timeInterval = timeInterval;
    }
    return self;
}

- (void)main
{
    [NSThread sleepForTimeInterval:self.timeInterval];
}

@end
