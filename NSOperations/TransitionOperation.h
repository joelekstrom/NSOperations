//
//  TransitionOperation.h
//  NSOperationsTests
//
//  Created by Joel Ekström on 2018-02-07.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "AsyncOperation.h"

@interface TransitionOperation : AsyncOperation

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController;

@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIViewController *toViewController;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UIViewAnimationOptions options;
@property (nonatomic, assign) void (^animations)(void);

@end
