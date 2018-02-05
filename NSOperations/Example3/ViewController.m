//
//  ViewController.m
//  Example3
//
//  Created by Joel Ekström on 2018-02-05.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "ViewController.h"
#import "ImagePickerOperation.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (IBAction)chooseImage:(id)sender
{
    NSOperationQueue *operationQueue = [NSOperationQueue new];

    ImagePickerOperation *imagePickerOperation = [ImagePickerOperation new];
    imagePickerOperation.presentingViewController = self;
    imagePickerOperation.shouldShowRemoveAction = self.imageView.image;
    [operationQueue addOperation:imagePickerOperation];

    NSOperation *setImageOperation = [NSBlockOperation blockOperationWithBlock:^{
        if (!imagePickerOperation.isCancelled) {
            self.imageView.image = imagePickerOperation.selectedImage;
            [UIView transitionWithView:self.imageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
        }
    }];

    [setImageOperation addDependency:imagePickerOperation];
    [NSOperationQueue.mainQueue addOperation:setImageOperation];
}

@end
