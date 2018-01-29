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

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation NSOperationsTests

- (void)setUp
{
    [super setUp];
    self.operationQueue = [NSOperationQueue new];
}

- (void)testManualStarting
{
    LongRunningOperation *firstOperation = [[LongRunningOperation alloc] initWithTimeInterval:3.0];
    LongRunningOperation *secondOperation = [[LongRunningOperation alloc] initWithTimeInterval:3.0];
    [secondOperation addDependency:firstOperation];

    XCTAssertTrue(firstOperation.isReady);
    XCTAssertFalse(secondOperation.isReady);
    XCTAssertThrows([secondOperation start]);
    [firstOperation start]; // Will block until operation is done
    XCTAssertTrue(secondOperation.isReady);
    XCTAssertNoThrow([secondOperation start]);
    XCTAssertTrue(secondOperation.isFinished);
}

- (void)testAsyncOperations
{
    AsyncLongRunningOperation *firstOperation = [[AsyncLongRunningOperation alloc] initWithTimeInterval:3.0];
    AsyncLongRunningOperation *secondOperation = [[AsyncLongRunningOperation alloc] initWithTimeInterval:3.0];
    [secondOperation addDependency:firstOperation];

    [firstOperation start];
    XCTAssertThrows([secondOperation start]);
    [firstOperation waitUntilFinished]; // Blocks the current thread until operation is finished
    XCTAssertNoThrow([secondOperation start]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
