//
//  userlist
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

@class RACSignal;

#pragma mark -

@interface UserController : NSObject

/// Sends an array of fabricated User objects then completes.
/// Sends on a background thread.
- (RACSignal *)fetchUsers:(NSUInteger)numberOfUsers;

@end
