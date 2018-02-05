//
//  ChooseImageOperation.h
//  Example3
//
//  Created by Joel Ekström on 2018-02-05.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import "AsyncOperation.h"
@import UIKit;

@interface ImagePickerOperation : AsyncOperation

@property (nonatomic, weak, nullable) UIViewController *presentingViewController;
@property (nonatomic, readonly, nullable) UIImage *selectedImage;
@property (nonatomic, assign) BOOL shouldShowRemoveAction;

@end
