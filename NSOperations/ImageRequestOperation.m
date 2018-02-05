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
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [[[NSURLSession sharedSession] dataTaskWithURL:self.URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        _image = [[UIImage alloc] initWithData:data];
        dispatch_semaphore_signal(semaphore);
    }] resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (_simulatedDelay > 0.0) {
        [NSThread sleepForTimeInterval:_simulatedDelay];
    }
}

@end
