//
//  NSOperationsTests.m
//  NSOperationsTests
//
//  Created by Joel Ekström on 2018-01-23.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LongRunningOperation.h"
#import "AsyncLongRunningOperation.h"

@interface NSOperationsTests : XCTestCase

@end

@implementation NSOperationsTests

- (void)testSynchronousOperation
{
    LongRunningOperation *operation = [LongRunningOperation new];
    operation.timeInterval = 10.0;
    [operation start];
    XCTAssertTrue(operation.isFinished);
}

- (void)testAsynchronousOperation
{
    AsyncLongRunningOperation *operation = [AsyncLongRunningOperation new];
    operation.timeInterval = 10.0;
    [operation start];
    [operation waitUntilFinished];
    XCTAssertTrue(operation.isFinished);
}

- (void)testDependencies
{
    LongRunningOperation *firstOperation = [LongRunningOperation new];
    LongRunningOperation *secondOperation = [LongRunningOperation new];
    firstOperation.timeInterval = 3.0;
    [secondOperation addDependency:firstOperation];

    XCTAssertTrue(firstOperation.isReady);
    XCTAssertFalse(secondOperation.isReady);
    XCTAssertThrows([secondOperation start]);
    [firstOperation start]; // Will block until operation is done
    XCTAssertTrue(secondOperation.isReady);
    XCTAssertNoThrow([secondOperation start]);
    XCTAssertTrue(secondOperation.isFinished);
}

- (void)testAsyncOperationsWithDependencies
{
    AsyncLongRunningOperation *firstOperation = [AsyncLongRunningOperation new];
    AsyncLongRunningOperation *secondOperation = [AsyncLongRunningOperation new];
    firstOperation.timeInterval = 3.0;
    secondOperation.timeInterval = 3.0;
    [secondOperation addDependency:firstOperation];

    [firstOperation start];
    XCTAssertThrows([secondOperation start]);
    [firstOperation waitUntilFinished]; // Blocks the current thread until operation is finished

    XCTKVOExpectation *executingExpectation = [[XCTKVOExpectation alloc] initWithKeyPath:@"isExecuting" object:secondOperation expectedValue:@YES];
    XCTAssertNoThrow([secondOperation start]);
    XCTKVOExpectation *notExecutingExpectation = [[XCTKVOExpectation alloc] initWithKeyPath:@"isExecuting" object:secondOperation expectedValue:@NO];
    XCTKVOExpectation *finishedExpectation = [[XCTKVOExpectation alloc] initWithKeyPath:@"isFinished" object:secondOperation expectedValue:@YES];
    [self waitForExpectations:@[executingExpectation, notExecutingExpectation, finishedExpectation] timeout:10.0];
}

- (void)testAsyncOperationSuperclass
{
    NSOperationQueue *queue = [NSOperationQueue new];
    AsyncOperation *operation1 = [AsyncOperation new];
    AsyncOperation *operation2 = [AsyncOperation new];
    [operation2 addDependency:operation1];
    [queue addOperations:@[operation1, operation2] waitUntilFinished:YES];
    XCTAssertFalse(operation1.isExecuting);
    XCTAssertFalse(operation2.isExecuting);
    XCTAssertTrue(operation1.isFinished);
    XCTAssertTrue(operation2.isFinished);
}

@end
