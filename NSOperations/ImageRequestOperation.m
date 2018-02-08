//
//  ImageDownloadOperation.m
//  NSOperations
//
//  Created by Joel Ekström on 2018-01-29.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "ImageRequestOperation.h"

@interface ImageRequestOperation()

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation ImageRequestOperation

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init]) {
        self.URL = URL;
    }
    return self;
}

- (void)main
{
    if (self.isCancelled) {
        return;
    }

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    self.task = [[NSURLSession sharedSession] dataTaskWithURL:self.URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!self.isCancelled) {
            _image = [[UIImage alloc] initWithData:data];
        }
        dispatch_semaphore_signal(semaphore);
    }];

    [self.task resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (_simulatedDelay > 0.0) {
        [NSThread sleepForTimeInterval:_simulatedDelay];
    }
}

- (void)cancel
{
    [super cancel];
    [self.task cancel];
}

@end
