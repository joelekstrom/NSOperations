//
//  ChooseImageOperation.m
//  Example3
//
//  Created by Joel Ekström on 2018-02-05.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "ImagePickerOperation.h"
@import MobileCoreServices;

@interface ImagePickerOperation() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ImagePickerOperation

- (void)main
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentAlertController];
    });
}

- (void)presentAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentImagePickerController];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Default image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _selectedImage = [UIImage imageNamed:@"default"];
        [self finish];
    }]];

    if (self.shouldShowRemoveAction) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Remove image" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self finish];
        }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancel];
        [self finish];
    }]];

    [self.presentingViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)presentImagePickerController
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.mediaTypes = @[(NSString *)kUTTypeImage];
    [self.presentingViewController presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self cancel];
        [self finish];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:info[UIImagePickerControllerImageURL]];
    _selectedImage = [[UIImage alloc] initWithData:imageData];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self finish];
    }];
}

@end
