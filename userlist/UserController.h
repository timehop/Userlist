//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class RACSignal;

#pragma mark -

@interface UserController : NSObject

/// Sends an array of fabricated User objects then completes.
- (RACSignal *)fetchRandomUsers:(NSUInteger)numberOfUsers;

@end
