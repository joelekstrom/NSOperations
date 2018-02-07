//
//  TransitionOperation.m
//  NSOperationsTests
//
//  Created by Joel Ekström on 2018-02-07.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "TransitionOperation.h"

@implementation TransitionOperation

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController
{
    if (self = [super init]) {
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
        self.duration = 0.3;
        self.options = UIViewAnimationOptionTransitionCrossDissolve;
    }
    return self;
}

- (void)main
{
    [self.fromViewController.parentViewController transitionFromViewController:self.fromViewController
                                                              toViewController:self.toViewController
                                                                      duration:self.duration
                                                                       options:self.options
                                                                    animations:self.animations
                                                                    completion:^(BOOL finished) {
                                                                        [self finish];
                                                                    }];
}

@end
