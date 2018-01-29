//
//  ImageDownloadOperation.h
//  NSOperations
//
//  Created by Joel Ekström on 2018-01-29.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface ImageRequestOperation : NSOperation

- (instancetype)initWithURL:(NSURL *)URL;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, assign) NSTimeInterval simulatedDelay;

@end
