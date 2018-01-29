//
//  ViewController.m
//  Example2
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
@property (nonatomic, strong) NSArray<ImageRequestOperation *> *requestOperations;

@end

@implementation ViewController

static void *ImageDownloadKVOContext = &ImageDownloadKVOContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.operationQueue = [NSOperationQueue new];
    self.operationQueue.maxConcurrentOperationCount = 5;

    self.requestOperations = [self createImageRequestOperations];
    [self setupDependencies];

    for (ImageRequestOperation *operation in self.requestOperations) {
        [self updateViewsForOperation:operation animated:NO];
        [operation addObserver:self forKeyPath:@"isReady" options:0 context:ImageDownloadKVOContext];
        [operation addObserver:self forKeyPath:@"isExecuting" options:0 context:ImageDownloadKVOContext];
        [operation addObserver:self forKeyPath:@"isFinished" options:0 context:ImageDownloadKVOContext];
    }
}

- (NSArray<ImageRequestOperation *> *)createImageRequestOperations
{
    NSMutableArray *operations = [NSMutableArray new];
    for (NSString *URLString in [[NSBundle mainBundle] infoDictionary][@"imageURLs"]) {
        ImageRequestOperation *imageDownloadOperation = [[ImageRequestOperation alloc] initWithURL:[NSURL URLWithString:URLString]];
        imageDownloadOperation.simulatedDelay = (arc4random() / (double)RAND_MAX) * 2.0;
        [operations addObject:imageDownloadOperation];
    }
    return [operations copy];
}

- (void)setupDependencies
{
    [self.requestOperations[4] addDependency:self.requestOperations[0]];
    [self.requestOperations[7] addDependency:self.requestOperations[3]];
    [self.requestOperations[10] addDependency:self.requestOperations[6]];
    [self.requestOperations[10] addDependency:self.requestOperations[7]];
    [self.requestOperations[14] addDependency:self.requestOperations[10]];
    [self.requestOperations[17] addDependency:self.requestOperations[12]];
    [self.requestOperations[17] addDependency:self.requestOperations[13]];
    [self.requestOperations[17] addDependency:self.requestOperations[14]];
}

- (IBAction)startOperations:(UIButton *)sender
{
    sender.hidden = YES;

    NSOperation *finishOperation = [NSBlockOperation blockOperationWithBlock:^{
        [UIView transitionWithView:self.statusLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.statusLabel.text = @"All operations finished!";
        } completion:nil];
    }];

    for (NSOperation *operation in self.requestOperations) {
        [finishOperation addDependency:operation];
    }

    [NSOperationQueue.mainQueue addOperation:finishOperation];
    [self.operationQueue addOperations:self.requestOperations waitUntilFinished:NO];
}

- (void)updateViewsForOperation:(ImageRequestOperation *)operation animated:(BOOL)animated
{
    NSInteger index = [self.requestOperations indexOfObject:operation];
    UIImageView *imageView = self.imageViews[index];
    UIActivityIndicatorView *activityIndicator = self.activityIndicators[index];

    if (operation.isExecuting) {
        [activityIndicator startAnimating];
    } else if (operation.isFinished) {
        [activityIndicator stopAnimating];
        imageView.image = operation.image;
    }

    if (operation.isReady) {
        imageView.backgroundColor = [UIColor colorWithRed:0.60 green:0.94 blue:0.60 alpha:1.0];
    } else {
        imageView.backgroundColor = [UIColor colorWithRed:0.94 green:0.60 blue:0.60 alpha:1.0];
    }

    if (animated) {
        [UIView transitionWithView:imageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == ImageDownloadKVOContext) {
        ImageRequestOperation *operation = object;
        if (operation.isFinished) {
            [operation removeObserver:self forKeyPath:@"isReady" context:ImageDownloadKVOContext];
            [operation removeObserver:self forKeyPath:@"isExecuting" context:ImageDownloadKVOContext];
            [operation removeObserver:self forKeyPath:@"isFinished" context:ImageDownloadKVOContext];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateViewsForOperation:object animated:YES];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
