//
//  LongRunningOperation.h
//  NSOperations
//
//  Created by Joel Ekström on 2018-01-23.
//  Copyright © 2018 Joel Ekström. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LongRunningOperation : NSOperation

@property (nonatomic, assign) NSTimeInterval timeInterval;

@end
