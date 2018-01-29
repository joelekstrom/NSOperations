//
//  ViewController.m
//  Example1
//
//  Created by Joel Ekström on 2018-01-29.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "ViewController.h"
#import "ImageRequestOperation.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray<UIImageView *> *imageViews;
@property (nonatomic, strong) IBOutletCollection(UIActivityIndicatorView) NSArray<UIActivityIndicatorView *> *activityIndicators;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.operationQueue = [NSOperationQueue new];
    self.operationQueue.suspended = YES;
    [self createOperations];
}

- (void)createOperations
{
    NSEnumerator *imageViewEnumerator = self.imageViews.objectEnumerator;
    NSEnumerator *activityViewEnumerator = self.activityIndicators.objectEnumerator;

    for (NSURL *URL in [self URLs]) {
        ImageRequestOperation *imageRequestOperation = [[ImageRequestOperation alloc] initWithURL:URL];
        imageRequestOperation.simulatedDelay = (arc4random() / (double)RAND_MAX) * 2.0;
        [self.operationQueue addOperation:imageRequestOperation];

        UIActivityIndicatorView *activityIndicator = activityViewEnumerator.nextObject;
        UIImageView *imageView = imageViewEnumerator.nextObject;
        NSOperation *finishOperation = [NSBlockOperation blockOperationWithBlock:^{
            [activityIndicator stopAnimating];
            [UIView transitionWithView:imageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                imageView.image = imageRequestOperation.image;
            } completion:nil];
        }];

        [finishOperation addDependency:imageRequestOperation];
        [NSOperationQueue.mainQueue addOperation:finishOperation];
    }
}

- (NSArray<NSURL *> *)URLs
{
    return @[[NSURL URLWithString:@"https://www.forzafootball.com/assets/images/001-Patrik.jpg"],
             [NSURL URLWithString:@"https://www.forzafootball.com/assets/images/004-Johanna.jpg"],
             [NSURL URLWithString:@"https://www.forzafootball.com/assets/images/015-Mexinolo.jpg"]];
}

- (IBAction)startOperations:(UIButton *)sender
{
    sender.hidden = YES;
    [self.activityIndicators makeObjectsPerformSelector:@selector(startAnimating)];
    self.operationQueue.suspended = NO;

    NSOperation *finishOperation = [NSBlockOperation blockOperationWithBlock:^{
        [UIView transitionWithView:self.statusLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.statusLabel.text = @"All operations finished!";
        } completion:nil];
    }];

    for (NSOperation *operation in self.operationQueue.operations) {
        [finishOperation addDependency:operation];
    }

    [NSOperationQueue.mainQueue addOperation:finishOperation];
}

@end
